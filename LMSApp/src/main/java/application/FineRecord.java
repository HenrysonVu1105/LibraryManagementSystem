package application;

import java.sql.Date;

public class FineRecord {
    private String title;
    private Date dueDate;
    private Date actualReturnDate;
    private int fineAmount;

    public FineRecord(String title, Date dueDate, Date actualReturnDate, int fineAmount) {
        this.title = title;
        this.dueDate = dueDate;
        this.actualReturnDate = actualReturnDate;
        this.fineAmount = fineAmount;
    }

    public String getTitle() {
        return title;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public Date getActualReturnDate() {
        return actualReturnDate;
    }

    public int getFineAmount() {
        return fineAmount;
    }
}
