# app/models.py

from . import db  # Imports the db instance from __init__.py
import bcrypt
from datetime import datetime, timezone

class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    phone_number = db.Column(db.String(15), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=True) # Nullable for OTP login
    created_at = db.Column(db.DateTime, nullable=False, default=lambda: datetime.now(timezone.utc))

    @property
    def password(self):
        raise AttributeError('password is not a readable attribute')

    @password.setter
    def password(self, password):
        """Hashes the password and stores it."""
        if password:
            self.password_hash = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        else:
            self.password_hash = None

    def check_password(self, password):
        """Checks if the provided password matches the stored hash."""
        if not self.password_hash:
            return False
        return bcrypt.checkpw(password.encode('utf-8'), self.password_hash.encode('utf-8'))
    
# app/models.py
# ... (User class is above)

class Profile(db.Model):
    __tablename__ = 'profiles'

    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(100), nullable=True)
    last_name = db.Column(db.String(100), nullable=True)
    profile_pic_url = db.Column(db.String(255), nullable=True)
    state = db.Column(db.String(100), nullable=True)
    city = db.Column(db.String(100), nullable=True)
    region = db.Column(db.String(100), nullable=True)
    language_preference = db.Column(db.String(5), nullable=False, default='en')
    # This links the profile to a specific user
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False, unique=True)
    user = db.relationship('User', backref=db.backref('profile', uselist=False))

class Feedback(db.Model):
    __tablename__ = 'feedback'

    id = db.Column(db.Integer, primary_key=True)
    rating = db.Column(db.Integer, nullable=True) # e.g., 1-5 stars
    comment = db.Column(db.Text, nullable=True)
    created_at = db.Column(db.DateTime, nullable=False, default=lambda: datetime.now(timezone.utc))

    # This links the feedback to the user who submitted it
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    user = db.relationship('User', backref='feedback')