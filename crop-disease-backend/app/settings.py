# app/settings.py

from flask import Blueprint, jsonify, request
from .decorators import token_required
from .models import Profile
from . import db

settings_bp = Blueprint('settings_bp', __name__)

@settings_bp.route('/', methods=['PUT'])
@token_required
def update_settings(current_user):
    """Creates or updates the logged-in user's profile and settings."""
    data = request.get_json()
    if not data:
        return jsonify({"error": "No data provided"}), 400

    # This is the key change. We check for the profile first.
    profile = current_user.profile

    # If no profile exists, create one and associate it with the user immediately.
    if not profile:
        profile = Profile(user_id=current_user.id)
        db.session.add(profile)
        # This makes sure current_user.profile is no longer None
        current_user.profile = profile

    # Update all editable fields
    profile.first_name = data.get('first_name', profile.first_name)
    profile.last_name = data.get('last_name', profile.last_name)
    profile.profile_pic_url = data.get('profile_pic_url', profile.profile_pic_url)
    profile.state = data.get('state', profile.state)
    profile.city = data.get('city', profile.city)
    profile.region = data.get('region', profile.region)
    profile.language_preference = data.get('language_preference', profile.language_preference)

    try:
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": "Database error occurred", "details": str(e)}), 500

    return jsonify({"message": "Settings updated successfully!"}), 200