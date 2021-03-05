CREATE TABLE sbtest1_seq (id int, next_id bigint, cache bigint, primary key(id)) comment 'vitess_sequence';
INSERT INTO sbtest1_seq (id, next_id, cache) VALUES (0, 1000, 1000);
CREATE TABLE sbtest2_seq (id int, next_id bigint, cache bigint, primary key(id)) comment 'vitess_sequence';
INSERT INTO sbtest1_seq (id, next_id, cache) VALUES (0, 1000, 1000);

