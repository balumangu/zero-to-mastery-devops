from flask import Flask, render_template
import mysql.connector
import os

app = Flask(__name__)

DB_HOST = os.environ.get("DB_HOST")
DB_USER = os.environ.get("DB_USER")
DB_PASS = os.environ.get("DB_PASS")
DB_NAME = os.environ.get("DB_NAME")

def get_connection():
    return mysql.connector.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASS,
        database=DB_NAME
    )

@app.route("/")
def index():
    try:
        conn = get_connection()
        cursor = conn.cursor()

        cursor.execute(
            "CREATE TABLE IF NOT EXISTS visits (id INT AUTO_INCREMENT PRIMARY KEY)"
        )
        cursor.execute("INSERT INTO visits () VALUES ()")
        conn.commit()

        cursor.execute("SELECT COUNT(*) FROM visits")
        count = cursor.fetchone()[0]

        cursor.close()
        conn.close()

        return render_template("index.html", count=count)

    except Exception as e:
        return f"Database connection failed: {e}"

if __name__ == "__main__":
    # host='0.0.0.0' is REQUIRED for the Load Balancer to connect
    # port=80 is REQUIRED to match your Security Group rules
    app.run(host='0.0.0.0', port=80)