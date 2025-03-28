package controllers;

import application.DBUtil;
import application.ReturnableBook;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.stage.Stage;
import javafx.util.Callback;


import java.sql.*;

public class ReturnController {

    @FXML private TableView<ReturnableBook> returnTable;
    @FXML private TableColumn<ReturnableBook, String> colTitle;
    @FXML private TableColumn<ReturnableBook, String> colBorrowDate;
    @FXML private TableColumn<ReturnableBook, String> colReturnDate;
    @FXML private TableColumn<ReturnableBook, Void> colAction;

    @FXML
    private void initialize() {
        colTitle.setCellValueFactory(data -> new javafx.beans.property.SimpleStringProperty(data.getValue().getTitle()));
        colBorrowDate.setCellValueFactory(data -> new javafx.beans.property.SimpleStringProperty(data.getValue().getBorrowDate().toString()));
        colReturnDate.setCellValueFactory(data -> new javafx.beans.property.SimpleStringProperty(data.getValue().getReturnDate().toString()));
        addReturnButtonToTable();
        loadReturnableBooks();
    }

    private void loadReturnableBooks() {
        ObservableList<ReturnableBook> list = FXCollections.observableArrayList();

        String query = "SELECT br.Borrowing_ID, b.Book_Title, br.Date_Borrowed, br.Date_Return " +
                "FROM BORROWING br JOIN BOOK b ON br.Book_ID = b.Book_ID " +
                "WHERE br.Student_ID = 1 AND br.Return_Status = 'Not Returned'";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                list.add(new ReturnableBook(
                        rs.getInt("Borrowing_ID"),
                        rs.getString("Book_Title"),
                        rs.getDate("Date_Borrowed"),
                        rs.getDate("Date_Return")
                ));
            }

            returnTable.setItems(list);

        } catch (Exception e) {
            e.printStackTrace();
            showAlert("Error", "Failed to load returnable books: " + e.getMessage());
        }
    }

    private void addReturnButtonToTable() {
        colAction.setCellFactory(new Callback<TableColumn<ReturnableBook, Void>, TableCell<ReturnableBook, Void>>() {
            @Override
            public TableCell<ReturnableBook, Void> call(final TableColumn<ReturnableBook, Void> param) {
                return new TableCell<ReturnableBook, Void>() {
                    private final Button returnBtn = new Button("Return");

                    {
                        returnBtn.setOnAction(event -> {
                            ReturnableBook book = (ReturnableBook) getTableView().getItems().get(getIndex());
                            returnBook(book);
                        });
                    }

                    @Override
                    protected void updateItem(Void item, boolean empty) {
                        super.updateItem(item, empty);
                        if (empty) {
                            setGraphic(null);
                        } else {
                            setGraphic(returnBtn);
                        }
                    }
                };
            }
        });
    }

    private void returnBook(ReturnableBook book) {
        String update = "UPDATE BORROWING SET Return_Status = 'Returned' WHERE Borrowing_ID = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(update)) {

            stmt.setInt(1, book.getBorrowId());
            int rows = stmt.executeUpdate();

            if (rows > 0) {
                showAlert("Success", "Book returned successfully!");
                loadReturnableBooks(); // Refresh table
            } else {
                showAlert("Failed", "Could not return the book.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            showAlert("Error", "Database error: " + e.getMessage());
        }
    }

    @FXML
    private void handleClose() {
        Stage stage = (Stage) returnTable.getScene().getWindow();
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
