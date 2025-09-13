from flask import Flask, render_template_string, session, redirect, url_for

app = Flask(__name__)
app.secret_key = "supersecretkey123"  # Required for session storage

# ===================== TRANSLATIONS =====================
translations = {
    "en": {
        "home_title": "📷 Scanner App",
        "upload": "Upload Image for Scan",
        "live_scan": "Live Camera Scan",
        "results": "View Scan Results",
        "back": "⬅ Back to Home",
        "upload_title": "Upload an Image to Scan",
        "results_title": "📊 Scan Results"
    },
    "hi": {  # Hindi
        "home_title": "📷 स्कैनर ऐप",
        "upload": "स्कैन करने के लिए इमेज अपलोड करें",
        "live_scan": "लाइव कैमरा स्कैन",
        "results": "स्कैन परिणाम देखें",
        "back": "⬅ होम पर वापस जाएं",
        "upload_title": "स्कैन करने के लिए इमेज अपलोड करें",
        "results_title": "📊 स्कैन परिणाम"
    },
    "or": {  # Odia
        "home_title": "📷 ସ୍କାନର ଆପ୍",
        "upload": "ସ୍କାନ ପାଇଁ ଛବି ଅପଲୋଡ୍ କରନ୍ତୁ",
        "live_scan": "ଲାଇଭ୍ କ୍ୟାମେରା ସ୍କାନ",
        "results": "ସ୍କାନ ଫଳାଫଳ ଦେଖନ୍ତୁ",
        "back": "⬅ ହୋମକୁ ଫେରନ୍ତୁ",
        "upload_title": "ସ୍କାନ ପାଇଁ ଛବି ଅପଲୋଡ୍ କରନ୍ତୁ",
        "results_title": "📊 ସ୍କାନ ଫଳାଫଳ"
    },
    "kn": {  # Kannada
        "home_title": "📷 ಸ್ಕ್ಯಾನರ್ ಅಪ್ಲಿಕೇಶನ್",
        "upload": "ಸ್ಕ್ಯಾನ್ ಮಾಡಲು ಚಿತ್ರವನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ",
        "live_scan": "ಲೈವ್ ಕ್ಯಾಮೆರಾ ಸ್ಕ್ಯಾನ್",
        "results": "ಸ್ಕ್ಯಾನ್ ಫಲಿತಾಂಶಗಳನ್ನು ನೋಡಿ",
        "back": "⬅ ಹೋಮ್‌ಗೆ ಹಿಂದಿರುಗಿ",
        "upload_title": "ಸ್ಕ್ಯಾನ್ ಮಾಡಲು ಚಿತ್ರವನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ",
        "results_title": "📊 ಸ್ಕ್ಯಾನ್ ಫಲಿತಾಂಶಗಳು"
    }
}

# ===================== HELPER =====================
def get_translation():
    """Return current translation dictionary based on session language."""
    lang = session.get("lang", "en")   # Default English
    return translations[lang]

# ===================== ROUTES =====================
@app.route("/")
def home():
    t = get_translation()
    return render_template_string("""
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <title>{{ t["home_title"] }}</title>
            <!-- Bootstrap CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>
        <body class="container mt-5">
            <h1 class="mb-4">{{ t["home_title"] }}</h1>
            
            <ul class="list-group mb-4">
                <li class="list-group-item"><a href="{{ url_for('upload') }}">{{ t["upload"] }}</a></li>
                <li class="list-group-item"><a href="#">{{ t["live_scan"] }}</a></li>
                <li class="list-group-item"><a href="{{ url_for('results') }}">{{ t["results"] }}</a></li>
            </ul>

            <h5>🌐 Select Language</h5>
            <div class="btn-group" role="group">
                <a href="{{ url_for('set_language', lang='en') }}" class="btn btn-outline-primary">🇬🇧 English</a>
                <a href="{{ url_for('set_language', lang='hi') }}" class="btn btn-outline-success">🇮🇳 हिन्दी</a>
                <a href="{{ url_for('set_language', lang='or') }}" class="btn btn-outline-warning">🇮🇳 ଓଡ଼ିଆ</a>
                <a href="{{ url_for('set_language', lang='kn') }}" class="btn btn-outline-danger">🇮🇳 ಕನ್ನಡ</a>
            </div>
        </body>
        </html>
    """, t=t)

@app.route("/upload")
def upload():
    t = get_translation()
    return render_template_string("""
        <h1>{{ t["upload_title"] }}</h1>
        <p><a href="{{ url_for('home') }}">{{ t["back"] }}</a></p>
    """, t=t)

@app.route("/results")
def results():
    t = get_translation()
    return render_template_string("""
        <h1>{{ t["results_title"] }}</h1>
        <p><a href="{{ url_for('home') }}">{{ t["back"] }}</a></p>
    """, t=t)

@app.route("/setlang/<lang>")
def set_language(lang):
    if lang in translations:
        session["lang"] = lang
    return redirect(url_for("home"))

# ===================== MAIN =====================
if __name__ == "__main__":
    app.run(debug=True)
