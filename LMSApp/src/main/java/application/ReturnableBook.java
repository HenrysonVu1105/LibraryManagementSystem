package application;

import java.sql.Date;

public class ReturnableBook {
    private int borrowId;
    private String title;
    private Date borrowDate;
    private Date returnDate;

    public ReturnableBook(int borrowId, String title, Date borrowDate, Date returnDate) {
        this.borrowId = borrowId;
        this.title = title;
        this.borrowDate = borrowDate;
        this.returnDate = returnDate;
    }

    public int getBorrowId() { return borrowId; }
    public String getTitle() { return title; }
    public Date getBorrowDate() { return borrowDate; }
    public Date getReturnDate() { return returnDate; }
}
