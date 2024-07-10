/*
create table Customer (
	CustID CHAR(5) NOT NULL,
	CustName VARCHAR(30) NOT NULL,
	CustAddress VARCHAR(80) NOT NULL,
	CustContact VARCHAR(13) NOT NULL,
	CustDOB DATE NOT NULL,
primary key(CustID),
constraint chk_custID check (REGEXP_LIKE(CustID,'^CU\d{3}$')),
constraint chk_custContact check (REGEXP_LIKE(CustContact, '^01[0-9]-[0-9]{3,4}\s[0-9]{4}$')),
constraint chk_custDOB check (CustDOB BETWEEN TO_DATE('1900-01-01', 'YYYY-MM-DD') AND TO_DATE('2004-12-31', 'YYYY-MM-DD'))
);
*/


DROP TABLE InsertCustomer;
DROP TABLE UpdateCustomer;
DROP TABLE DeleteCustomer;


CREATE TABLE InsertCustomer (
    CustID CHAR(5) NOT NULL,
    CustName VARCHAR(30) NOT NULL,
    CustAddress VARCHAR(80) NOT NULL,
    CustContact VARCHAR(13) NOT NULL,
    CustDOB DATE NOT NULL,
    UserID         VARCHAR(30),   
    TransDate  DATE,
    TransTime CHAR(8)
);

CREATE TABLE UpdateCustomer (
    OldCustID CHAR(5) NOT NULL,
    OldCustName VARCHAR(30) NOT NULL,
    NewCustName VARCHAR(30) NOT NULL,
    OldCustAddress VARCHAR(80) NOT NULL,
    NewCustAddress VARCHAR(80) NOT NULL,
    OldCustContact VARCHAR(13) NOT NULL,
    NewCustContact VARCHAR(13) NOT NULL,
    OldCustDOB DATE NOT NULL,
    NewCustDOB DATE NOT NULL,
    UserID         VARCHAR(30),   
    TransDate  DATE,
    TransTime CHAR(8)
);

CREATE TABLE DeleteCustomer (
    CustID CHAR(5) NOT NULL,
    CustName VARCHAR(30) NOT NULL,
    CustAddress VARCHAR(80) NOT NULL,
    CustContact VARCHAR(13) NOT NULL,
    CustDOB DATE NOT NULL,
    UserID         VARCHAR(30),   
    TransDate  DATE,
    TransTime CHAR(8)
);


--trigger tracking customer
CREATE OR REPLACE TRIGGER trg_track_Customer
AFTER INSERT OR UPDATE OR DELETE ON Customer
FOR EACH ROW
BEGIN
    CASE
        WHEN INSERTING THEN
            INSERT INTO InsertCustomer
            VALUES(:NEW.CustID, :NEW.CustName, :NEW.CustAddress, :NEW.CustContact, :NEW.CustDOB, USER, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'));
        WHEN UPDATING THEN
            INSERT INTO UpdateCustomer
            VALUES(:OLD.CustID, :OLD.CustName, :NEW.CustName, :OLD.CustAddress, :NEW.CustAddress, 
                   :OLD.CustContact, :NEW.CustContact, :OLD.CustDOB, :NEW.CustDOB, USER, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'));
        WHEN DELETING THEN
            INSERT INTO DeleteCustomer
            VALUES(:OLD.CustID, :OLD.CustName, :OLD.CustAddress, :OLD.CustContact, :OLD.CustDOB, USER, SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'));
    END CASE;
END;
/


INSERT INTO Customer VALUES ('CU405', 'Tan Pei Ling', '45 Jalan Cerah, Taman Bahagia Murni, 46040 Setapak, Kuala Lumpur', '019-012 3456', '30/12/1987');

INSERT INTO Customer VALUES ('CU406', 'Eric Heng', '3 Jalan Raya, Taman Bahagia Murni, 46040 Setapak, Kuala Lumpur', '019-233 3116', '30/12/1987');


UPDATE Customer
SET CustContact = '010-324 8283'
WHERE CustID = 'CU001';

DELETE FROM Customer
WHERE CustID = 'CU406';

SELECT * FROM InsertCustomer;
SELECT * FROM UpdateCustomer;
SELECT * FROM DeleteCustomer;


