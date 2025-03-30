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