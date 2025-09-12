import os
import sqlite3
import cv2
from pyzbar.pyzbar import decode
from flask import Flask, request, Response, render_template_string, redirect, url_for, make_response
from werkzeug.utils import secure_filename
import threading
import webbrowser
import time

app = Flask(__name__)

UPLOAD_FOLDER = "uploads"
ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg"}
DB_FILE = "scans.db"

# Ensure upload folder exists
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# --------------------------
# Translations (EN, HI, OR, KN)
# --------------------------
translations = {
    "en": {
        "home_title": "📷 Scanner App",
        "upload": "Upload Image for Scan",
        "live_scan": "Live Camera Scan",
        "results": "View Scan Results (from DB)",
        "back": "⬅ Back",
        "upload_title": "Upload an Image to Scan",
        "no_file": "❌ No file uploaded",
        "empty_file": "❌ Empty filename",
        "invalid_file": "❌ Invalid file type. Allowed: png, jpg, jpeg",
        "success": "✅ File saved and scanned. Result: ",
        "no_qr": "No QR/Barcode found",
        "results_title": "📊 Scan Results",
        "choose_lang": "Choose language"
    },
    "hi": {
        "home_title": "📷 स्कैनर ऐप",
        "upload": "स्कैन करने के लिए इमेज अपलोड करें",
        "live_scan": "लाइव कैमरा स्कैन",
        "results": "स्कैन परिणाम देखें (डेटाबेस से)",
        "back": "⬅ वापस",
        "upload_title": "स्कैन करने के लिए इमेज अपलोड करें",
        "no_file": "❌ कोई फ़ाइल अपलोड नहीं की गई",
        "empty_file": "❌ फ़ाइल का नाम खाली है",
        "invalid_file": "❌ अमान्य फ़ाइल प्रकार। अनुमत: png, jpg, jpeg",
        "success": "✅ फ़ाइल सेव और स्कैन की गई। परिणाम: ",
        "no_qr": "कोई QR/बारकोड नहीं मिला",
        "results_title": "📊 स्कैन परिणाम",
        "choose_lang": "भाषा चुनें"
    },
    "or": {
        "home_title": "📷 ସ୍କ୍ୟାନର୍ ଆପ୍",
        "upload": "ସ୍କ୍ୟାନ କରିବା ପାଇଁ ଛବି ଅପଲୋଡ୍ କରନ୍ତୁ",
        "live_scan": "ଲାଇଭ୍ କ୍ୟାମେରା ସ୍କ୍ୟାନ୍",
        "results": "ସ୍କ୍ୟାନ୍ ଫଳାଫଳ (ଡିବିରୁ) ଦେଖନ୍ତୁ",
        "back": "⬅ ପଛକୁ",
        "upload_title": "ସ୍କ୍ୟାନ କରିବା ପାଇଁ ଛବି ଅପଲୋଡ୍ କରନ୍ତୁ",
        "no_file": "❌ କୌଣସି ଫାଇଲ୍ ଅପଲୋଡ୍ ହୋଇନି",
        "empty_file": "❌ ଫାଇଲ୍ ନାମ ଖାଲି ଅଛି",
        "invalid_file": "❌ ଅବୈଧ ଫାଇଲ୍ ପ୍ରକାର। ଅନୁମୋଦିତ: png, jpg, jpeg",
        "success": "✅ ଫାଇଲ୍ ସଞ୍ଚୟ ହେଲା ଏବଂ ସ୍କ୍ୟାନ୍ ହେଲା। ଫଳାଫଳ: ",
        "no_qr": "କୌଣସି QR/ବାରକୋଡ୍ ମିଳିଲା ନାହିଁ",
        "results_title": "📊 ସ୍କ୍ୟାନ୍ ଫଳାଫଳ",
        "choose_lang": "ଭାଷା ବାଛନ୍ତୁ"
    },
    "kn": {
        "home_title": "📷 ಸ್ಕ್ಯಾನರ್ ಅಪ್ಲಿಕೇಶನ್",
        "upload": "ಸ್ಕ್ಯಾನ್ ಮಾಡಲು ಚಿತ್ರವನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ",
        "live_scan": "ಲೈವ್ ಕ್ಯಾಮೆರಾ ಸ್ಕ್ಯಾನ್",
        "results": "ಸ್ಕ್ಯಾನ್ ಫಲಿತಾಂಶಗಳನ್ನು ನೋಡಿ (ಡೇಟಾಬೇಸ್‌ನಿಂದ)",
        "back": "⬅ ಹಿಂತಿರುಗಿ",
        "upload_title": "ಸ್ಕ್ಯಾನ್ ಮಾಡಲು ಚಿತ್ರವನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ",
        "no_file": "❌ ಯಾವುದೇ ಫೈಲ್ ಅಪ್‌ಲೋಡ್ ಆಗಿಲ್ಲ",
        "empty_file": "❌ ಫೈಲ್ ಹೆಸರು ಖಾಲಿ",
        "invalid_file": "❌ ಅಮಾನ್ಯ ಫೈಲ್ ಪ್ರಕಾರ. ಅನುಮತಿತವು: png, jpg, jpeg",
        "success": "✅ ಫೈಲ್ ಉಳಿಸಲಾಗಿದೆ ಮತ್ತು ಸ್ಕ್ಯಾನ್ ಮಾಡಲಾಗಿದೆ. ಫಲಿತಾಂಶ: ",
        "no_qr": "ಯಾವುದೇ QR/ಬಾರ್‌ಕೋಡ್ ಕಂಡುಬಂದಿಲ್ಲ",
        "results_title": "📊 ಸ್ಕ್ಯಾನ್ ಫಲಿತಾಂಶಗಳು",
        "choose_lang": "ಭಾಷೆ ಆಯ್ಕೆಮಾಡಿ"
    }
}

# --------------------------
# Helpers
# --------------------------
def get_locale():
    # Query param ?lang=xx takes precedence, otherwise cookie, else default en
    lang = request.args.get("lang") or request.cookies.get("lang") or "en"
    return lang if lang in translations else "en"

def t(key):
    return translations[get_locale()].get(key, key)

def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS

# --------------------------
# Database init
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

# --------------------------
# Language setter (persists in cookie)
# --------------------------
@app.route("/set-lang/<lang>")
def set_language(lang):
    if lang not in translations:
        lang = "en"
    resp = make_response(redirect(url_for('home')))
    resp.set_cookie("lang", lang, max_age=60*60*24*30)  # 30 days
    return resp

# --------------------------
# Routes
# --------------------------
@app.route("/")
def home():
    lang = get_locale()
    return render_template_string(f"""
        <h1>{translations[lang]['home_title']}</h1>
        <p>{translations[lang].get('choose_lang','')}</p>
        <p>
            <a href="/set-lang/en">English</a> |
            <a href="/set-lang/hi">हिंदी</a> |
            <a href="/set-lang/or">ଓଡ଼ିଆ</a> |
            <a href="/set-lang/kn">ಕನ್ನಡ</a>
        </p>
        <ul>
            <li><a href="/upload">{translations[lang]['upload']}</a></li>
            <li><a href="/live-scan">{translations[lang]['live_scan']}</a></li>
            <li><a href="/results">{translations[lang]['results']}</a></li>
        </ul>
    """)

@app.route("/upload", methods=["GET", "POST"])
def scan_image():
    lang = get_locale()
    if request.method == "GET":
        return render_template_string(f"""
            <h2>{translations[lang]['upload_title']}</h2>
            <form method="POST" enctype="multipart/form-data">
                <input type="file" name="file" accept="image/*" capture="camera">
                <input type="submit" value="{translations[lang]['upload']}">
            </form>
            <a href="/">{translations[lang]['back']}</a>
        """)

    if "file" not in request.files:
        return translations[lang]['no_file'], 400

    file = request.files["file"]
    if file.filename == "":
        return translations[lang]['empty_file'], 400

    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        filepath = os.path.join(UPLOAD_FOLDER, filename)
        file.save(filepath)

        image = cv2.imread(filepath)
        if image is None:
            return translations[lang]['invalid_file'], 400

        decoded_objects = decode(image)
        results = [obj.data.decode("utf-8") for obj in decoded_objects]
        result_text = ", ".join(results) if results else translations[lang]['no_qr']

        conn = sqlite3.connect(DB_FILE)
        cursor = conn.cursor()
        cursor.execute("INSERT INTO scans (filename, result) VALUES (?, ?)", (filename, result_text))
        conn.commit()
        conn.close()

        return f"{translations[lang]['success']}{result_text}"

    return translations[lang]['invalid_file'], 400

def generate_camera_feed():
    cap = cv2.VideoCapture(0)
    if not cap.isOpened():
        # Camera not available: stop generator quietly
        return
        yield  # unreachable, keeps function a generator

    try:
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
    finally:
        cap.release()

@app.route("/live-scan")
def live_scan():
    # Returns an MJPEG stream — suitable to open directly in browser
    return Response(generate_camera_feed(),
                    mimetype="multipart/x-mixed-replace; boundary=frame")

@app.route("/results")
def view_results():
    lang = get_locale()
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()
    cursor.execute("SELECT id, filename, result FROM scans ORDER BY id DESC")
    rows = cursor.fetchall()
    conn.close()

    html = f"<h2>{translations[lang]['results_title']}</h2><ul>"
    for row in rows:
        html += f"<li>📂 {row[1]} → {row[2]}</li>"
    html += f"</ul><a href='/'>{translations[lang]['back']}</a>"

    return html

# --------------------------
# Auto-open browser and run
# --------------------------
def open_browser():
    time.sleep(1)
    webbrowser.open_new("http://127.0.0.1:5000/")

if __name__ == "__main__":
    threading.Thread(target=open_browser).start()
    app.run(host="127.0.0.1", port=5000, debug=True, threaded=True)
