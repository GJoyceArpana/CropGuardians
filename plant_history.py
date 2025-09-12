# app/plant_history.py

from flask import Blueprint, request, jsonify
from .decorators import token_required
from .models import db, PlantDB
from flask_login import current_user

plant_bp = Blueprint("plant_bp", __name__)

@plant_bp.route("/history", methods=["GET"])
@token_required
def get_scan_history(current_user):
    """
    Fetches the logged-in user's plant scan history with search, sort, and pagination.
    """

    # ✅ Query parameters
    search_query = request.args.get("q", "").lower()   # search term
    sort_order = request.args.get("sort", "desc")      # 'asc' or 'desc'
    page = int(request.args.get("page", 1))            # default page 1
    limit = int(request.args.get("limit", 10))         # default 10 per page

    # ✅ Base query (only logged-in user scans)
    scans = PlantDB.query.filter_by(id=current_user.id)

    # ✅ Search filter (plant or crop name)
    if search_query:
        scans = scans.filter(
            (PlantDB.Plant_Name.ilike(f"%{search_query}%")) |
            (PlantDB.crop_Name.ilike(f"%{search_query}%"))
        )

    # ✅ Sorting
    if sort_order == "asc":
        scans = scans.order_by(PlantDB.scan_date.asc())
    else:
        scans = scans.order_by(PlantDB.scan_date.desc())

    # ✅ Pagination
    total_records = scans.count()
    scans = scans.offset((page - 1) * limit).limit(limit).all()

    # ✅ Format response
    scan_history = []
    for scan in scans:
        scan_history.append({
            "plant_name": scan.Plant_Name,
            "crop_name": scan.crop_Name,
            "disease_name": scan.disease_name,
            "scan_date": scan.scan_date.strftime("%b %d, %Y %I:%M %p"),
            "plant_pic": str(scan.plant_pic),   # TODO: Convert bytea to image URL if needed
            "status": "Treatment Applied" if "blight" in scan.disease_name.lower() else "Requires Attention",
            "confidence": "92%"  # placeholder, can later be stored in DB
        })

    return jsonify({
        "total_scans": total_records,
        "page": page,
        "limit": limit,
        "issues_found": sum(1 for s in scan_history if s["status"] != "Healthy"),
        "accuracy": "94%",   # placeholder accuracy
        "scans": scan_history
    }), 200
