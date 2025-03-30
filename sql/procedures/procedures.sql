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