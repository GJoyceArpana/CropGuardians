# app/__init__.py
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from config import Config

# Initialize extensions
db = SQLAlchemy()
migrate = Migrate()

def create_app(config_class=Config):
    """Create and configure an instance of the Flask application."""
    app = Flask(__name__)
    app.config.from_object(config_class)

    # Initialize Flask extensions here
    db.init_app(app)
    migrate.init_app(app, db)

    # Register blueprints here
    from .auth import auth_bp
    app.register_blueprint(auth_bp, url_prefix='/api/auth')

    from .profile import profile_bp
    app.register_blueprint(profile_bp, url_prefix='/api/profile')

    from .settings import settings_bp
    app.register_blueprint(settings_bp, url_prefix='/api/settings')
    
    from .feedback import feedback_bp
    app.register_blueprint(feedback_bp, url_prefix='/api/feedback')

    # A simple test route to confirm the app is running
    @app.route('/test')
    def test_page():
        return "<h1>It's working!</h1><p>Your Flask app is running.</p>"

    return app