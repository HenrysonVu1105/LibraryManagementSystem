package controllers;

import application.Book;
import application.DBUtil;
import application.Session;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.stage.Stage;
import javafx.scene.Node;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class DashboardController {

    @FXML private TableView<Book> booksTable;
    @FXML private TableColumn<Book, String> colTitle;
    @FXML private TableColumn<Book, String> colAuthor;
    @FXML private TableColumn<Book, String> colPublisher;
    @FXML private TableColumn<Book, Integer> colQuantity;
    @FXML private TableColumn<Book, Void> colAction;
    @FXML private Label welcomeLabel;

    @FXML
    private void initialize() {
        if (welcomeLabel != null) {
            welcomeLabel.setText("Welcome, " + Session.getStudentName() + "!");
        }

        colTitle.setCellValueFactory(new PropertyValueFactory<>("title"));
        colAuthor.setCellValueFactory(new PropertyValueFactory<>("author"));
        colPublisher.setCellValueFactory(new PropertyValueFactory<>("publisher"));
        colQuantity.setCellValueFactory(new PropertyValueFactory<>("quantity"));

        addBorrowButtonToTable();
    }

    @FXML
    private void handleLoadBooks() {
        ObservableList<Book> bookList = FXCollections.observableArrayList();

        // 🔁 Only get books that are in stock
        String query = "SELECT Book_ID, Book_Title, Author, Publisher, Quantity FROM BOOK WHERE Quantity > 0";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                bookList.add(new Book(
                        rs.getInt("Book_ID"),
                        rs.getString("Book_Title"),
                        rs.getString("Author"),
                        rs.getString("Publisher"),
                        rs.getInt("Quantity")
                ));
            }

            booksTable.setItems(bookList);

            // Optional: Alert if no books available
            if (bookList.isEmpty()) {
                showAlert("Notice", "No books are currently available for borrowing.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            showAlert("Error", "Failed to load books: " + e.getMessage());
        }
    }

    private void handleBorrow(Book book) {
        try (Connection conn = DBUtil.getConnection()) {
            String insertQuery = "INSERT INTO BORROWING (Book_ID, Student_ID, Date_Borrowed, Date_Return) " +
                    "VALUES (?, ?, SYSDATE, SYSDATE + 14)";

            PreparedStatement stmt = conn.prepareStatement(insertQuery);
            stmt.setInt(1, book.getBookId());
            stmt.setInt(2, Session.getStudentId());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                showAlert("Success", "Book borrowed successfully for 14 days.");
                handleLoadBooks(); // 🔄 Refresh table
            } else {
                showAlert("Failed", "Unable to borrow the book.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            showAlert("Error", "Database error: " + e.getMessage());
        }
    }

    private void addBorrowButtonToTable() {
        colAction.setCellFactory(param -> new TableCell<Book, Void>() {
            private final Button borrowBtn = new Button("Borrow");

            {
                borrowBtn.setOnAction(event -> {
                    Book selectedBook = (Book) getTableView().getItems().get(getIndex());
                    handleBorrow(selectedBook);
                });
            }

            @Override
            protected void updateItem(Void item, boolean empty) {
                super.updateItem(item, empty);
                if (empty) {
                    setGraphic(null);
                } else {
                    setGraphic(borrowBtn);
                }
            }
        });
    }

    @FXML
    private void handleViewHistory() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/views/history.fxml"));
            Stage stage = new Stage();
            stage.setTitle("Borrowing History");
            stage.setScene(new Scene(loader.load()));
            stage.show();
        } catch (Exception e) {
            e.printStackTrace();
            showAlert("Error", "Failed to load history screen.");
        }
    }

    @FXML
    private void handleReturnBook() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/views/return.fxml"));
            Stage stage = new Stage();
            stage.setTitle("Return Borrowed Books");
            stage.setScene(new Scene(loader.load()));
            stage.show();
        } catch (Exception e) {
            e.printStackTrace();
            showAlert("Error", "Failed to open return screen.");
        }
    }

    @FXML
    private void handleViewFines() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/views/fines.fxml"));
            Stage stage = new Stage();
            stage.setTitle("Fines");
            stage.setScene(new Scene(loader.load()));
            stage.show();
        } catch (Exception e) {
            e.printStackTrace();
            showAlert("Error", "Failed to load fines screen.");
        }
    }

    @FXML
    private void handleLogout(ActionEvent event) {
        Session.clear();
        showAlert("Logout", "You have been logged out successfully.");
        Stage stage = (Stage)((Node)event.getSource()).getScene().getWindow();
        stage.close();
    }

    private void showAlert(String title, String msg) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(msg);
        alert.showAndWait();
    }
}
