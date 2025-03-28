package application;

public class Book {
    private int bookId;
    private String title;
    private String author;
    private String publisher;
    private int quantity;

    public Book(int bookId, String title, String author, String publisher, int quantity) {
        this.bookId = bookId;
        this.title = title;
        this.author = author;
        this.publisher = publisher;
        this.quantity = quantity;
    }

    public int getBookId() {
        return bookId;
    }

    public String getTitle() {
        return title;
    }

    public String getAuthor() {
        return author;
    }

    public String getPublisher() {
        return publisher;
    }

    public int getQuantity() {
        return quantity;
    }
}
