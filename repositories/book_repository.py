"""
repositories/book_repository.py
Raw SQL operations for books, book_copies, authors, categories.
"""

from database.connection import get_connection


class BookRepository:

    # ── Authors ──────────────────────────────────────────────────────────────

    def get_or_create_author(self, name: str) -> int:
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute("SELECT author_id FROM authors WHERE author_name = %s", (name,))
            row = cur.fetchone()
            if row:
                return row["author_id"]
            cur.execute("INSERT INTO authors (author_name) VALUES (%s)", (name,))
            conn.commit()
            return cur.lastrowid
        finally:
            cur.close(); conn.close()

    def get_all_authors(self):
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute("SELECT * FROM authors ORDER BY author_name")
            return cur.fetchall()
        finally:
            cur.close(); conn.close()

    # ── Categories ───────────────────────────────────────────────────────────

    def get_or_create_category(self, name: str) -> int:
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute("SELECT category_id FROM categories WHERE category_name = %s", (name,))
            row = cur.fetchone()
            if row:
                return row["category_id"]
            cur.execute("INSERT INTO categories (category_name) VALUES (%s)", (name,))
            conn.commit()
            return cur.lastrowid
        finally:
            cur.close(); conn.close()

    def get_all_categories(self):
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute("SELECT * FROM categories ORDER BY category_name")
            return cur.fetchall()
        finally:
            cur.close(); conn.close()

    # ── Books ────────────────────────────────────────────────────────────────

    def get_all_books(self):
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute("SELECT * FROM v_book_summary ORDER BY title")
            return cur.fetchall()
        finally:
            cur.close(); conn.close()

    def search_books(self, keyword: str):
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            like = f"%{keyword}%"
            cur.execute("""
                SELECT * FROM v_book_summary
                WHERE title LIKE %s OR author_name LIKE %s OR category_name LIKE %s
                ORDER BY title
            """, (like, like, like))
            return cur.fetchall()
        finally:
            cur.close(); conn.close()

    def get_book_by_id(self, book_id: int):
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute("SELECT * FROM v_book_summary WHERE book_id = %s", (book_id,))
            return cur.fetchone()
        finally:
            cur.close(); conn.close()

    def add_book(self, title, author_id, category_id, publish_year, isbn):
        conn = get_connection()
        cur  = conn.cursor()
        try:
            cur.execute("""
                INSERT INTO books (title, author_id, category_id, publish_year, isbn)
                VALUES (%s, %s, %s, %s, %s)
            """, (title, author_id, category_id, publish_year, isbn))
            conn.commit()
            return cur.lastrowid
        finally:
            cur.close(); conn.close()

    def update_book(self, book_id, title, author_id, category_id, publish_year, isbn):
        conn = get_connection()
        cur  = conn.cursor()
        try:
            cur.execute("""
                UPDATE books
                SET title=%s, author_id=%s, category_id=%s, publish_year=%s, isbn=%s
                WHERE book_id=%s
            """, (title, author_id, category_id, publish_year, isbn, book_id))
            conn.commit()
            return cur.rowcount
        finally:
            cur.close(); conn.close()

    def delete_book(self, book_id: int):
        conn = get_connection()
        cur  = conn.cursor()
        try:
            cur.execute("DELETE FROM books WHERE book_id = %s", (book_id,))
            conn.commit()
            return cur.rowcount
        finally:
            cur.close(); conn.close()

    # ── Book Copies ──────────────────────────────────────────────────────────

    def add_copies(self, book_id: int, count: int):
        """Generate barcodes and insert `count` copies for a book."""
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute(
                "SELECT COUNT(*) AS n FROM book_copies WHERE book_id = %s", (book_id,)
            )
            existing = cur.fetchone()["n"]
            for i in range(1, count + 1):
                barcode = f"LIB-{book_id:03d}-{existing + i:03d}"
                cur.execute(
                    "INSERT INTO book_copies (book_id, barcode) VALUES (%s, %s)",
                    (book_id, barcode)
                )
            conn.commit()
        finally:
            cur.close(); conn.close()

    def get_copies_by_book(self, book_id: int):
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute(
                "SELECT * FROM book_copies WHERE book_id = %s ORDER BY copy_id",
                (book_id,)
            )
            return cur.fetchall()
        finally:
            cur.close(); conn.close()

    def find_available_copy(self, book_title: str):
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute("""
                SELECT bc.copy_id, bc.barcode
                FROM book_copies bc
                JOIN books b ON bc.book_id = b.book_id
                WHERE b.title = %s AND bc.status = 'AVAILABLE'
                LIMIT 1
            """, (book_title,))
            return cur.fetchone()
        finally:
            cur.close(); conn.close()
