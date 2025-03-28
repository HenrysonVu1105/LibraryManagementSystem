package application;

import java.sql.Date;

public class BorrowedBook {
    private String title;
    private Date borrowDate;
    private Date returnDate;

    public BorrowedBook(String title, Date borrowDate, Date returnDate) {
        this.title = title;
        this.borrowDate = borrowDate;
        this.returnDate = returnDate;
    }

    public String getTitle() {
        return title;
    }

    public Date getBorrowDate() {
        return borrowDate;
    }

    public Date getReturnDate() {
        return returnDate;
    }
}
