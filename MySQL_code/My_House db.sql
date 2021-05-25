-- CREATE DATABASE My_House;

DROP TABLE IF EXISTS rooms CASCADE;
DROP TABLE IF EXISTS bills CASCADE;
DROP TABLE IF EXISTS issues CASCADE;



-- Creates the house_rooms TABLE
CREATE TABLE rooms
(
    room_id     INT NOT NULL AUTO_INCREMENT,
    room_name   VARCHAR(50) NOT NULL,

    CONSTRAINT rooms_PK PRIMARY KEY (room_name)
);

-- Creates the house_bills TABLE
CREATE TABLE bills
(
    bill_id         INT NOT NULL AUTO_INCREMENT,
    bill_name       VARCHAR(50) NOT NULL,
    bill_amount_per_month     DOUBLE NOT NULL,

    CONSTRAINT bills_PK PRIMARY KEY (bill_id)

);

-- Creates the house_issues Table
CREATE TABLE issues
(
    room_name      VARCHAR(50) NOT NULL,
    issue_id       INT NOT NULL AUTO_INCREMENT,
    issue_name     VARCHAR(50) NOT NULL,
    issue_fixed    BOOLEAN NOT NULL,

    PRIMARY KEY (issue_id),

    FOREIGN KEY (room_name)
		REFERENCES rooms (room_name)
		ON DELETE RESTRICT 
		ON UPDATE CASCADE,
    
    CONSTRAINT fixed_constraint CHECK 
        (
            issue_fixed = 'y' OR 
            issue_fixed = 'n'
        )
);

-- Values for rooms table
INSERT INTO rooms (room_name) VALUES ('Kitchen');
INSERT INTO rooms (room_name) VALUES ('Living Room');
INSERT INTO rooms (room_name) VALUES ('Main Bedroom');
INSERT INTO rooms (room_name) VALUES ('Second Bedroom');
INSERT INTO rooms (room_name) VALUES ('Backyard');
INSERT INTO rooms (room_name) VALUES ('Garage');

-- Values for bills table
INSERT INTO bills (bill_name, bill_amount_per_month) VALUES ('AHPRA Registration', 13.46);
INSERT INTO bills (bill_name, bill_amount_per_month) VALUES ('Ausmed Subscription', 27.69);
INSERT INTO bills (bill_name, bill_amount_per_month) VALUES ('Car Registration', 63.79);
INSERT INTO bills (bill_name, bill_amount_per_month) VALUES ('AnimeLab Subscription', 6.63);
INSERT INTO bills (bill_name, bill_amount_per_month) VALUES ('Isagenix', 212.0);
INSERT INTO bills (bill_name, bill_amount_per_month) VALUES ('NSW Nursing Union', 60.2);
INSERT INTO bills (bill_name, bill_amount_per_month) VALUES ('Netflix', 13.99);
INSERT INTO bills (bill_name, bill_amount_per_month) VALUES ('Online Person Training', 265.4);
INSERT INTO bills (bill_name, bill_amount_per_month) VALUES ('Ring Insurance', 10.38);
INSERT INTO bills (bill_name, bill_amount_per_month) VALUES ('Sky Credit Card', 153.78);
INSERT INTO bills (bill_name, bill_amount_per_month) VALUES ('Spotify', 11.99);
INSERT INTO bills (bill_name, bill_amount_per_month) VALUES ('TPG Internt', 59.99);
INSERT INTO bills (bill_name, bill_amount_per_month) VALUES ('Xbox Gold Subscription', 6.15);

SELECT * FROM bills;
SELECT * FROM rooms;
