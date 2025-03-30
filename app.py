from flask import Flask, render_template, request, jsonify
import cx_Oracle
import os
from dotenv import load_dotenv
from datetime import datetime

load_dotenv()

app = Flask(__name__)


# Database connection
def get_db_connection():
    dsn = cx_Oracle.makedsn(
        os.getenv("ORACLE_HOST"),
        os.getenv("ORACLE_PORT"),
        service_name=os.getenv("ORACLE_SERVICE"),
    )
    return cx_Oracle.connect(
        user=os.getenv("ORACLE_USER"), password=os.getenv("ORACLE_PASSWORD"), dsn=dsn
    )


# Routes
@app.route("/")
def home():
    return render_template("index.html")


# Get all books
@app.route("/api/books", methods=["GET"])
def get_books():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            """
            SELECT b.book_id, b.title, b.author, 
                    CASE WHEN COUNT(br.borrowing_id) > 0 
                        THEN 'Borrowed' ELSE 'Available' END as status
            FROM books b
            LEFT JOIN borrowing br ON b.book_id = br.book_id
            GROUP BY b.book_id, b.title, b.author
            ORDER BY b.book_id
        """
        )

        columns = [col[0].lower() for col in cursor.description]
        books = [dict(zip(columns, row)) for row in cursor.fetchall()]
        return jsonify(books)

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


# Borrow a book
@app.route("/api/borrow", methods=["POST"])
def borrow_book():
    try:
        data = request.json
        conn = get_db_connection()
        cursor = conn.cursor()

        # Convert dates to Oracle format
        date_borrowed = datetime.strptime(data["date_borrowed"], "%Y-%m-%d").date()
        date_return = datetime.strptime(data["date_return"], "%Y-%m-%d").date()

        # Call package procedure
        cursor.callproc(
            "library_pkg.add_borrowing",
            [int(data["book_id"]), int(data["student_id"]), date_borrowed, date_return],
        )
        conn.commit()

        return jsonify({"success": True, "message": "Book borrowed successfully"})

    except cx_Oracle.DatabaseError as e:
        (error,) = e.args
        return jsonify({"error": error.message}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


# Check availability
@app.route("/api/books/<int:book_id>/availability", methods=["GET"])
def check_availability(book_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Call package function
        status = cursor.callfunc(
            "library_pkg.is_book_available", cx_Oracle.STRING, [book_id]
        )
        return jsonify({"book_id": book_id, "available": status})

    except cx_Oracle.DatabaseError as e:
        (error,) = e.args
        return jsonify({"error": error.message}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
