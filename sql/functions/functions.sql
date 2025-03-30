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