package controllers;

import application.DBUtil;
import application.Session;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LoginController {

    @FXML private TextField emailField;
    @FXML private PasswordField passField;

    @FXML
    private void handleLogin() {
        String email = emailField.getText().trim();
        String password = passField.getText().trim();

        if (email.isEmpty() || password.isEmpty()) {
            showAlert(Alert.AlertType.WARNING, "Missing Fields", "Please enter both email and password.");
            return;
        }

        String query = "SELECT * FROM STUDENT WHERE Student_Email = ? AND Student_Pass = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // ✅ Set session
                int studentId = rs.getInt("Student_ID");
                String studentName = rs.getString("fName");
                Session.set(studentId, studentName);

                // ✅ Load dashboard
                FXMLLoader loader = new FXMLLoader(getClass().getResource("/views/dashboard.fxml"));
                Stage dashboardStage = new Stage();
                dashboardStage.setTitle("LMS Dashboard");
                dashboardStage.setScene(new Scene(loader.load()));
                dashboardStage.show();

                // ✅ Close login window
                Stage currentStage = (Stage) emailField.getScene().getWindow();
                currentStage.close();

            } else {
                showAlert(Alert.AlertType.ERROR, "Login Failed", "Invalid email or password.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            showAlert(Alert.AlertType.ERROR, "Database Error", e.getMessage());
        }
    }

    @FXML
    private void handleRegisterRedirect() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/views/register.fxml"));
            Stage stage = new Stage();
            stage.setTitle("Student Registration");
            stage.setScene(new Scene(loader.load()));
            stage.show();

            Stage currentStage = (Stage) emailField.getScene().getWindow();
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
