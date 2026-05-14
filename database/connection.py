"""
database/connection.py
Manages MySQL connection using mysql-connector-python.
"""

import mysql.connector
from mysql.connector import Error


# ── Change these to match your local MySQL setup ──────────────────────────────
DB_CONFIG = {
    "host":     "localhost",
    "user":     "root",
    "password": "password",   # <-- replace
    "database": "library_db",
    "charset":  "utf8mb4",
}
# ─────────────────────────────────────────────────────────────────────────────


def get_connection():
    """Return a new MySQL connection."""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except Error as e:
        raise ConnectionError(f"Cannot connect to MySQL: {e}")


def test_connection():
    conn = get_connection()
    conn.close()
    print("✅ Connected to library_db successfully.")
