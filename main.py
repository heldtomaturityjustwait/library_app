"""
main.py — entry point for Library Management System
"""

from database.connection import test_connection
from ui.app import main

if __name__ == "__main__":
    test_connection()   # Verify DB connection before launching GUI
    main()
