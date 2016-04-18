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
  post_time VARCHAR(100),
  reading_time INTEGER,
  likes INTEGER,
  image_url VARCHAR(200)
);



CREATE TABLE comments (
  id SERIAL4 PRIMARY KEY,
  body VARCHAR(1000),
  post_id INTEGER
);