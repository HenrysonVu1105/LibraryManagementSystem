package application;

public class Session {
    private static int studentId;
    private static String studentName;

    public static void set(int id, String name) {
        studentId = id;
        studentName = name;
    }

    public static int getStudentId() {
        return studentId;
    }

    public static String getStudentName() {
        return studentName;
    }

    public static void clear() {
        studentId = 0;
        studentName = null;
    }
}
