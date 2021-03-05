# start after install vitess operator 
kubectl apply -f 101.yaml 

vtctlclient ApplySchema -sql="$(cat create_commerce_schema.sql)" sbtest
vtctlclient ApplyVSchema -vschema="$(cat vschema_sbtest_inital.json)" sbtest 

mysql -h 192.168.14.172 -uuser sbtest < sbtest1.sql &
mysql -h 192.168.14.172 -uuser sbtest < sbtest2.sql &
mysql -e "select count(*) from sbtest.sbtest1"
mysql -e "select count(*) from sbtest.sbtest2"
mysql --table --execute="show vitess_tablets"

kubectl apply -f 201.yaml

vtctlclient MoveTables -workflow=sb2sb1 sbtest sbtest1 '{"sbtest1":{}, "sbtest2":{}}'

mysql -e "select count(*) from sbtest.sbtest1"
mysql -e "select count(*) from sbtest.sbtest2"

mysql -e "select count(*) from sbtest1.sbtest1"
mysql -e "select count(*) from sbtest1.sbtest2"

vtctlclient SwitchReads -tablet_type=rdonly sbtest1.sb2sb1
vtctlclient SwitchReads -tablet_type=replica sbtest1.sb2sb1

vtctlclient ApplySchema -sql="$(cat create_sbtest1_seq.sql)" sbtest
CREATE TABLE sbtest1_seq (id int, next_id bigint, cache bigint, primary key(id)) comment 'vitess_sequence';
INSERT INTO sbtest1_seq (id, next_id, cache) VALUES (0, 1000, 1000);
CREATE TABLE sbtest2_seq (id int, next_id bigint, cache bigint, primary key(id)) comment 'vitess_sequence';
INSERT INTO sbtest2_seq (id, next_id, cache) VALUES (0, 1000, 1000);

vtctlclient ApplyVSchema -vschema="$(cat vschema_sbtest1_seq.json)" sbtest
vtctlclient ApplyVSchema -vschema="$(cat vschema_sbtest1_shared.json)" sbtest1
# vtctlclient ApplySchema -sql="$(cat create_customer_sharded.sql)" customer # already modified 

kubectl apply -f 302.yaml

vtctlclient Reshard sbtest1.cust2cust '-' '-80,80-'

vtctlclient SwitchReads -tablet_type=rdonly sbtest1.cust2cust
vtctlclient SwitchReads -tablet_type=replica sbtest1.cust2cust
vtctlclient SwitchWrites sbtest1.cust2cust

mysql -h 192.168.14.172 -uuser --table -e "show vitess_tablets"

mysql -e "select count(*) from sbtest.sbtest1"
mysql -e "select count(*) from sbtest.sbtest2"

mysql -e "select count(*) from sbtest1.sbtest1"
mysql -e "select count(*) from sbtest1.sbtest2"

mysql -e "use sbtest1/-80; select count(*) from sbtest1"
mysql -e "use sbtest1/80-; select count(*) from sbtest1"

mysql -e "use sbtest1/-80; select count(*) from sbtest2"
mysql -e "use sbtest1/80-; select count(*) from sbtest2"

kubectl apply -f 306.yaml
