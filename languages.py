# app.py
from flask import Flask, render_template_string, session, redirect, url_for, request
import os

app = Flask(__name__)
# In production set SECRET_KEY in environment; fallback for local dev:
app.secret_key = os.environ.get("SECRET_KEY", "dev-secret-change-me")

# ===================== TRANSLATIONS =====================
translations = {
    "en": {
        "home_title": "📷 Scanner App",
        "upload": "Upload Image for Scan",
        "live_scan": "Live Camera Scan",
        "results": "View Scan Results",
        "back": "⬅ Back to Home",
        "upload_title": "Upload an Image to Scan",
        "results_title": "📊 Scan Results",
        "select_lang": "🌐 Select Language",
        "btn_scan": "Scan",
        "no_results": "No results available"
    },
    "hi": {  # Hindi
        "home_title": "📷 स्कैनर ऐप",
        "upload": "स्कैन करने के लिए इमेज अपलोड करें",
        "live_scan": "लाइव कैमरा स्कैन",
        "results": "स्कैन परिणाम देखें",
        "back": "⬅ होम पर वापस जाएं",
        "upload_title": "स्कैन करने के लिए इमेज अपलोड करें",
        "results_title": "📊 स्कैन परिणाम",
        "select_lang": "🌐 भाषा चुनें",
        "btn_scan": "स्कैन करें",
        "no_results": "कोई परिणाम उपलब्ध नहीं"
    },
    "or": {  # Odia
        "home_title": "📷 ସ୍କାନର ଆପ୍",
        "upload": "ସ୍କାନ ପାଇଁ ଛବି ଅପଲୋଡ୍ କରନ୍ତୁ",
        "live_scan": "ଲାଇଭ୍ କ୍ୟାମେରା ସ୍କାନ",
        "results": "ସ୍କାନ ଫଳାଫଳ ଦେଖନ୍ତୁ",
        "back": "⬅ ହୋମକୁ ଫେରନ୍ତୁ",
        "upload_title": "ସ୍କାନ ପାଇଁ ଛବି ଅପଲୋଡ୍ କରନ୍ତୁ",
        "results_title": "📊 ସ୍କାନ ଫଳାଫଳ",
        "select_lang": "🌐 ଭାଷା ବାଛନ୍ତୁ",
        "btn_scan": "ସ୍କ୍ୟାନ୍",
        "no_results": "କোনସି ପରିଣାମ ଉପଲବ୍ଧ ନାହିଁ"
    },
    "kn": {  # Kannada
        "home_title": "📷 ಸ್ಕ್ಯಾನರ್ ಅಪ್ಲಿಕೇಶನ್",
        "upload": "ಸ್ಕ್ಯಾನ್ ಮಾಡಲು ಚಿತ್ರವನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ",
        "live_scan": "ಲೈವ್ ಕ್ಯಾಮೆರಾ ಸ್ಕ್ಯಾನ್",
        "results": "ಸ್ಕ್ಯಾನ್ ಫಲಿತಾಂಶಗಳನ್ನು ನೋಡಿ",
        "back": "⬅ ಹೋಮ್‌ಗೆ ಹಿಂದಿರುಗಿ",
        "upload_title": "ಸ್ಕ್ಯಾನ್ ಮಾಡಲು ಚಿತ್ರವನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ",
        "results_title": "📊 ಸ್ಕ್ಯಾನ್ ಫಲಿತಾಂಶಗಳು",
        "select_lang": "🌐 ಭಾಷೆ ಆಯ್ಕೆಮಾಡಿ",
        "btn_scan": "ಸ್ಕ್ಯಾನ್ ಮಾಡಿ",
        "no_results": "ಯಾವುದೇ ಫಲಿತಾಂಶಗಳು ಲಭ್ಯವಿಲ್ಲ"
    }
}

# ===================== HELPERS =====================
def get_translation():
    """
    Returns (translation_dict, lang_code).
    Falls back to 'en' if session contains invalid language.
    """
    lang = session.get("lang", "en")
    if lang not in translations:
        lang = "en"
    return translations[lang], lang


# ===================== ROUTES =====================
@app.route("/")
def home():
    t, lang = get_translation()
    return render_template_string(
        """
        <!doctype html>
        <html lang="{{ lang }}">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width,initial-scale=1">
          <title>{{ t['home_title'] }}</title>
          <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>
        <body class="container py-5">
          <h1 class="mb-4">{{ t['home_title'] }}</h1>

          <ul class="list-group mb-4">
            <li class="list-group-item"><a href="{{ url_for('upload') }}">{{ t['upload'] }}</a></li>
            <li class="list-group-item"><a href="#">{{ t['live_scan'] }}</a></li>
            <li class="list-group-item"><a href="{{ url_for('results') }}">{{ t['results'] }}</a></li>
          </ul>

          <h5 class="mt-3">{{ t['select_lang'] }}</h5>
          <div class="btn-group" role="group" aria-label="Language selector">
            <a href="{{ url_for('set_language', lang='en') }}" class="btn btn-outline-primary">🇬🇧 English</a>
            <a href="{{ url_for('set_language', lang='hi') }}" class="btn btn-outline-success">🇮🇳 हिन्दी</a>
            <a href="{{ url_for('set_language', lang='or') }}" class="btn btn-outline-warning">🇮🇳 ଓଡ଼ିଆ</a>
            <a href="{{ url_for('set_language', lang='kn') }}" class="btn btn-outline-danger">🇮🇳 ಕನ್ನಡ</a>
          </div>
        </body>
        </html>
        """,
        t=t,
        lang=lang,
    )


@app.route("/upload", methods=["GET", "POST"])
def upload():
    t, lang = get_translation()
    message = None

    if request.method == "POST":
        # basic file validation demonstration
        file = request.files.get("file")
        if not file:
            message = t["no_results"] if "no_results" in t else t.get("no_file", "")
        elif file.filename == "":
            message = t.get("no_file", "")
        else:
            # Accept file extensions in a minimal way (demo)
            if not file.filename.lower().endswith((".png", ".jpg", ".jpeg")):
                message = t.get("no_file", "")  # or invalid_file if present
            else:
                # Here you'd save and scan; we'll simulate success
                message = f"{t.get('btn_scan','')}: Sample QR Data"

    return render_template_string(
        """
        <!doctype html>
        <html lang="{{ lang }}">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width,initial-scale=1">
          <title>{{ t['upload_title'] }}</title>
          <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>
        <body class="container py-5">
          <h1>{{ t['upload_title'] }}</h1>

          <form method="post" enctype="multipart/form-data" class="mb-3">
            <div class="mb-2">
              <input class="form-control" type="file" name="file" accept="image/*">
            </div>
            <button class="btn btn-primary" type="submit">{{ t['btn_scan'] }}</button>
          </form>

          {% if message %}
            <div class="alert alert-info">{{ message }}</div>
          {% endif %}

          <p><a href="{{ url_for('home') }}">{{ t['back'] }}</a></p>
        </body>
        </html>
        """,
        t=t,
        lang=lang,
        message=message,
    )


@app.route("/results")
def results():
    t, lang = get_translation()
    # demo results — replace with DB-fetch in your full app
    sample_results = []  # empty to show translated "no results" message
    return render_template_string(
        """
        <!doctype html>
        <html lang="{{ lang }}">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width,initial-scale=1">
          <title>{{ t['results_title'] }}</title>
          <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>
        <body class="container py-5">
          <h1>{{ t['results_title'] }}</h1>

          {% if sample_results %}
            <ul class="list-group mb-3">
              {% for r in sample_results %}
                <li class="list-group-item">{{ r }}</li>
              {% endfor %}
            </ul>
          {% else %}
            <div class="alert alert-secondary">{{ t['no_results'] }}</div>
          {% endif %}

          <p><a href="{{ url_for('home') }}">{{ t['back'] }}</a></p>
        </body>
        </html>
        """,
        t=t,
        lang=lang,
        sample_results=sample_results,
    )


@app.route("/setlang/<lang>")
def set_language(lang):
    # Persist language in session (valid only if supported)
    if lang in translations:
        session["lang"] = lang
    return redirect(url_for("home"))


# ===================== MAIN =====================
if __name__ == "__main__":
    app.run(debug=True)
