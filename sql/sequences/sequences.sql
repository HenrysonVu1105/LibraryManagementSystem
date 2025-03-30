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