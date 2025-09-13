# app/profile.py

from flask import Blueprint, jsonify
from .decorators import token_required

profile_bp = Blueprint('profile_bp', __name__)

@profile_bp.route('/', methods=['GET'])
@token_required
def get_profile(current_user):
    """Fetches and returns the logged-in user's read-only profile."""
    profile = current_user.profile
    if not profile:
        return jsonify({"message": "No profile found for this user."}), 404

    profile_data = {
        "first_name": profile.first_name,
        "last_name": profile.last_name,
        "profile_pic_url": profile.profile_pic_url,
        "state": profile.state,
        "city": profile.city,
        "region": profile.region,
        "language_preference": profile.language_preference,
        "phone_number": current_user.phone_number
    }

    return jsonify(profile_data), 200