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
