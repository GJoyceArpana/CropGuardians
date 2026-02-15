# app/decorators.py

from functools import wraps
from flask import request, jsonify, current_app
import jwt
from .models import User

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        # Check if 'Authorization' header is present
        if 'Authorization' in request.headers:
            auth_header = request.headers['Authorization']
            parts = auth_header.split(" ")
            
            # This is the fix: check if the list has at least two parts
            if len(parts) == 2 and parts[0].lower() == 'bearer':
                token = parts[1]
        if not token:
            return jsonify({'message': 'Token is missing!'}), 401

        try:
            # Decode the token using the secret key
            data = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms=["HS256"])
            current_user = User.query.get(data['user_id'])
        except jwt.ExpiredSignatureError:
            return jsonify({'message': 'Token has expired!'}), 401
        except jwt.InvalidTokenError:
            return jsonify({'message': 'Token is invalid!'}), 401
        except Exception as e:
            return jsonify({'message': 'An error occurred', 'error': str(e)}), 500

        if current_user is None:
            return jsonify({'message': 'User not found!'}), 404

        # Pass the user object to the decorated function
        return f(current_user, *args, **kwargs)

    return decorated