CREATE DATABASE blogdb;

CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  email VARCHAR(100) NOT NULL,
  password_digest VARCHAR(200) NOT NULL
);

CREATE TABLE posts (
  id SERIAL4 PRIMARY KEY,
  user_id INTEGER,
  title VARCHAR(100),
  body TEXT,
  post_time DATETIME,
  reading_time INTEGER,
  likes INTEGER,
  image_url VARCHAR(200)
);

ALTER TABLE posts DROP COLUMN post_time;
ALTER TABLE posts ADD COLUMN post_time timestamp without time zone;
ALTER TABLE posts DROP COLUMN likes;
ALTER TABLE posts ADD COLUMN liked_by INTEGER[];
ALTER TABLE posts ADD COLUMN post_type_id INTEGER;

CREATE TABLE comments (
  id SERIAL4 PRIMARY KEY,
  body VARCHAR(1000),
  post_id INTEGER
);

CREATE TABLE post_types (
  id SERIAL4 PRIMARY KEY,
  type_name VARCHAR(100) NOT NULL
);

