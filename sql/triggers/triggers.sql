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