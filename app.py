import os
import sqlite3
import cv2
from pyzbar.pyzbar import decode
from flask import Flask, request, Response, render_template_string
from werkzeug.utils import secure_filename
import threading, webbrowser

app = Flask(__name__)

UPLOAD_FOLDER = "uploads"
ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg"}
DB_FILE = "scans.db"

# Ensure upload folder exists
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

# --------------------------
# Database setup
# --------------------------
def init_db():
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS scans (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filename TEXT,
            result TEXT
        )
    """)
    conn.commit()
    conn.close()

init_db()


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


# --------------------------
# Homepage
# --------------------------
@app.route("/")
def home():
    return render_template_string("""
        <h1>📷 Scanner App</h1>
        <ul>
            <li><a href="/upload">Upload Image for Scan</a></li>
            <li><a href="/live-scan">Live Camera Scan</a></li>
            <li><a href="/results">View Scan Results (from DB)</a></li>
        </ul>
    """)


# --------------------------
# Upload an image
# --------------------------
@app.route("/upload", methods=["GET", "POST"])
def scan_image():
    if request.method == "GET":
        return render_template_string("""
            <h2>Upload an Image to Scan</h2>
            <form method="POST" enctype="multipart/form-data">
                <input type="file" name="file" accept="image/*" capture="camera">
                <input type="submit" value="Upload">
            </form>
            <a href="/">⬅ Back</a>
        """)

    if "file" not in request.files:
        return "❌ No file uploaded", 400

    file = request.files["file"]

    if file.filename == "":
        return "❌ Empty filename", 400

    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        filepath = os.path.join(UPLOAD_FOLDER, filename)
        file.save(filepath)

        # Decode QR/barcode
        image = cv2.imread(filepath)
        decoded_objects = decode(image)
        results = [obj.data.decode("utf-8") for obj in decoded_objects]
        result_text = ", ".join(results) if results else "No QR/Barcode found"

        # Store into database
        conn = sqlite3.connect(DB_FILE)
        cursor = conn.cursor()
        cursor.execute("INSERT INTO scans (filename, result) VALUES (?, ?)", (filename, result_text))
        conn.commit()
        conn.close()

        return f"✅ File saved and scanned. Result: {result_text}"

    return "❌ Invalid file type. Allowed: png, jpg, jpeg", 400


# --------------------------
# Live camera scanning
# --------------------------
def generate_camera_feed():
    cap = cv2.VideoCapture(0)  # 0 = default webcam
    while True:
        ret, frame = cap.read()
        if not ret:
            break

        decoded_objects = decode(frame)
        for obj in decoded_objects:
            data = obj.data.decode("utf-8")
            (x, y, w, h) = obj.rect
            cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
            cv2.putText(frame, data, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX,
                        0.9, (0, 255, 0), 2)

        _, buffer = cv2.imencode(".jpg", frame)
        frame_bytes = buffer.tobytes()
        yield (b"--frame\r\n"
               b"Content-Type: image/jpeg\r\n\r\n" + frame_bytes + b"\r\n")

    cap.release()


@app.route("/live-scan")
def live_scan():
    return Response(generate_camera_feed(),
                    mimetype="multipart/x-mixed-replace; boundary=frame")


# --------------------------
# View results from DB
# --------------------------
@app.route("/results")
def view_results():
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()
    cursor.execute("SELECT id, filename, result FROM scans ORDER BY id DESC")
    rows = cursor.fetchall()
    conn.close()

    html = "<h2>📊 Scan Results</h2><ul>"
    for row in rows:
        html += f"<li>📂 {row[1]} → {row[2]}</li>"
    html += "</ul><a href='/'>⬅ Back</a>"

    return html


# --------------------------
# Auto-open browser
# --------------------------
def open_browser():
    webbrowser.open_new("http://127.0.0.1:5000/")

if __name__ == "__main__":
    threading.Timer(1.0, open_browser).start()
    app.run(host="127.0.0.1", port=5000, debug=True)
