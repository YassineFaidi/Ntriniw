-- database creation
CREATE database Ntriniw_v1;

-- users table creation
CREATE TABLE users (
    id INT(11) NOT NULL AUTO_INCREMENT,
    username VARCHAR(25) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL,
    password VARCHAR(64) NOT NULL,
    profileImg MEDIUMBLOB NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

