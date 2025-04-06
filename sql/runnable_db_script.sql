DROP TABLE STUDENT CASCADE CONSTRAINTS;
DROP TABLE Librarian CASCADE CONSTRAINTS;
DROP TABLE BOOK CASCADE CONSTRAINTS;
DROP TABLE BOOK_STATUS CASCADE CONSTRAINTS;
DROP TABLE BORROWING CASCADE CONSTRAINTS;
DROP TABLE FINE CASCADE CONSTRAINTS;
DROP TABLE TRANSACTIONS CASCADE CONSTRAINTS;
DROP TABLE REPORTS CASCADE CONSTRAINTS;

CREATE TABLE STUDENT
(
    Student_ID    NUMBER PRIMARY KEY,
    fName         VARCHAR2(50),
    lName         VARCHAR2(50),
    Gender        Varchar2(10),
    Age           NUMBER,
    Contact_ID    NUMBER,
    Student_Email VARCHAR2(100),
    Student_Pass  VARCHAR2(100),
    Address       VARCHAR2(255),
    Contact       VARCHAR2(100)
);

CREATE TABLE Librarian (
    Librarian_ID NUMBER PRIMARY KEY,
    fName VARCHAR2(50),
    lName VARCHAR2(50),
    Email VARCHAR2(100),
    Password VARCHAR2(100)
);

CREATE TABLE BOOK_STATUS
(
    Status_ID NUMBER PRIMARY KEY,
    Status_Name VARCHAR2(50)
);

CREATE TABLE BOOK
(
    Book_ID NUMBER PRIMARY KEY,
    Book_Title VARCHAR2(100),
    Book_Name VARCHAR2(100),
    Publisher VARCHAR2(100),
    Author VARCHAR2(100),
    Quantity NUMBER,
    Pub_Date DATE,
    Status_ID NUMBER,
    FOREIGN KEY (Status_ID) REFERENCES BOOK_STATUS(Status_ID)
);

CREATE TABLE BORROWING
(
    Borrowing_ID NUMBER PRIMARY KEY,
    Book_ID NUMBER,
    Student_ID NUMBER,
    Date_borrowed DATE,
    Date_return DATE,
    FOREIGN KEY (Book_ID) REFERENCES BOOK(Book_ID),
    FOREIGN KEY (Student_ID) REFERENCES STUDENT(Student_ID)
);

CREATE TABLE FINE
(
    Fine_ID NUMBER PRIMARY KEY,
    Borrowing_ID NUMBER,
    Amount NUMBER,
    Paid_Status VARCHAR2(10),
    FOREIGN KEY (borrowing_ID) REFERENCES Borrowing(borrowing_ID)
);

CREATE TABLE TRANSACTIONS
(
    Trans_ID NUMBER PRIMARY KEY,
    Trans_Name VARCHAR2(100),
    Trans_Date DATE,
    Borrowing_ID NUMBER,
    Student_ID NUMBER,
    Librarian_ID NUMBER,
    FOREIGN KEY (Borrowing_ID) REFERENCES BORROWING(Borrowing_ID),
    FOREIGN KEY (Student_ID) REFERENCES STUDENT(Student_ID),
    FOREIGN KEY (Librarian_ID) REFERENCES Librarian(Librarian_ID)
);

CREATE TABLE REPORTS
(
    Reports_ID NUMBER PRIMARY KEY,
    Reports_Desc VARCHAR2(500),
    Reports_Date DATE,
    Trans_ID NUMBER,
    Borrowing_ID NUMBER,
    FOREIGN KEY (trans_ID) REFERENCES TRANSACTIONS(trans_ID),
    FOREIGN KEY (borrowing_ID) REFERENCES Borrowing(borrowing_ID)
);

-- Initial sample data
INSERT INTO STUDENT (Student_ID, fName, lName, Gender, Age, Contact_ID, Student_Email, Student_Pass, Address, Contact)
VALUES (1, 'John', 'Doe', 'Male', 21, 101, 'johndoe@example.com', 'pass123', '123 Main St, Toronto', '123-456-7890');

INSERT INTO STUDENT (Student_ID, fName, lName, Gender, Age, Contact_ID, Student_Email, Student_Pass, Address, Contact)
VALUES(2, 'Jane', 'Smith', 'Female', 22, 102, 'janesmith@example.com', 'pass456', '456 Oak St, Toronto', '987-654-3210');

INSERT INTO LIBRARIAN (Librarian_ID, fName, lName, Email, Password)
VALUES (1, 'Alice', 'Brown', 'alice@example.com', 'lib123');

INSERT INTO LIBRARIAN (Librarian_ID, fName, lName, Email, Password)
VALUES(2, 'Bob', 'Wilson', 'bob@example.com', 'lib456');

INSERT INTO BOOK_STATUS (Status_ID, Status_Name)
VALUES (1, 'Available');

INSERT INTO BOOK_STATUS (Status_ID, Status_Name)
VALUES(2, 'Borrowed');

INSERT INTO BOOK_STATUS (Status_ID, Status_Name)
VALUES(3, 'Reserved');

INSERT INTO BOOK (Book_ID, Book_Title, Book_Name, Publisher, Author, Quantity, Pub_Date, Status_ID)
VALUES (1, 'Introduction to Java', 'Java Basics', 'Pearson', 'James Gosling', 10, TO_DATE('2021-05-10', 'YYYY-MM-DD'), 1);

INSERT INTO BOOK (Book_ID, Book_Title, Book_Name, Publisher, Author, Quantity, Pub_Date, Status_ID)
VALUES(2, 'Database Systems', 'SQL Guide', 'O’Reilly', 'Elmasri Navathe', 5, TO_DATE('2020-11-15', 'YYYY-MM-DD'), 2);

INSERT INTO BORROWING (Borrowing_ID, Book_ID, Student_ID, Date_borrowed, Date_return)
VALUES (1, 1, 1, TO_DATE('2025-03-01', 'YYYY-MM-DD'), TO_DATE('2025-03-15', 'YYYY-MM-DD'));

INSERT INTO BORROWING (Borrowing_ID, Book_ID, Student_ID, Date_borrowed, Date_return)
VALUES(2, 2, 2, TO_DATE('2025-03-05', 'YYYY-MM-DD'), TO_DATE('2025-03-20', 'YYYY-MM-DD'));

INSERT INTO FINE (Fine_ID, Borrowing_ID, Amount, Paid_Status)
VALUES (1, 1, 10.00, 'Unpaid');

INSERT INTO FINE (Fine_ID, Borrowing_ID, Amount, Paid_Status)
VALUES(2, 2, 5.00, 'Paid');

INSERT INTO TRANSACTIONS (Trans_ID, Trans_Name, Trans_Date, Borrowing_ID, Student_ID, Librarian_ID)
VALUES (1, 'Borrowed Book', TO_DATE('2025-03-01', 'YYYY-MM-DD'), 1, 1, 1);

INSERT INTO TRANSACTIONS (Trans_ID, Trans_Name, Trans_Date, Borrowing_ID, Student_ID, Librarian_ID)
VALUES(2, 'Returned Book', TO_DATE('2025-03-15', 'YYYY-MM-DD'), 1, 1, 2);

INSERT INTO REPORTS (Reports_ID, Reports_Desc, Reports_Date, Trans_ID, Borrowing_ID)
VALUES (1, 'Student borrowed Java book', TO_DATE('2025-03-01', 'YYYY-MM-DD'), 1, 1);

INSERT INTO REPORTS (Reports_ID, Reports_Desc, Reports_Date, Trans_ID, Borrowing_ID)
VALUES (2, 'Student returned SQL Guide', TO_DATE('2025-03-15', 'YYYY-MM-DD'), 2, 2);

COMMIT;
CREATE SEQUENCE book_seq        
START WITH 9
INCREMENT BY 1
NOCACHE
NOCYCLE;


CREATE SEQUENCE transactions_seq        
START WITH 5
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE borrowing_seq       
START WITH 5
INCREMENT BY 1
NOCACHE
NOCYCLE;

INSERT INTO BOOK (Book_ID, Book_Title, Book_Name, Publisher, Author, Quantity, Pub_Date, Status_ID)    
VALUES (book_seq.NEXTVAL, 'Cloud Computing', 'Cloud Basics', 'Apress', 'Thomas Erl', 6, TO_DATE('2024-02-10', 'YYYY-MM-DD'), 1);

UPDATE BOOK
SET Book_ID = book_seq.NEXTVAL
WHERE Book_ID = 8;

COMMIT;

CREATE INDEX idx_student_id ON STUDENT(Student_ID);
CREATE INDEX idx_book_title ON BOOK(Book_Title);

SELECT INDEX_NAME, TABLE_NAME FROM USER_INDEXES;

CREATE OR REPLACE TRIGGER trg_after_borrow
AFTER INSERT ON BORROWING
FOR EACH ROW
DECLARE
BEGIN
    INSERT INTO TRANSACTIONS (Trans_ID, Trans_Name, Trans_Date, Borrowing_ID, Student_ID, Librarian_ID)
    VALUES (transactions_seq.NEXTVAL, 'Book Borrowed', SYSDATE, :NEW.Borrowing_ID, :NEW.Student_ID, 1);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error in borrowing trigger: ' || SQLERRM);
END;
/

CREATE OR REPLACE TRIGGER trg_after_return
AFTER UPDATE OF Date_return ON BORROWING
FOR EACH ROW
WHEN (NEW.Date_return IS NOT NULL)
DECLARE
BEGIN
    UPDATE BOOK
    SET Status_ID = 1 
    WHERE Book_ID = :NEW.Book_ID;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error in return trigger: ' || SQLERRM);
END;
/

-- to check and update fines
CREATE OR REPLACE PROCEDURE update_fines(p_borrowing_id IN NUMBER) IS
    CURSOR fine_cur IS SELECT * FROM FINE WHERE Borrowing_ID = p_borrowing_id;
    v_fine fine%ROWTYPE;
BEGIN
    OPEN fine_cur;
    LOOP
        FETCH fine_cur INTO v_fine;
        EXIT WHEN fine_cur%NOTFOUND;
        IF v_fine.Paid_Status = 'Unpaid' THEN
            UPDATE FINE
            SET Amount = Amount + 5, Paid_Status = 'Unpaid'
            WHERE Fine_ID = v_fine.Fine_ID;
        END IF;
    END LOOP;
    CLOSE fine_cur;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error in update_fines: ' || SQLERRM);
END update_fines;
/

-- to add a new borrowing record
CREATE OR REPLACE PROCEDURE add_borrowing(p_book_id IN NUMBER, p_student_id IN NUMBER, p_date_borrowed IN DATE, p_date_return IN DATE) IS
BEGIN
    INSERT INTO BORROWING (Borrowing_ID, Book_ID, Student_ID, Date_borrowed, Date_return)
    VALUES (borrowing_seq.NEXTVAL, p_book_id, p_student_id, p_date_borrowed, p_date_return);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'Error in add_borrowing: ' || SQLERRM);
END add_borrowing;
/

-- testing procedures
BEGIN
    update_fines(1);
    add_borrowing(5, 5, TO_DATE('2025-05-01', 'YYYY-MM-DD'), TO_DATE('2025-05-15', 'YYYY-MM-DD'));
END;
/

-- pkg specification
CREATE OR REPLACE PACKAGE library_pkg IS
    g_library_name VARCHAR2(100) := 'University Library';

    PROCEDURE update_fines(p_borrowing_id IN NUMBER);
    PROCEDURE add_borrowing(p_book_id IN NUMBER, p_student_id IN NUMBER, p_date_borrowed IN DATE, p_date_return IN DATE);

    FUNCTION is_book_available(p_book_id IN NUMBER) RETURN VARCHAR2;
    FUNCTION calculate_fine(p_borrowing_id IN NUMBER) RETURN NUMBER;

END library_pkg;
/

-- pkg body
CREATE OR REPLACE PACKAGE BODY library_pkg IS

    g_private_counter NUMBER := 0;

    PROCEDURE update_fines(p_borrowing_id IN NUMBER) IS
    BEGIN
        library_pkg.update_fines(p_borrowing_id); 
    END update_fines;

    PROCEDURE add_borrowing(p_book_id IN NUMBER, p_student_id IN NUMBER, p_date_borrowed IN DATE, p_date_return IN DATE) IS
    BEGIN
        library_pkg.add_borrowing(p_book_id, p_student_id, p_date_borrowed, p_date_return);
    END add_borrowing;

    FUNCTION is_book_available(p_book_id IN NUMBER) RETURN VARCHAR2 IS
    BEGIN
        RETURN library_pkg.is_book_available(p_book_id);
    END is_book_available;

    FUNCTION calculate_fine(p_borrowing_id IN NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN library_pkg.calculate_fine(p_borrowing_id);
    END calculate_fine;

END library_pkg;
/

-- testing package 
BEGIN
    library_pkg.add_borrowing(6, 6, TO_DATE('2025-06-01', 'YYYY-MM-DD'), TO_DATE('2025-06-15', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Book 6 available: ' || library_pkg.is_book_available(6));
    DBMS_OUTPUT.PUT_LINE('Fine for borrowing 1: ' || library_pkg.calculate_fine(1));
END;
/ 

CREATE OR REPLACE FUNCTION is_book_available(p_book_id IN NUMBER) RETURN VARCHAR2 IS
    v_status_id NUMBER;
BEGIN
    SELECT Status_ID INTO v_status_id FROM BOOK WHERE Book_ID = p_book_id;
    IF v_status_id = 1 THEN
        RETURN 'Yes';
    ELSE
        RETURN 'No';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20005, 'Book not found');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20006, 'Error in is_book_available: ' || SQLERRM);
END is_book_available;
/

CREATE OR REPLACE FUNCTION calculate_fine(p_borrowing_id IN NUMBER) RETURN NUMBER IS
    v_days_overdue NUMBER;
    v_fine_amount NUMBER := 0;
BEGIN
    SELECT FLOOR(SYSDATE - Date_return) INTO v_days_overdue
    FROM BORROWING WHERE Borrowing_ID = p_borrowing_id;
    
    IF v_days_overdue > 0 THEN
        v_fine_amount := v_days_overdue * 2;
    END IF;
    RETURN v_fine_amount;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20007, 'Borrowing record not found');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20008, 'Error in calculate_fine: ' || SQLERRM);
END calculate_fine;
/

-- Test the functions
SELECT Book_ID, Book_Title, is_book_available(Book_ID) AS Available FROM BOOK;
SELECT Borrowing_ID, calculate_fine(Borrowing_ID) AS Fine_Amount FROM BORROWING;