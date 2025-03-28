package controllers;

import application.BorrowedBook;
import application.DBUtil;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.stage.Stage;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class HistoryController {

    @FXML private TableView<BorrowedBook> historyTable;
    @FXML private TableColumn<BorrowedBook, String> colTitle;
    @FXML private TableColumn<BorrowedBook, String> colBorrow;
    @FXML private TableColumn<BorrowedBook, String> colReturn;

    @FXML
    private void initialize() {
        colTitle.setCellValueFactory(data -> new javafx.beans.property.SimpleStringProperty(data.getValue().getTitle()));
        colBorrow.setCellValueFactory(data -> new javafx.beans.property.SimpleStringProperty(data.getValue().getBorrowDate().toString()));
        colReturn.setCellValueFactory(data -> new javafx.beans.property.SimpleStringProperty(data.getValue().getReturnDate().toString()));

        loadHistory();
    }

    private void loadHistory() {
        ObservableList<BorrowedBook> history = FXCollections.observableArrayList();

        String query = "SELECT b.Book_Title, br.Date_Borrowed, br.Date_Return " +
                "FROM BORROWING br JOIN BOOK b ON br.Book_ID = b.Book_ID " +
                "WHERE br.Student_ID = 1";  // Replace with actual user ID later

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                history.add(new BorrowedBook(
                        rs.getString("Book_Title"),
                        rs.getDate("Date_Borrowed"),
                        rs.getDate("Date_Return")
                ));
            }

            historyTable.setItems(history);

        } catch (Exception e) {
            e.printStackTrace();
            showAlert("Error", "Failed to load history: " + e.getMessage());
        }
    }

    private void showAlert(String title, String msg) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(msg);
        alert.showAndWait();
    }

    @FXML
    private void handleClose() {
        Stage stage = (Stage) historyTable.getScene().getWindow();
        stage.close();
    }
}
