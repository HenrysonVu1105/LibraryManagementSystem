CREATE INDEX idx_student_id ON STUDENT(Student_ID);
CREATE INDEX idx_book_title ON BOOK(Book_Title);

SELECT INDEX_NAME, TABLE_NAME FROM USER_INDEXES;