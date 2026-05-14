"""
services/book_service.py
services/reader_service.py
services/loan_service.py
Business logic layer — enforces rules before touching the DB.
"""

from repositories.book_repository import BookRepository
from repositories.reader_loan_repository import ReaderRepository, LoanRepository


# ══════════════════════════════════════════════════════════════════════════════
class BookService:

    def __init__(self):
        self.repo = BookRepository()

    def add_book(self, title: str, author_name: str, category_name: str,
                 publish_year: int, isbn: str, copies: int = 1):
        title = title.strip()
        if not title:
            raise ValueError("Title cannot be empty.")
        if copies < 1:
            raise ValueError("Must add at least 1 copy.")

        author_id   = self.repo.get_or_create_author(author_name.strip())
        category_id = self.repo.get_or_create_category(category_name.strip())
        book_id     = self.repo.add_book(title, author_id, category_id, publish_year, isbn)
        self.repo.add_copies(book_id, copies)
        return book_id

    def update_book(self, book_id, title, author_name, category_name, publish_year, isbn):
        author_id   = self.repo.get_or_create_author(author_name.strip())
        category_id = self.repo.get_or_create_category(category_name.strip())
        return self.repo.update_book(book_id, title, author_id, category_id, publish_year, isbn)

    def delete_book(self, book_id):
        return self.repo.delete_book(book_id)

    def add_copies(self, book_id: int, count: int):
        if count < 1:
            raise ValueError("Count must be ≥ 1.")
        self.repo.add_copies(book_id, count)

    def get_all_books(self):
        return self.repo.get_all_books()

    def search_books(self, keyword: str):
        return self.repo.search_books(keyword)

    def get_copies(self, book_id: int):
        return self.repo.get_copies_by_book(book_id)

    def get_all_authors(self):
        return self.repo.get_all_authors()

    def get_all_categories(self):
        return self.repo.get_all_categories()


# ══════════════════════════════════════════════════════════════════════════════
class ReaderService:

    def __init__(self):
        self.repo = ReaderRepository()

    def register_reader(self, name: str, phone: str, address: str):
        name = name.strip()
        phone = phone.strip()
        if not name:
            raise ValueError("Name cannot be empty.")
        if not phone:
            raise ValueError("Phone cannot be empty.")
        existing = self.repo.find_by_phone(phone)
        if existing:
            raise ValueError(f"Phone {phone} is already registered.")
        return self.repo.add_reader(name, phone, address)

    def update_reader(self, reader_id, name, phone, address, status):
        if not name.strip():
            raise ValueError("Name cannot be empty.")
        return self.repo.update_reader(reader_id, name, phone, address, status)

    def delete_reader(self, reader_id):
        return self.repo.delete_reader(reader_id)

    def get_all_readers(self):
        return self.repo.get_all_readers()

    def search_readers(self, keyword: str):
        return self.repo.search_readers(keyword)

    def find_by_phone(self, phone: str):
        return self.repo.find_by_phone(phone)


# ══════════════════════════════════════════════════════════════════════════════
class LoanService:

    def __init__(self):
        self.loan_repo   = LoanRepository()
        self.reader_repo = ReaderRepository()
        self.book_repo   = BookRepository()

    def borrow_book(self, reader_phone: str, book_title: str, due_days: int = 14):
        """
        Full borrow flow with business rule checks.
        Returns success message or raises ValueError.
        """
        reader = self.reader_repo.find_by_phone(reader_phone.strip())
        if not reader:
            raise ValueError("Reader not found. Check the phone number.")

        if reader["status"] == "BLOCKED":
            raise ValueError("This reader is BLOCKED and cannot borrow books.")

        overdue = self.reader_repo.count_overdue(reader["reader_id"])
        if overdue > 0:
            raise ValueError(
                f"Reader has {overdue} overdue book(s). Return them first."
            )

        copy = self.book_repo.find_available_copy(book_title.strip())
        if not copy:
            raise ValueError(f'No available copy for "{book_title}".')

        self.loan_repo.create_loan(reader["reader_id"], copy["copy_id"], due_days)
        return f'✅ Borrowed "{book_title}" (barcode: {copy["barcode"]}) for {due_days} days.'

    def return_book(self, barcode: str):
        """
        Return by barcode. Returns result dict or raises ValueError.
        """
        result = self.loan_repo.return_book_by_barcode(barcode.strip())
        if not result:
            raise ValueError("No active loan found for this barcode.")

        if result["overdue_days"] > 0:
            return {
                "message": f'✅ Returned. Overdue by {result["overdue_days"]} day(s).',
                "overdue_days": result["overdue_days"],
            }
        return {"message": "✅ Book returned on time.", "overdue_days": 0}

    def get_active_loans(self):
        self.loan_repo.refresh_overdue_status()
        return self.loan_repo.get_active_loans()

    def get_overdue_loans(self):
        self.loan_repo.refresh_overdue_status()
        return self.loan_repo.get_overdue_loans()

    def get_loan_history(self, reader_id=None):
        return self.loan_repo.get_loan_history(reader_id)

    def get_dashboard_stats(self):
        return self.loan_repo.get_stats()
