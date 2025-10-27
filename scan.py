import os
import sqlite3
import cv2
from pyzbar.pyzbar import decode
from flask import Blueprint, request, Response, render_template_string
from werkzeug.utils import secure_filename

scan_bp = Blueprint("scan_bp", __name__)

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
# Upload an image and scan
# --------------------------
@scan_bp.route("/upload", methods=["GET", "POST"])
def upload():
    if request.method == "GET":
        return render_template_string("""
            <h2>Upload an Image to Scan</h2>
            <form method="POST" enctype="multipart/form-data">
                <input type="file" name="file" accept="image/*" capture="camera">
                <input type="submit" value="Upload">
            </form>
            <a href="/results">View Results</a>
        """)

    if "file" not in request.files:
        return "❌ No file uploaded"

    file = request.files["file"]

    if file.filename == "":
        return "❌ Empty filename"

    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        filepath = os.path.join(UPLOAD_FOLDER, filename)
        file.save(filepath)

        # Decode QR/barcode
        image = cv2.imread(filepath)
        decoded_objects = decode(image)
        results = [obj.data.decode("utf-8") for obj in decoded_objects]
        result_text = ", ".join(results) if results else "No QR/Barcode found"

        # Save to DB
        conn = sqlite3.connect(DB_FILE)
        cursor = conn.cursor()
        cursor.execute("INSERT INTO scans (filename, result) VALUES (?, ?)", (filename, result_text))
        conn.commit()
        conn.close()

        return f"""
            <h3>✅ Scan Completed</h3>
            <p><b>File:</b> {filename}</p>
            <p><b>Result:</b> {result_text}</p>
            <a href="/results">📊 View All Results</a>
        """

    return "❌ Invalid file type. Allowed: png, jpg, jpeg"


# --------------------------
# Live camera scanning
# --------------------------
def generate_camera_feed():
    cap = cv2.VideoCapture(0)
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


@scan_bp.route("/live-scan")
def live_scan():
    return Response(generate_camera_feed(),
                    mimetype="multipart/x-mixed-replace; boundary=frame")


# --------------------------
# Show results from DB
# --------------------------
@scan_bp.route("/results")
def results():
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()
    cursor.execute("SELECT id, filename, result FROM scans ORDER BY id DESC")
    rows = cursor.fetchall()
    conn.close()

    html = "<h2>📊 Scan Results</h2><table border='1' cellpadding='5'><tr><th>ID</th><th>Filename</th><th>Result</th></tr>"
    for row in rows:
        html += f"<tr><td>{row[0]}</td><td>{row[1]}</td><td>{row[2]}</td></tr>"
    html += "</table><br><a href='/upload'>⬅ Upload More</a>"

    return html
