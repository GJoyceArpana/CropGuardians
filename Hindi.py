from flask import Flask, render_template_string, request

app = Flask(__name__)

# Hardcoded Hindi translations
translations = {
    "en": {
        "welcome": "Welcome to My App",
        "login": "Login",
        "signup": "Sign Up",
        "logout": "Logout",
        "hello_user": "Hello, User!"
    },
    "hi": {
        "welcome": "मेरे ऐप में आपका स्वागत है",
        "login": "लॉगिन",
        "signup": "साइन अप करें",
        "logout": "लॉग आउट",
        "hello_user": "नमस्ते, उपयोगकर्ता!"
    }
}

@app.route("/")
def home():
    # Default language = English, change with ?lang=hi
    lang = request.args.get("lang", "en")
    text = translations.get(lang, translations["en"])
    
    template = """
    <html>
        <head><title>{{ text['welcome'] }}</title></head>
        <body>
            <h1>{{ text['welcome'] }}</h1>
            <p>{{ text['hello_user'] }}</p>
            
            <a href="/?lang=en">{{ translations['en']['welcome'] }}</a> |
            <a href="/?lang=hi">{{ translations['hi']['welcome'] }}</a>
            
            <br><br>
            <button>{{ text['login'] }}</button>
            <button>{{ text['signup'] }}</button>
            <button>{{ text['logout'] }}</button>
        </body>
    </html>
    """
    return render_template_string(template, text=text, translations=translations)

if __name__ == "__main__":
    app.run(debug=True)
