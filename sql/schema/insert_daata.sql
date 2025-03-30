---------------------------------------------additional data to complete 10 rows--------------------------------------------------
INSERT INTO STUDENT (Student_ID, fName, lName, Gender, Age, Contact_ID, Student_Email, Student_Pass, Address, Contact)
VALUES (3, 'Michael', 'Johnson', 'Male', 20, 103, 'michaelj@example.com', 'pass789', '789 Pine St, Toronto', '456-789-0123');
INSERT INTO STUDENT (Student_ID, fName, lName, Gender, Age, Contact_ID, Student_Email, Student_Pass, Address, Contact)
VALUES (4, 'Sarah', 'Davis', 'Female', 23, 104, 'sarahd@example.com', 'passabc', '321 Elm St, Toronto', '789-012-3456');
INSERT INTO STUDENT (Student_ID, fName, lName, Gender, Age, Contact_ID, Student_Email, Student_Pass, Address, Contact)
VALUES (5, 'David', 'Wilson', 'Male', 19, 105, 'davidw@example.com', 'passdef', '654 Maple St, Toronto', '234-567-8901');
INSERT INTO STUDENT (Student_ID, fName, lName, Gender, Age, Contact_ID, Student_Email, Student_Pass, Address, Contact)
VALUES (6, 'Emily', 'Brown', 'Female', 22, 106, 'emilyb@example.com', 'passghi', '987 Cedar St, Toronto', '678-901-2345');
INSERT INTO STUDENT (Student_ID, fName, lName, Gender, Age, Contact_ID, Student_Email, Student_Pass, Address, Contact)
VALUES (7, 'James', 'Taylor', 'Male', 21, 107, 'jamest@example.com', 'passjkl', '147 Oak St, Toronto', '890-123-4567');
INSERT INTO STUDENT (Student_ID, fName, lName, Gender, Age, Contact_ID, Student_Email, Student_Pass, Address, Contact)
VALUES (8, 'Lisa', 'Anderson', 'Female', 20, 108, 'lisaa@example.com', 'passmno', '258 Pine St, Toronto', '012-345-6789');
INSERT INTO STUDENT (Student_ID, fName, lName, Gender, Age, Contact_ID, Student_Email, Student_Pass, Address, Contact)
VALUES (9, 'Robert', 'Martinez', 'Male', 24, 109, 'robertm@example.com', 'passpqr', '369 Elm St, Toronto', '345-678-9012');
INSERT INTO STUDENT (Student_ID, fName, lName, Gender, Age, Contact_ID, Student_Email, Student_Pass, Address, Contact)
VALUES (10, 'Anna', 'Lee', 'Female', 23, 110, 'annal@example.com', 'passstu', '741 Maple St, Toronto', '567-890-1234');

INSERT INTO LIBRARIAN (Librarian_ID, fName, lName, Email, Password)
VALUES (3, 'Carol', 'Green', 'carol@example.com', 'lib789');
INSERT INTO LIBRARIAN (Librarian_ID, fName, lName, Email, Password)
VALUES (4, 'David', 'Clark', 'davidc@example.com', 'libabc');
INSERT INTO LIBRARIAN (Librarian_ID, fName, lName, Email, Password)
VALUES (5, 'Emma', 'White', 'emma@example.com', 'libdef');

INSERT INTO BOOK_STATUS (Status_ID, Status_Name)
VALUES (4, 'Lost');
INSERT INTO BOOK_STATUS (Status_ID, Status_Name)
VALUES (5, 'Damaged');

INSERT INTO BOOK (Book_ID, Book_Title, Book_Name, Publisher, Author, Quantity, Pub_Date, Status_ID)
VALUES (3, 'Python Programming', 'Python Essentials', 'Packt', 'Mark Lutz', 8, TO_DATE('2022-01-20', 'YYYY-MM-DD'), 1);
INSERT INTO BOOK (Book_ID, Book_Title, Book_Name, Publisher, Author, Quantity, Pub_Date, Status_ID)
VALUES (4, 'Web Development', 'HTML/CSS Basics', 'Wrox', 'Jon Duckett', 6, TO_DATE('2021-09-15', 'YYYY-MM-DD'), 2);
INSERT INTO BOOK (Book_ID, Book_Title, Book_Name, Publisher, Author, Quantity, Pub_Date, Status_ID)
VALUES (5, 'Data Structures', 'Algorithms in C', 'Addison-Wesley', 'Robert Sedgewick', 7, TO_DATE('2020-03-10', 'YYYY-MM-DD'), 1);
INSERT INTO BOOK (Book_ID, Book_Title, Book_Name, Publisher, Author, Quantity, Pub_Date, Status_ID)
VALUES (6, 'Machine Learning', 'ML Basics', 'Springer', 'Andrew Ng', 5, TO_DATE('2023-06-01', 'YYYY-MM-DD'), 3);
INSERT INTO BOOK (Book_ID, Book_Title, Book_Name, Publisher, Author, Quantity, Pub_Date, Status_ID)
VALUES (7, 'Networking Fundamentals', 'Network Guide', 'Cisco Press', 'Todd Lammle', 9, TO_DATE('2019-12-05', 'YYYY-MM-DD'), 1);
INSERT INTO BOOK (Book_ID, Book_Title, Book_Name, Publisher, Author, Quantity, Pub_Date, Status_ID)
VALUES (8, 'Software Engineering', 'SE Principles', 'McGraw-Hill', 'Roger Pressman', 4, TO_DATE('2021-07-20', 'YYYY-MM-DD'), 2);

INSERT INTO BORROWING (Borrowing_ID, Book_ID, Student_ID, Date_borrowed, Date_return)
VALUES (3, 3, 3, TO_DATE('2025-04-01', 'YYYY-MM-DD'), TO_DATE('2025-04-15', 'YYYY-MM-DD'));
INSERT INTO BORROWING (Borrowing_ID, Book_ID, Student_ID, Date_borrowed, Date_return)
VALUES (4, 4, 4, TO_DATE('2025-04-05', 'YYYY-MM-DD'), TO_DATE('2025-04-20', 'YYYY-MM-DD'));

INSERT INTO FINE (Fine_ID, Borrowing_ID, Amount, Paid_Status)
VALUES (3, 3, 15.00, 'Unpaid');
INSERT INTO FINE (Fine_ID, Borrowing_ID, Amount, Paid_Status)
VALUES (4, 4, 8.00, 'Paid');

INSERT INTO TRANSACTIONS (Trans_ID, Trans_Name, Trans_Date, Borrowing_ID, Student_ID, Librarian_ID)
VALUES (3, 'Borrowed Python book', TO_DATE('2025-04-01', 'YYYY-MM-DD'), 3, 3, 3);
INSERT INTO TRANSACTIONS (Trans_ID, Trans_Name, Trans_Date, Borrowing_ID, Student_ID, Librarian_ID)
VALUES (4, 'Returned HTML book', TO_DATE('2025-04-20', 'YYYY-MM-DD'), 4, 4, 4);

INSERT INTO REPORTS (Reports_ID, Reports_Desc, Reports_Date, Trans_ID, Borrowing_ID)
VALUES (3, 'Student borrowed Python book', TO_DATE('2025-04-01', 'YYYY-MM-DD'), 3, 3);
INSERT INTO REPORTS (Reports_ID, Reports_Desc, Reports_Date, Trans_ID, Borrowing_ID)
VALUES (4, 'Student returned HTML book', TO_DATE('2025-04-20', 'YYYY-MM-DD'), 4, 4);

COMMIT;