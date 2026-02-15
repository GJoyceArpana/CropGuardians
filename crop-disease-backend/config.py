import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

class Config:
    """Set Flask configuration variables from .env file."""

    # General Config
    SECRET_KEY = os.environ.get('SECRET_KEY', 'a_default_secret_key')

    # Database
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL')
    SQLALCHEMY_TRACK_MODIFICATIONS = False