# app/auth.py

from flask import Blueprint, request, jsonify
from .models import User
from . import db
import re
import jwt
from datetime import datetime, timedelta, timezone
from flask import current_app

# Create a Blueprint
auth_bp = Blueprint('auth_bp', __name__)

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()

    if not data:
        return jsonify({"error": "No data provided"}), 400

    phone_number = data.get('phone_number')
    password = data.get('password')

    # 2. Validate the data
    if not phone_number or not password:
        return jsonify({"error": "Phone number and password are required"}), 400

    # Simple validation for a 10-digit Indian phone number
    if not re.match(r'^\d{10}$', phone_number):
        return jsonify({"error": "Invalid phone number format. Must be 10 digits."}), 400

    # 3. Check if user already exists
    if User.query.filter_by(phone_number=phone_number).first():
        return jsonify({"error": "Phone number already registered"}), 409 # HTTP 409 Conflict

    # 4. Create new user and hash the password
    # The password setter in the User model automatically handles hashing
    new_user = User(phone_number=phone_number, password=password)

    # 5. Add new user to the database
    try:
        db.session.add(new_user)
        db.session.commit()
    except Exception:
        db.session.rollback()
        return jsonify({"error": "Could not save user to the database"}), 500

    # 6. Return a success response
    return jsonify({"message": f"User {phone_number} was registered successfully!"}), 201 # HTTP 201 Created

@auth_bp.route('/login', methods=['POST'])
def login():
    # 1. Get data from the incoming JSON request
    data = request.get_json()
    if not data:
        return jsonify({"error": "No data provided"}), 400

    phone_number = data.get('phone_number')
    password = data.get('password')

    # 2. Validate the data
    if not phone_number or not password:
        return jsonify({"error": "Phone number and password are required"}), 400

    # 3. Find the user in the database
    user = User.query.filter_by(phone_number=phone_number).first()

    # 4. Check if the user exists and the password is correct
    if not user or not user.check_password(password):
        return jsonify({"error": "Invalid phone number or password"}), 401 # 401 Unauthorized

    # 5. Generate a JWT token
    token = jwt.encode(
        {
            'user_id': user.id,
            'exp': datetime.now(timezone.utc) + timedelta(hours=24) # Token expires in 24 hours
        },
        current_app.config['SECRET_KEY'],
        algorithm="HS256"
    )

    # 6. Return the token to the user
    return jsonify({
        "message": "Login successful!",
        "token": token
    })