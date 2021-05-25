
CREATE DATABASE new_users;


DROP TABLE IF EXISTS users CASCADE; 

CREATE TABLE new_users.users
(
	username	VARCHAR(50) NOT NULL,
    user_pass	VARCHAR(50) NOT NULL,
    email		VARCHAR(50) NOT NULL,
    
    CONSTRAINT user_PK PRIMARY KEY(username)
);

INSERT INTO new_users.users (username, user_pass, email) VALUES ('jezza2292', 'poolman231', 'jman290@hotmail.com');
INSERT INTO new_users.users (username, user_pass, email) VALUES ('paul_bart', 'ear11man', 'pb@gmail.com');
INSERT INTO new_users.users (username, user_pass, email) VALUES ('ren_ren21', 'bigfish11', 'rbf876@outlook.com');

SELECT * FROM new_users.users;