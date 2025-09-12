from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class PlantDB(db.Model):
    __tablename__ = "plant_DB"

    id = db.Column(db.BigInteger, db.ForeignKey("Authentication.id"), primary_key=True)
    Plant_Name = db.Column(db.Text, nullable=False)
    crop_Name = db.Column(db.Text, nullable=False)
    plant_pic = db.Column(db.LargeBinary, nullable=False)  # bytea in Postgres
    scan_date = db.Column(db.DateTime(timezone=True), nullable=False)
    disease_name = db.Column(db.Text, nullable=False)
