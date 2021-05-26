CREATE TABLE favorite(
   name VARCHAR2(100) not null,
   link VARCHAR2(50) not null,
   id VARCHAR2(50) not null REFERENCES signup(USER_ID) ON DELETE CASCADE
);