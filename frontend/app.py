import cx_Oracle
from flask import Flask, render_template, request, jsonify, redirect, url_for
import os
from datetime import datetime

app = Flask(__name__)

# Configuration -  
db_user = "COMP214_W25_zor_13" 
db_password = "password"
db_dsn = "199.212.26.208:1521/SQLD" 
print(f"Connecting to: {db_user}@{db_dsn}")  

# --- Database Connection ---
def get_connection():
    try:
        connection = cx_Oracle.connect(user=db_user, password=db_password, dsn=db_dsn)
        return connection
    except cx_Oracle.Error as error:
        print(f"Error connecting to Oracle: {error}")
        return None 


# --- Flask Routes ---


@app.route("/")
def index():
    """
    Renders the main page.  This should provide an overview of the library system.
    """
    return render_template("index.html")


@app.route("/students")
def get_students():
    """
    Retrieves all students from the database and displays them.
    """
    connection = get_connection()
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute(
                "SELECT Student_ID, fName, lName, Gender, Age, Contact_ID, Student_Email, Address, Contact FROM STUDENT"
            )
            students = cursor.fetchall()
            cursor.close()
            return render_template("students.html", students=students)
        except cx_Oracle.Error as e:
            error_message = f"Error fetching students: {e}"
            return render_template("error.html", error=error_message), 500
        finally:
            connection.close()
    else:
        return (
            render_template("error.html", error="Failed to connect to the database."),
            500,
        )


@app.route("/librarians")
def get_librarians():
    """
    Retrieves all librarians from the database.
    """
    connection = get_connection()
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT Librarian_ID, fName, lName, Email FROM Librarian")
            librarians = cursor.fetchall()
            cursor.close()
            return render_template("librarians.html", librarians=librarians)
        except cx_Oracle.Error as e:
            error_message = f"Error fetching librarians: {e}"
            return render_template("error.html", error=error_message), 500
        finally:
            connection.close()
    else:
        return (
            render_template("error.html", error="Failed to connect to the database."),
            500,
        )


@app.route("/books")
def get_books():
    """
    Retrieves all books from the database.
    """
    connection = get_connection()
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute(
                "SELECT Book_ID, Book_Title, Book_Name, Publisher, Author, Quantity, Pub_Date, Status_ID FROM BOOK"
            )
            books = cursor.fetchall()
            cursor.close()
            return render_template("books.html", books=books)
        except cx_Oracle.Error as e:
            error_message = f"Error fetching books: {e}"
            return render_template("error.html", error=error_message), 500
        finally:
            connection.close()
    else:
        return (
            render_template("error.html", error="Failed to connect to the database."),
            500,
        )


@app.route("/borrowing")
def get_borrowing_records():
    """
    Retrieves all borrowing records.
    """
    connection = get_connection()
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute(
                "SELECT Borrowing_ID, Book_ID, Student_ID, Date_borrowed, Date_return FROM BORROWING"
            )
            borrowing_records = cursor.fetchall()
            cursor.close()
            return render_template(
                "borrowing.html", borrowing_records=borrowing_records
            )
        except cx_Oracle.Error as e:
            error_message = f"Error fetching borrowing records: {e}"
            return render_template("error.html", error=error_message), 500
        finally:
            connection.close()
    else:
        return (
            render_template("error.html", error="Failed to connect to the database."),
            500,
        )


@app.route("/fines")
def get_fines():
    """
    Retrieves all fine records.
    """
    connection = get_connection()
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute(
                "SELECT Fine_ID, Borrowing_ID, Amount, Paid_Status FROM FINE"
            )
            fines = cursor.fetchall()
            cursor.close()
            return render_template("fines.html", fines=fines)
        except cx_Oracle.Error as e:
            error_message = f"Error fetching fines: {e}"
            return render_template("error.html", error=error_message), 500
        finally:
            connection.close()
    else:
        return (
            render_template("error.html", error="Failed to connect to the database."),
            500,
        )


@app.route("/transactions")
def get_transactions():
    """
    Retrieves all transactions.
    """
    connection = get_connection()
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute(
                "SELECT Trans_ID, Trans_Name, Trans_Date, Borrowing_ID, Student_ID, Librarian_ID FROM TRANSACTIONS"
            )
            transactions = cursor.fetchall()
            cursor.close()
            return render_template("transactions.html", transactions=transactions)
        except cx_Oracle.Error as e:
            error_message = f"Error fetching transactions: {e}"
            return render_template("error.html", error=error_message), 500
        finally:
            connection.close()
    else:
        return (
            render_template("error.html", error="Failed to connect to the database."),
            500,
        )


@app.route("/reports")
def get_reports():
    """
    Retrieves all reports.
    """
    connection = get_connection()
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute(
                "SELECT Reports_ID, Reports_Desc, Reports_Date, Trans_ID, Borrowing_ID FROM REPORTS"
            )
            reports = cursor.fetchall()
            cursor.close()
            return render_template("reports.html", reports=reports)
        except cx_Oracle.Error as e:
            error_message = f"Error fetching reports: {e}"
            return render_template("error.html", error=error_message), 500
        finally:
            connection.close()
    else:
        return (
            render_template("error.html", error="Failed to connect to the database."),
            500,
        )


@app.route("/add_student", methods=["GET", "POST"])
def add_student():
    """
    Adds a new student to the database.
    Handles both the form display and the form submission.
    """
    if request.method == "POST":
        fName = request.form["fName"]
        lName = request.form["lName"]
        Gender = request.form["Gender"]
        Age = int(request.form["Age"])
        Contact_ID = int(request.form["Contact_ID"])
        Student_Email = request.form["Student_Email"]
        Student_Pass = request.form["Student_Pass"]
        Address = request.form["Address"]
        Contact = request.form["Contact"]

        connection = get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                # Removed the sequence.  The script doesn't show a student sequence, and the ID is provided.
                # cursor.execute("SELECT student_seq.NEXTVAL FROM DUAL")
                # student_id = cursor.fetchone()[0]
                # print(f"New Student ID: {student_id}")
                cursor.execute(
                    "INSERT INTO STUDENT (Student_ID, fName, lName, Gender, Age, Contact_ID, Student_Email, Student_Pass, Address, Contact) "
                    "VALUES (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10)",
                    (
                        Contact_ID,
                        fName,
                        lName,
                        Gender,
                        Age,
                        Contact_ID,
                        Student_Email,
                        Student_Pass,
                        Address,
                        Contact,
                    ),  # Use Contact_ID
                )
                connection.commit()
                cursor.close()
                return redirect(url_for("get_students"))  # Redirect to students list
            except cx_Oracle.Error as e:
                connection.rollback()
                error_message = f"Error adding student: {e}"
                return render_template("error.html", error=error_message), 500
            finally:
                connection.close()
        else:
            return (
                render_template(
                    "error.html", error="Failed to connect to the database."
                ),
                500,
            )
    else:
        return render_template("add_student.html")  # Render the form


@app.route("/add_librarian", methods=["GET", "POST"])
def add_librarian():
    """Adds a new librarian."""
    if request.method == "POST":
        fName = request.form["fName"]
        lName = request.form["lName"]
        Email = request.form["Email"]
        Password = request.form["Password"]
        connection = get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                # Removed sequence. No librarian sequence in original script.
                # cursor.execute("SELECT librarian_seq.NEXTVAL FROM DUAL")
                # librarian_id = cursor.fetchone()[0]
                # print(f"New Librarian ID: {librarian_id}")
                cursor.execute(
                    "INSERT INTO LIBRARIAN (Librarian_ID, fName, lName, Email, Password) "
                    "VALUES (:1, :2, :3, :4, :5)",
                    (
                        int(request.form["Librarian_ID"]),
                        fName,
                        lName,
                        Email,
                        Password,
                    ),  # Added Librarian_ID
                )
                connection.commit()
                cursor.close()
                return redirect(url_for("get_librarians"))
            except cx_Oracle.Error as e:
                connection.rollback()
                error_message = f"Error adding librarian: {e}"
                return render_template("error.html", error=error_message), 500
            finally:
                connection.close()
        else:
            return (
                render_template(
                    "error.html", error="Failed to connect to the database."
                ),
                500,
            )
    else:
        return render_template("add_librarian.html")


@app.route("/add_book", methods=["GET", "POST"])
def add_book():
    """Adds a new book."""
    if request.method == "POST":
        Book_Title = request.form["Book_Title"]
        Book_Name = request.form["Book_Name"]
        Publisher = request.form["Publisher"]
        Author = request.form["Author"]
        Quantity = int(request.form["Quantity"])
        Pub_Date_str = request.form["Pub_Date"]
        Status_ID = int(request.form["Status_ID"])  # Get Status_ID from form

        try:
            Pub_Date = datetime.strptime(
                Pub_Date_str, "%Y-%m-%d"
            ).date()  # Convert to date
        except ValueError:
            return (
                render_template(
                    "error.html", error="Invalid date format. Please use YYYY-MM-DD."
                ),
                400,
            )

        connection = get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                #  Removed book_seq.  Handled in trigger, or user-provided.
                # cursor.execute("SELECT book_seq.NEXTVAL FROM DUAL")
                # book_id = cursor.fetchone()[0]
                # print(f"New Book ID: {book_id}")
                cursor.execute(
                    "INSERT INTO BOOK (Book_ID, Book_Title, Book_Name, Publisher, Author, Quantity, Pub_Date, Status_ID) "
                    "VALUES (book_seq.NEXTVAL, :1, :2, :3, :4, :5, :6, :7)",  # Changed to use sequence
                    (
                        Book_Title,
                        Book_Name,
                        Publisher,
                        Author,
                        Quantity,
                        Pub_Date,
                        Status_ID,
                    ),
                )
                connection.commit()
                cursor.close()
                return redirect(url_for("get_books"))
            except cx_Oracle.Error as e:
                connection.rollback()
                error_message = f"Error adding book: {e}"
                return render_template("error.html", error=error_message), 500
            finally:
                connection.close()
        else:
            return (
                render_template(
                    "error.html", error="Failed to connect to the database."
                ),
                500,
            )
    else:
        #  Populate the Status_ID dropdown.
        connection = get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                cursor.execute("SELECT Status_ID, Status_Name FROM BOOK_STATUS")
                statuses = cursor.fetchall()
                cursor.close()
                return render_template(
                    "add_book.html", statuses=statuses
                )  # Pass statuses
            except cx_Oracle.Error as e:
                error_message = f"Error fetching book statuses: {e}"
                return render_template("error.html", error=error_message), 500
            finally:
                connection.close()
        else:
            return (
                render_template(
                    "error.html", error="Failed to connect to the database."
                ),
                500,
            )


@app.route("/add_borrowing", methods=["GET", "POST"])
def add_borrowing():
    """Adds a new borrowing record."""
    if request.method == "POST":
        Book_ID = int(request.form["Book_ID"])
        Student_ID = int(request.form["Student_ID"])
        Date_borrowed_str = request.form["Date_borrowed"]
        Date_return_str = request.form["Date_return"]
        try:
            Date_borrowed = datetime.strptime(Date_borrowed_str, "%Y-%m-%d").date()
            Date_return = datetime.strptime(Date_return_str, "%Y-%m-%d").date()
        except ValueError:
            return (
                render_template(
                    "error.html", error="Invalid date format. Please use YYYY-MM-DD."
                ),
                400,
            )

        connection = get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                # Removed sequence, handled by trigger
                # cursor.execute("SELECT borrowing_seq.NEXTVAL FROM DUAL")
                # borrowing_id = cursor.fetchone()[0]
                # print(f"New Borrowing ID: {borrowing_id}")
                cursor.execute(
                    "INSERT INTO BORROWING (Borrowing_ID, Book_ID, Student_ID, Date_borrowed, Date_return) "
                    "VALUES (borrowing_seq.NEXTVAL, :1, :2, :3, :4)",
                    (Book_ID, Student_ID, Date_borrowed, Date_return),
                )
                connection.commit()
                cursor.close()
                return redirect(url_for("get_borrowing_records"))
            except cx_Oracle.Error as e:
                connection.rollback()
                error_message = f"Error adding borrowing record: {e}"
                return render_template("error.html", error=error_message), 500
            finally:
                connection.close()
        else:
            return (
                render_template(
                    "error.html", error="Failed to connect to the database."
                ),
                500,
            )
    else:
        # Get list of students and books for dropdown
        connection = get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                cursor.execute("SELECT Student_ID, fName, lName FROM STUDENT")
                students = cursor.fetchall()
                cursor.execute("SELECT Book_ID, Book_Title FROM BOOK")
                books = cursor.fetchall()
                cursor.close()
                return render_template(
                    "add_borrowing.html", students=students, books=books
                )
            except cx_Oracle.Error as e:
                error_message = f"Error retrieving data for form: {e}"
                return render_template("error.html", error=error_message), 500
            finally:
                connection.close()
        else:
            return (
                render_template(
                    "error.html", error="Failed to connect to the database."
                ),
                500,
            )


@app.route("/add_fine", methods=["GET", "POST"])
def add_fine():
    """Adds a new fine."""
    if request.method == "POST":
        Borrowing_ID = int(request.form["Borrowing_ID"])
        Amount = float(request.form["Amount"])
        Paid_Status = request.form["Paid_Status"]

        connection = get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                # Removed sequence. No fine sequence in original script.
                # cursor.execute("SELECT fine_seq.NEXTVAL FROM DUAL")
                # fine_id = cursor.fetchone()[0]
                # print(f"New Fine ID: {fine_id}")
                cursor.execute(
                    "INSERT INTO FINE (Fine_ID, Borrowing_ID, Amount, Paid_Status) "
                    "VALUES (fine_seq.NEXTVAL, :1, :2, :3)",  # changed to use sequence
                    (Borrowing_ID, Amount, Paid_Status),
                )
                connection.commit()
                cursor.close()
                return redirect(url_for("get_fines"))
            except cx_Oracle.Error as e:
                connection.rollback()
                error_message = f"Error adding fine: {e}"
                return render_template("error.html", error=error_message), 500
            finally:
                connection.close()
        else:
            return (
                render_template(
                    "error.html", error="Failed to connect to the database."
                ),
                500,
            )
    else:
        # Get list of borrowing ids for dropdown
        connection = get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                cursor.execute("SELECT Borrowing_ID FROM BORROWING")
                borrowings = cursor.fetchall()
                cursor.close()
                return render_template("add_fine.html", borrowings=borrowings)
            except cx_Oracle.Error as e:
                error_message = f"Error retrieving borrowing ids: {e}"
                return render_template("error.html", error=error_message), 500
            finally:
                connection.close()
        else:
            return (
                render_template(
                    "error.html", error="Failed to connect to the database."
                ),
                500,
            )


@app.route("/add_transaction", methods=["GET", "POST"])
def add_transaction():
    """Adds a new transaction."""
    if request.method == "POST":
        Trans_Name = request.form["Trans_Name"]
        Trans_Date_str = request.form["Trans_Date"]
        Borrowing_ID = int(request.form["Borrowing_ID"])
        Student_ID = int(request.form["Student_ID"])
        Librarian_ID = int(request.form["Librarian_ID"])
        try:
            Trans_Date = datetime.strptime(Trans_Date_str, "%Y-%m-%d").date()
        except ValueError:
            return (
                render_template(
                    "error.html", error="Invalid date format. Please use YYYY-MM-DD."
                ),
                400,
            )

        connection = get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                # Removed sequence, handled by trigger or user-supplied.
                # cursor.execute("SELECT transactions_seq.NEXTVAL FROM DUAL")
                # trans_id = cursor.fetchone()[0]
                # print(f"New Transaction ID: {trans_id}")
                cursor.execute(
                    "INSERT INTO TRANSACTIONS (Trans_ID, Trans_Name, Trans_Date, Borrowing_ID, Student_ID, Librarian_ID) "
                    "VALUES (transactions_seq.NEXTVAL, :1, :2, :3, :4, :5)",  # changed to use sequence
                    (Trans_Name, Trans_Date, Borrowing_ID, Student_ID, Librarian_ID),
                )
                connection.commit()
                cursor.close()
                return redirect(url_for("get_transactions"))
            except cx_Oracle.Error as e:
                connection.rollback()
                error_message = f"Error adding transaction: {e}"
                return render_template("error.html", error=error_message), 500
            finally:
                connection.close()
        else:
            return (
                render_template(
                    "error.html", error="Failed to connect to the database."
                ),
                500,
            )
    else:
        # get data for dropdowns
        connection = get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                cursor.execute("SELECT Borrowing_ID FROM BORROWING")
                borrowings = cursor.fetchall()
                cursor.execute("SELECT Student_ID FROM STUDENT")
                students = cursor.fetchall()
                cursor.execute("SELECT Librarian_ID FROM LIBRARIAN")
                librarians = cursor.fetchall()
                cursor.close()
                return render_template(
                    "add_transaction.html",
                    borrowings=borrowings,
                    students=students,
                    librarians=librarians,
                )
            except cx_Oracle.Error as e:
                error_message = f"Error retrieving data for form: {e}"
                return render_template("error.html", error=error_message), 500
            finally:
                connection.close()
        else:
            return (
                render_template(
                    "error.html", error="Failed to connect to the database."
                ),
                500,
            )


@app.route("/add_report", methods=["GET", "POST"])
def add_report():
    """Adds a new report."""
    if request.method == "POST":
        Reports_Desc = request.form["Reports_Desc"]
        Reports_Date_str = request.form["Reports_Date"]
        Trans_ID = int(request.form["Trans_ID"])
        Borrowing_ID = int(request.form["Borrowing_ID"])
        try:
            Reports_Date = datetime.strptime(Reports_Date_str, "%Y-%m-%d").date()
        except ValueError:
            return (
                render_template(
                    "error.html", error="Invalid date format. Please use YYYY-MM-DD."
                ),
                400,
            )

        connection = get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                # Removed sequence. No report sequence in the original script.
                # cursor.execute("SELECT reports_seq.NEXTVAL FROM DUAL")
                # report_id = cursor.fetchone()[0]
                # print(f"New Report ID: {report_id}")
                cursor.execute(
                    "INSERT INTO REPORTS (Reports_ID, Reports_Desc, Reports_Date, Trans_ID, Borrowing_ID) "
                    "VALUES (reports_seq.NEXTVAL, :1, :2, :3, :4)",  # changed to use sequence.
                    (Reports_Desc, Reports_Date, Trans_ID, Borrowing_ID),
                )
                connection.commit()
                cursor.close()
                return redirect(url_for("get_reports"))
            except cx_Oracle.Error as e:
                connection.rollback()
                error_message = f"Error adding report: {e}"
                return render_template("error.html", error=error_message), 500
            finally:
                connection.close()
        else:
            return (
                render_template(
                    "error.html", error="Failed to connect to the database."
                ),
                500,
            )
    else:
        # get dropdown data
        connection = get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                cursor.execute("SELECT Trans_ID FROM TRANSACTIONS")
                transactions = cursor.fetchall()
                cursor.execute("SELECT Borrowing_ID FROM BORROWING")
                borrowings = cursor.fetchall()
                cursor.close()
                return render_template(
                    "add_report.html", transactions=transactions, borrowings=borrowings
                )
            except cx_Oracle.Error as e:
                error_message = f"Error retrieving data for form: {e}"
                return render_template("error.html", error=error_message), 500
            finally:
                connection.close()
        else:
            return (
                render_template(
                    "error.html", error="Failed to connect to the database."
                ),
                500,
            )


@app.route("/update_fine/<int:fine_id>", methods=["GET", "POST"])
def update_fine(fine_id):
    """
    Updates an existing fine record.
    """
    connection = get_connection()
    if connection:
        try:
            cursor = connection.cursor()
            if request.method == "GET":
                # Fetch the fine record to be updated
                cursor.execute(
                    "SELECT Fine_ID, Borrowing_ID, Amount, Paid_Status FROM FINE WHERE Fine_ID = :1",
                    (fine_id,),
                )
                fine = cursor.fetchone()
                if fine:
                    return render_template("update_fine.html", fine=fine)
                else:
                    return (
                        render_template("error.html", error="Fine record not found."),
                        404,
                    )
            elif request.method == "POST":
                # Process the update
                Borrowing_ID = int(request.form["Borrowing_ID"])
                Amount = float(request.form["Amount"])
                Paid_Status = request.form["Paid_Status"]
                cursor.execute(
                    "UPDATE FINE SET Borrowing_ID = :1, Amount = :2, Paid_Status = :3 WHERE Fine_ID = :4",
                    (Borrowing_ID, Amount, Paid_Status, fine_id),
                )
                connection.commit()
                cursor.close()
                return redirect(url_for("get_fines"))
        except cx_Oracle.Error as e:
            connection.rollback()
            error_message = f"Error updating fine: {e}"
            return render_template("error.html", error=error_message), 500
        finally:
            connection.close()
    else:
        return (
            render_template("error.html", error="Failed to connect to the database."),
            500,
        )


@app.route("/delete_fine/<int:fine_id>", methods=["POST"])
def delete_fine(fine_id):
    """
    Deletes a fine record.  This should be a POST request.
    """
    connection = get_connection()
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute("DELETE FROM FINE WHERE Fine_ID = :1", (fine_id,))
            connection.commit()
            cursor.close()
            return redirect(url_for("get_fines"))
        except cx_Oracle.Error as e:
            connection.rollback()
            error_message = f"Error deleting fine: {e}"
            return render_template("error.html", error=error_message), 500
        finally:
            connection.close()
    else:
        return (
            render_template("error.html", error="Failed to connect to the database."),
            500,
        )


#  Error handling route
@app.errorhandler(500)
def internal_server_error(e):
    return render_template("error.html", error="Internal Server Error: " + str(e)), 500


if __name__ == "__main__":
    app.run(debug=True)  # remove debug=True for production
