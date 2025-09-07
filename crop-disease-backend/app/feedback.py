from flask import Blueprint, jsonify, request
from .decorators import token_required
from .models import Feedback
from . import db

feedback_bp = Blueprint('feedback_bp', __name__)

@feedback_bp.route('/', methods=['POST'])
@token_required
def submit_feedback(current_user):
    """Allows a logged-in user to submit feedback."""
    data = request.get_json()

    # 1. Check if the request body is valid
    if not data:
        return jsonify({"error": "No data provided"}), 400

    # 2. Extract feedback data
    rating = data.get('rating')
    comment = data.get('comment')
    
    # 3. Validate the data
    if not (rating or comment):
        return jsonify({"error": "Either a rating or a comment is required"}), 400
    
    # 4. Create a new Feedback object
    new_feedback = Feedback(
        rating=rating,
        comment=comment,
        user_id=current_user.id  # Automatically link to the current user
    )

    # 5. Add the feedback to the database
    try:
        db.session.add(new_feedback)
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        print(f"Database error: {e}")
        return jsonify({"error": "Could not submit feedback due to a database error"}), 500

    # 6. Return a success response
    return jsonify({"message": "Feedback submitted successfully!"}), 201