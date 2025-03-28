package controllers;

import application.DBUtil;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.stage.Stage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class RegisterController {

    @FXML private TextField nameField;
    @FXML private TextField emailField;
    @FXML private PasswordField passField;
    @FXML private PasswordField confirmPassField;

    @FXML
    private void handleRegister() {
        String name = nameField.getText().trim();
        String email = emailField.getText().trim();
        String pass = passField.getText().trim();
        String confirmPass = confirmPassField.getText().trim();

        if (name.isEmpty() || email.isEmpty() || pass.isEmpty() || confirmPass.isEmpty()) {
            showAlert(Alert.AlertType.WARNING, "Missing Fields", "Please fill in all fields.");
            return;
        }

        if (!pass.equals(confirmPass)) {
            showAlert(Alert.AlertType.WARNING, "Mismatch", "Passwords do not match.");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            // Check if email already exists
            String checkQuery = "SELECT * FROM STUDENT WHERE Student_Email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                showAlert(Alert.AlertType.ERROR, "Already Registered", "Email is already in use.");
                return;
            }

            // Insert new student
            String insertQuery = "INSERT INTO STUDENT (fName, Student_Email, Student_Pass) VALUES (?, ?, ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
            insertStmt.setString(1, name);
            insertStmt.setString(2, email);
            insertStmt.setString(3, pass);

            int rows = insertStmt.executeUpdate();
            if (rows > 0) {
                showAlert(Alert.AlertType.INFORMATION, "Success", "Registration successful! Please login.");
                handleBack();
            } else {
                showAlert(Alert.AlertType.ERROR, "Error", "Failed to register.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            showAlert(Alert.AlertType.ERROR, "Database Error", e.getMessage());
        }
    }

    @FXML
    private void handleBack() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/views/login.fxml"));
            Stage stage = new Stage();
            stage.setTitle("Login");
            stage.setScene(new Scene(loader.load()));
            stage.show();

            Stage currentStage = (Stage) nameField.getScene().getWindow();
            currentStage.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void showAlert(Alert.AlertType type, String title, String msg) {
        Alert alert = new Alert(type);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(msg);
        alert.showAndWait();
    }
}
