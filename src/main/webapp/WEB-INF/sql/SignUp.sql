create table SignUp(
user_ID VARCHAR2(36) primary key ,
user_PW VARCHAR2(36) not null ,
user_Email VARCHAR2(100) not null ,
user_NickName VARCHAR2(50) not null
);

insert into SignUp(user_ID, user_PW, user_Email, user_NickName)
VALUES('gwangrim11', '1234567', 'rhkdfla11@naver.com', '홍길동');

commit;