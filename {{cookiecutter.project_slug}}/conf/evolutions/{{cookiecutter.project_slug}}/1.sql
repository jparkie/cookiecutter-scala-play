--- !Ups

CREATE TABLE example (
    id          VARCHAR(16) NOT NULL,
    PRIMARY KEY (id)
);

-- !Downs

DROP TABLE IF EXISTS example;
