from flask import Blueprint, request, jsonify, current_app
from .models import User
from . import db
import re
import jwt
from datetime import datetime, timedelta, timezone

# Create a Blueprint
auth_bp = Blueprint('auth_bp', __name__)

@auth_bp.route('/register', methods=['POST'])
def register():
    """Handles new user sign-ups and saves them to the database."""
    data = request.get_json()

    if not data:
        return jsonify({"error": "No data provided"}), 400

    phone_number = data.get('phone_number')
    password = data.get('password')

    # Basic validation for the incoming data
    if not phone_number or not password:
        return jsonify({"error": "Phone number and password are required"}), 400

    # Check for existing user
    if User.query.filter_by(phone_number=phone_number).first():
        return jsonify({"error": "Phone number already registered"}), 409

    # Create new user and let the model handle password hashing
    new_user = User(phone_number=phone_number, password=password)

    try:
        db.session.add(new_user)
        db.session.commit()
    except Exception:
        db.session.rollback()
        return jsonify({"error": "Could not save user to the database"}), 500

    return jsonify({"message": f"User {phone_number} was registered successfully!"}), 201

@auth_bp.route('/login', methods=['POST'])
def login():
    """Authenticates a user and returns a JWT token."""
    data = request.get_json()
    if not data:
        return jsonify({"error": "No data provided"}), 400

    phone_number = data.get('phone_number')
    password = data.get('password')

    if not phone_number or not password:
        return jsonify({"error": "Phone number and password are required"}), 400

    # Find the user and verify the password
    user = User.query.filter_by(phone_number=phone_number).first()
    if not user or not user.check_password(password):
        return jsonify({"error": "Invalid phone number or password"}), 401

    # Generate a JWT token
    token = jwt.encode(
        {
            'user_id': user.id,
            'exp': datetime.now(timezone.utc) + timedelta(hours=24)
        },
        current_app.config['SECRET_KEY'],
        algorithm="HS256"
    )

    return jsonify({
        "message": "Login successful!",
        "token": token
    })