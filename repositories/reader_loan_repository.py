"""
repositories/reader_repository.py
repositories/loan_repository.py
Raw SQL operations for readers and loans.
"""

from database.connection import get_connection


# ══════════════════════════════════════════════════════════════════════════════
class ReaderRepository:

    def get_all_readers(self):
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute("SELECT * FROM readers ORDER BY reader_name")
            return cur.fetchall()
        finally:
            cur.close(); conn.close()

    def find_by_phone(self, phone: str):
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute("SELECT * FROM readers WHERE phone = %s", (phone,))
            return cur.fetchone()
        finally:
            cur.close(); conn.close()

    def search_readers(self, keyword: str):
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            like = f"%{keyword}%"
            cur.execute("""
                SELECT * FROM readers
                WHERE reader_name LIKE %s OR phone LIKE %s
                ORDER BY reader_name
            """, (like, like))
            return cur.fetchall()
        finally:
            cur.close(); conn.close()

    def add_reader(self, name, phone, address):
        conn = get_connection()
        cur  = conn.cursor()
        try:
            cur.execute("""
                INSERT INTO readers (reader_name, phone, address)
                VALUES (%s, %s, %s)
            """, (name, phone, address))
            conn.commit()
            return cur.lastrowid
        finally:
            cur.close(); conn.close()

    def update_reader(self, reader_id, name, phone, address, status):
        conn = get_connection()
        cur  = conn.cursor()
        try:
            cur.execute("""
                UPDATE readers SET reader_name=%s, phone=%s, address=%s, status=%s
                WHERE reader_id=%s
            """, (name, phone, address, status, reader_id))
            conn.commit()
            return cur.rowcount
        finally:
            cur.close(); conn.close()

    def delete_reader(self, reader_id: int):
        conn = get_connection()
        cur  = conn.cursor()
        try:
            cur.execute("DELETE FROM readers WHERE reader_id = %s", (reader_id,))
            conn.commit()
            return cur.rowcount
        finally:
            cur.close(); conn.close()

    def count_overdue(self, reader_id: int) -> int:
        conn = get_connection()
        cur  = conn.cursor()
        try:
            cur.execute("""
                SELECT COUNT(*) FROM loans
                WHERE reader_id = %s AND status = 'OVERDUE'
            """, (reader_id,))
            return cur.fetchone()[0]
        finally:
            cur.close(); conn.close()


# ══════════════════════════════════════════════════════════════════════════════
class LoanRepository:

    def create_loan(self, reader_id, copy_id, due_days=14):
        conn = get_connection()
        cur  = conn.cursor()
        try:
            cur.execute("""
                INSERT INTO loans (reader_id, copy_id, borrow_date, due_date)
                VALUES (%s, %s, CURDATE(), DATE_ADD(CURDATE(), INTERVAL %s DAY))
            """, (reader_id, copy_id, due_days))
            conn.commit()
            return cur.lastrowid
        finally:
            cur.close(); conn.close()

    def return_book_by_barcode(self, barcode: str):
        """
        Returns: dict with loan info + overdue_days, or None if not found.
        """
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute("""
                SELECT l.loan_id, l.due_date,
                       GREATEST(0, DATEDIFF(CURDATE(), l.due_date)) AS overdue_days
                FROM loans l
                JOIN book_copies bc ON l.copy_id = bc.copy_id
                WHERE bc.barcode = %s AND l.status IN ('BORROWED','OVERDUE')
                LIMIT 1
            """, (barcode,))
            row = cur.fetchone()
            if not row:
                return None
            cur.execute("""
                UPDATE loans
                SET return_date = CURDATE(), status = 'RETURNED'
                WHERE loan_id = %s
            """, (row["loan_id"],))
            conn.commit()
            return row
        finally:
            cur.close(); conn.close()

    def get_active_loans(self):
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute("SELECT * FROM v_active_loans ORDER BY due_date")
            return cur.fetchall()
        finally:
            cur.close(); conn.close()

    def get_overdue_loans(self):
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute("SELECT * FROM v_overdue_loans")
            return cur.fetchall()
        finally:
            cur.close(); conn.close()

    def get_loan_history(self, reader_id=None):
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            if reader_id:
                cur.execute("""
                    SELECT * FROM v_loan_history WHERE reader_id = %s
                    ORDER BY borrow_date DESC
                """, (reader_id,))
            else:
                cur.execute("SELECT * FROM v_loan_history ORDER BY borrow_date DESC")
            return cur.fetchall()
        finally:
            cur.close(); conn.close()

    def refresh_overdue_status(self):
        """Mark all BORROWED loans past due_date as OVERDUE."""
        conn = get_connection()
        cur  = conn.cursor()
        try:
            cur.execute("""
                UPDATE loans SET status = 'OVERDUE'
                WHERE status = 'BORROWED' AND due_date < CURDATE()
            """)
            conn.commit()
            return cur.rowcount
        finally:
            cur.close(); conn.close()

    def get_stats(self):
        """Return summary stats for dashboard."""
        conn = get_connection()
        cur  = conn.cursor(dictionary=True)
        try:
            cur.execute("""
                SELECT
                    (SELECT COUNT(*) FROM books)                               AS total_books,
                    (SELECT COUNT(*) FROM book_copies)                         AS total_copies,
                    (SELECT COUNT(*) FROM book_copies WHERE status='AVAILABLE') AS available_copies,
                    (SELECT COUNT(*) FROM readers WHERE status='ACTIVE')       AS active_readers,
                    (SELECT COUNT(*) FROM loans WHERE status='BORROWED')       AS borrowed_count,
                    (SELECT COUNT(*) FROM loans WHERE status='OVERDUE')        AS overdue_count
            """)
            return cur.fetchone()
        finally:
            cur.close(); conn.close()
