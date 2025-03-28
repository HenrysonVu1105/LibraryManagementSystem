package controllers;

import application.DBUtil;
import application.FineRecord;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.stage.Stage;

import java.sql.*;

public class FineController {

    @FXML private TableView<FineRecord> fineTable;
    @FXML private TableColumn<FineRecord, String> colTitle;
    @FXML private TableColumn<FineRecord, String> colDueDate;
    @FXML private TableColumn<FineRecord, String> colReturnDate;
    @FXML private TableColumn<FineRecord, Integer> colFine;

    @FXML
    private void initialize() {
        colTitle.setCellValueFactory(data -> new javafx.beans.property.SimpleStringProperty(data.getValue().getTitle()));
        colDueDate.setCellValueFactory(data -> new javafx.beans.property.SimpleStringProperty(data.getValue().getDueDate().toString()));
        colReturnDate.setCellValueFactory(data -> new javafx.beans.property.SimpleStringProperty(data.getValue().getActualReturnDate().toString()));
        colFine.setCellValueFactory(data -> new javafx.beans.property.SimpleIntegerProperty(data.getValue().getFineAmount()).asObject());

        loadFines();
    }

    private void loadFines() {
        ObservableList<FineRecord> list = FXCollections.observableArrayList();

        String query = "SELECT b.Book_Title, br.Date_Return, br.Date_Actual_Return " +
                "FROM BORROWING br JOIN BOOK b ON br.Book_ID = b.Book_ID " +
                "WHERE br.Student_ID = 1 AND br.Return_Status = 'Returned'";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                String title = rs.getString("Book_Title");
                Date dueDate = rs.getDate("Date_Return");
                Date actualReturn = rs.getDate("Date_Actual_Return");

                int fine = 0;
                if (actualReturn.after(dueDate)) {
                    long daysLate = (actualReturn.getTime() - dueDate.getTime()) / (1000 * 60 * 60 * 24);
                    fine = (int) daysLate * 5;
                }

                list.add(new FineRecord(title, dueDate, actualReturn, fine));
            }

            fineTable.setItems(list);

        } catch (Exception e) {
            e.printStackTrace();
            showAlert("Error", "Failed to load fine data: " + e.getMessage());
        }
    }

    @FXML
    private void handleClose() {
        Stage stage = (Stage) fineTable.getScene().getWindow();
        stage.close();
    }

    private void showAlert(String title, String msg) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(msg);
        alert.showAndWait();
    }
}
