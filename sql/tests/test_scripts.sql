-- tables
SELECT * FROM STUDENT FETCH FIRST 5 ROWS ONLY;
SELECT * FROM BOOK FETCH FIRST 5 ROWS ONLY;
SELECT * FROM BORROWING FETCH FIRST 5 ROWS ONLY;

-- sequences
INSERT INTO BOOK (Book_ID, Book_Title, Book_Name, Publisher, Author, Quantity, Pub_Date, Status_ID)
VALUES (book_seq.NEXTVAL, 'Test Book', 'Test Name', 'Test Pub', 'Test Author', 1, SYSDATE, 1);

-- indexes
EXPLAIN PLAN FOR SELECT * FROM STUDENT WHERE Student_ID = 1;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- triggers
INSERT INTO BORROWING (Borrowing_ID, Book_ID, Student_ID, Date_borrowed, Date_return)
VALUES (borrowing_seq.NEXTVAL, 1, 1, SYSDATE, SYSDATE + 14);
SELECT * FROM TRANSACTIONS WHERE Trans_Name = 'Book Borrowed';

-- procedures
BEGIN
    update_fines(1);
    add_borrowing(7, 7, SYSDATE, SYSDATE + 14);
END;
/

-- functions
SELECT Book_ID, is_book_available(Book_ID) AS Available FROM BOOK WHERE Book_ID = 1;
SELECT Borrowing_ID, calculate_fine(Borrowing_ID) AS Fine_Amount FROM BORROWING WHERE Borrowing_ID = 1;

-- packages
BEGIN
    library_pkg.add_borrowing(8, 8, SYSDATE, SYSDATE + 14);
    DBMS_OUTPUT.PUT_LINE('Book 8 available: ' || library_pkg.is_book_available(8));
    DBMS_OUTPUT.PUT_LINE('Fine for borrowing 1: ' || library_pkg.calculate_fine(1));
END;
/

COMMIT;