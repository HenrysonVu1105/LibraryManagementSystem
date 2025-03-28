package application;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:xe"; // Update if needed
    private static final String DB_USER = "your_db_username";
    private static final String DB_PASS = "your_db_password";

    public static Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }
}
