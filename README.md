# Library Management System
**NEU DATCOM Lab — Project 01**

## Project Structure

```
library_app/
├── main.py                          ← Entry point
├── requirements.txt
├── database/
│   ├── connection.py                ← MySQL connection config
│   └── schema.sql                   ← Full schema + sample data
├── repositories/
│   ├── book_repository.py           ← SQL for books, copies, authors, categories
│   └── reader_loan_repository.py    ← SQL for readers and loans
├── services/
│   └── services.py                  ← Business logic (BookService, ReaderService, LoanService)
└── ui/
    └── app.py                       ← Full tkinter GUI
```

## Setup

### 1. Install dependencies
```bash
pip install mysql-connector-python
```

### 2. Set up MySQL database
Open MySQL Workbench (or terminal), run:
```sql
source path/to/database/schema.sql;
```

### 3. Configure your password
Open `database/connection.py`, update:
```python
DB_CONFIG = {
    "host":     "localhost",
    "user":     "root",
    "password": "YOUR_MYSQL_PASSWORD",  # ← change this
    "database": "library_db",
}
```

### 4. Run the app
```bash
cd library_app
python main.py
```

---

## Features

| Feature | Description |
|---|---|
| 🏠 Dashboard | Live stats: books, copies, readers, loans, overdue |
| 📖 Books | Add/edit/delete books, search by title/author/category, add copies |
| 👤 Readers | Register/edit/delete readers, search, block/active status |
| ➕ Borrow | Search by reader phone + book title — no ID entry needed |
| ↩ Return | Return by barcode — auto-calculates overdue days |
| 📋 Active Loans | Live view of all current loans, overdue highlighted |
| ⚠ Overdue | Dedicated overdue alerts table |
| 🕐 History | Full borrow/return history |

## Database Objects

| Object | Name | Purpose |
|---|---|---|
| View | `v_book_summary` | Books with available copy count |
| View | `v_active_loans` | All current loans with details |
| View | `v_overdue_loans` | Overdue loans sorted by days |
| View | `v_loan_history` | Full borrow/return history |
| Trigger | `trg_after_loan_insert` | Mark copy BORROWED when loan created |
| Trigger | `trg_after_loan_update` | Mark copy AVAILABLE when returned |
| Trigger | `trg_mark_overdue_on_borrow` | Refresh overdue status on activity |
| Procedure | `sp_borrow_book` | Full borrow flow with rule checks |
| Procedure | `sp_return_book` | Return by barcode + fine calculation |
| Procedure | `sp_overdue_report` | Overdue books report |
| Function | `fn_overdue_fine` | Calculate fine per overdue day |
| Function | `fn_count_available_copies` | Count available copies for a book |

## Design Decisions

- **BookCopy instead of Quantity**: The library lends *physical copies*, not book titles. Each copy has a unique barcode.
- **User-facing fields only**: The GUI never asks for BookID, ReaderID, or LoanID — only name, phone, barcode.
- **Service layer**: Business rules (blocked reader, overdue check, available copy) live in services, not in UI.
- **Layered architecture**: UI → Service → Repository → MySQL


