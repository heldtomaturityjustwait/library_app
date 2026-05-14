-- ============================================================
-- LIBRARY MANAGEMENT SYSTEM - DATABASE SCHEMA
-- NEU DATCOM Lab - Project 01
-- Schema: Improved design with BookCopy + Loans
-- ============================================================

DROP DATABASE IF EXISTS library_db;
CREATE DATABASE library_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE library_db;

-- ============================================================
-- CORE TABLES
-- ============================================================

CREATE TABLE categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE authors (
    author_id   INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE books (
    book_id      INT AUTO_INCREMENT PRIMARY KEY,
    title        VARCHAR(255) NOT NULL,
    author_id    INT NOT NULL,
    category_id  INT NOT NULL,
    publish_year INT,
    isbn         VARCHAR(30),
    FOREIGN KEY (author_id)   REFERENCES authors(author_id)   ON DELETE RESTRICT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE book_copies (
    copy_id  INT AUTO_INCREMENT PRIMARY KEY,
    book_id  INT NOT NULL,
    barcode  VARCHAR(50) NOT NULL UNIQUE,
    status   ENUM('AVAILABLE','BORROWED','LOST','DAMAGED') DEFAULT 'AVAILABLE',
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);

CREATE TABLE readers (
    reader_id   INT AUTO_INCREMENT PRIMARY KEY,
    reader_name VARCHAR(255) NOT NULL,
    phone       VARCHAR(20) UNIQUE,
    address     VARCHAR(255),
    status      ENUM('ACTIVE','BLOCKED') DEFAULT 'ACTIVE'
);

CREATE TABLE loans (
    loan_id     INT AUTO_INCREMENT PRIMARY KEY,
    reader_id   INT NOT NULL,
    copy_id     INT NOT NULL,
    borrow_date DATE NOT NULL DEFAULT (CURDATE()),
    due_date    DATE NOT NULL,
    return_date DATE NULL,
    status      ENUM('BORROWED','RETURNED','OVERDUE') DEFAULT 'BORROWED',
    FOREIGN KEY (reader_id) REFERENCES readers(reader_id) ON DELETE RESTRICT,
    FOREIGN KEY (copy_id)   REFERENCES book_copies(copy_id) ON DELETE RESTRICT
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

INSERT INTO categories (category_name) VALUES
    ('Programming'),
    ('Database'),
    ('Algorithms'),
    ('Software Engineering'),
    ('Data Science'),
    ('Business'),
    ('Philosophy');

INSERT INTO authors (author_name) VALUES
    ('Robert C. Martin'),
    ('Thomas H. Cormen'),
    ('Yuval Noah Harari'),
    ('Wes McKinney'),
    ('Abraham Silberschatz'),
    ('Eric Evans'),
    ('Andrew Ng');

INSERT INTO books (title, author_id, category_id, publish_year, isbn) VALUES
    ('Clean Code',                        1, 1, 2008, '978-0132350884'),
    ('Introduction to Algorithms',        2, 3, 2009, '978-0262033848'),
    ('Sapiens',                           3, 7, 2011, '978-0062316097'),
    ('Python for Data Analysis',          4, 5, 2022, '978-1098104030'),
    ('Database System Concepts',          5, 2, 2019, '978-0078022159'),
    ('Domain-Driven Design',              6, 4, 2003, '978-0321125217'),
    ('The Pragmatic Programmer',          1, 1, 2019, '978-0135957059'),
    ('Machine Learning Yearning',         7, 5, 2018, NULL),
    ('Homo Deus',                         3, 7, 2015, '978-0062464316'),
    ('SQL Performance Explained',         5, 2, 2012, '978-3950307825');

-- Generate barcodes: format LIB-BOOKID-COPYNUM
INSERT INTO book_copies (book_id, barcode, status) VALUES
    (1, 'LIB-001-001', 'AVAILABLE'),
    (1, 'LIB-001-002', 'AVAILABLE'),
    (1, 'LIB-001-003', 'AVAILABLE'),
    (2, 'LIB-002-001', 'AVAILABLE'),
    (2, 'LIB-002-002', 'AVAILABLE'),
    (3, 'LIB-003-001', 'AVAILABLE'),
    (3, 'LIB-003-002', 'AVAILABLE'),
    (4, 'LIB-004-001', 'AVAILABLE'),
    (4, 'LIB-004-002', 'AVAILABLE'),
    (5, 'LIB-005-001', 'AVAILABLE'),
    (5, 'LIB-005-002', 'AVAILABLE'),
    (6, 'LIB-006-001', 'AVAILABLE'),
    (7, 'LIB-007-001', 'AVAILABLE'),
    (7, 'LIB-007-002', 'AVAILABLE'),
    (8, 'LIB-008-001', 'AVAILABLE'),
    (9, 'LIB-009-001', 'AVAILABLE'),
    (9, 'LIB-009-002', 'AVAILABLE'),
    (10,'LIB-010-001', 'AVAILABLE');

INSERT INTO readers (reader_name, phone, address) VALUES
    ('Nguyen Van An',     '0901234567', '12 Le Loi, Ha Noi'),
    ('Tran Thi Binh',     '0912345678', '45 Tran Hung Dao, Ha Noi'),
    ('Le Van Cuong',      '0923456789', '78 Ly Thuong Kiet, Ha Noi'),
    ('Pham Thi Dung',     '0934567890', '23 Dinh Tien Hoang, Ha Noi'),
    ('Hoang Van Em',      '0945678901', '56 Hai Ba Trung, Ha Noi'),
    ('Bui Thi Phuong',    '0956789012', '89 Nguyen Hue, Ha Noi'),
    ('Do Van Giang',      '0967890123', '34 Ba Trieu, Ha Noi');

-- Sample loans (some active, some returned, one overdue)
INSERT INTO loans (reader_id, copy_id, borrow_date, due_date, return_date, status) VALUES
    (1, 1,  DATE_SUB(CURDATE(), INTERVAL 5  DAY), DATE_ADD(CURDATE(), INTERVAL 9  DAY), NULL,       'BORROWED'),
    (2, 4,  DATE_SUB(CURDATE(), INTERVAL 20 DAY), DATE_SUB(CURDATE(), INTERVAL 6  DAY), NULL,       'OVERDUE'),
    (3, 6,  DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_ADD(CURDATE(), INTERVAL 4  DAY), NULL,       'BORROWED'),
    (4, 8,  DATE_SUB(CURDATE(), INTERVAL 30 DAY), DATE_SUB(CURDATE(), INTERVAL 16 DAY), CURDATE(),  'RETURNED'),
    (5, 10, DATE_SUB(CURDATE(), INTERVAL 7  DAY), DATE_ADD(CURDATE(), INTERVAL 7  DAY), NULL,       'BORROWED');

-- Sync copy statuses to match loans above
UPDATE book_copies SET status = 'BORROWED'   WHERE copy_id IN (1, 4, 6, 10);
UPDATE book_copies SET status = 'AVAILABLE'  WHERE copy_id = 8;

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_books_title      ON books(title);
CREATE INDEX idx_books_author     ON books(author_id);
CREATE INDEX idx_books_category   ON books(category_id);
CREATE INDEX idx_copies_book      ON book_copies(book_id);
CREATE INDEX idx_copies_status    ON book_copies(status);
CREATE INDEX idx_loans_reader     ON loans(reader_id);
CREATE INDEX idx_loans_copy       ON loans(copy_id);
CREATE INDEX idx_loans_status     ON loans(status);
CREATE INDEX idx_readers_phone    ON readers(phone);

-- ============================================================
-- TRIGGERS
-- ============================================================

DELIMITER $$

-- Auto-update copy status to BORROWED when loan is created
CREATE TRIGGER trg_after_loan_insert
AFTER INSERT ON loans
FOR EACH ROW
BEGIN
    UPDATE book_copies SET status = 'BORROWED' WHERE copy_id = NEW.copy_id;
END$$

-- Auto-update copy status to AVAILABLE when book is returned
CREATE TRIGGER trg_after_loan_update
AFTER UPDATE ON loans
FOR EACH ROW
BEGIN
    IF NEW.status = 'RETURNED' AND OLD.status != 'RETURNED' THEN
        UPDATE book_copies SET status = 'AVAILABLE' WHERE copy_id = NEW.copy_id;
    END IF;
END$$

-- Auto mark overdue loans every day (called via scheduled event)
CREATE TRIGGER trg_mark_overdue_on_borrow
BEFORE INSERT ON loans
FOR EACH ROW
BEGIN
    -- Update any existing overdue loans for this reader
    UPDATE loans
    SET status = 'OVERDUE'
    WHERE reader_id = NEW.reader_id
      AND status = 'BORROWED'
      AND due_date < CURDATE();
END$$

DELIMITER ;

-- ============================================================
-- VIEWS
-- ============================================================

-- Full book info with author, category, available copies count
CREATE VIEW v_book_summary AS
SELECT
    b.book_id,
    b.title,
    a.author_name,
    c.category_name,
    b.publish_year,
    b.isbn,
    COUNT(bc.copy_id)                                          AS total_copies,
    SUM(bc.status = 'AVAILABLE')                               AS available_copies,
    SUM(bc.status = 'BORROWED')                                AS borrowed_copies
FROM books b
JOIN authors    a  ON b.author_id   = a.author_id
JOIN categories c  ON b.category_id = c.category_id
LEFT JOIN book_copies bc ON b.book_id = bc.book_id
GROUP BY b.book_id, b.title, a.author_name, c.category_name, b.publish_year, b.isbn;

-- Active loans with full details
CREATE VIEW v_active_loans AS
SELECT
    l.loan_id,
    r.reader_name,
    r.phone,
    bk.title        AS book_title,
    a.author_name,
    bc.barcode,
    l.borrow_date,
    l.due_date,
    DATEDIFF(CURDATE(), l.due_date) AS overdue_days,
    l.status
FROM loans l
JOIN readers    r  ON l.reader_id = r.reader_id
JOIN book_copies bc ON l.copy_id  = bc.copy_id
JOIN books      bk ON bc.book_id  = bk.book_id
JOIN authors    a  ON bk.author_id = a.author_id
WHERE l.status IN ('BORROWED', 'OVERDUE');

-- Overdue loans specifically
CREATE VIEW v_overdue_loans AS
SELECT * FROM v_active_loans
WHERE overdue_days > 0
ORDER BY overdue_days DESC;

-- Reader borrowing history
CREATE VIEW v_loan_history AS
SELECT
    l.loan_id,
    r.reader_name,
    r.phone,
    bk.title        AS book_title,
    bc.barcode,
    l.borrow_date,
    l.due_date,
    l.return_date,
    l.status,
    CASE
        WHEN l.return_date IS NOT NULL THEN DATEDIFF(l.return_date, l.due_date)
        WHEN l.status = 'OVERDUE'     THEN DATEDIFF(CURDATE(), l.due_date)
        ELSE 0
    END AS overdue_days
FROM loans l
JOIN readers     r  ON l.reader_id = r.reader_id
JOIN book_copies bc ON l.copy_id   = bc.copy_id
JOIN books       bk ON bc.book_id  = bk.book_id;

-- ============================================================
-- STORED PROCEDURES
-- ============================================================

DELIMITER $$

-- Borrow a book: find available copy and create loan
CREATE PROCEDURE sp_borrow_book(
    IN  p_reader_phone  VARCHAR(20),
    IN  p_book_title    VARCHAR(255),
    IN  p_days          INT,          -- loan duration in days
    OUT p_result        VARCHAR(255)
)
BEGIN
    DECLARE v_reader_id   INT DEFAULT NULL;
    DECLARE v_reader_status ENUM('ACTIVE','BLOCKED');
    DECLARE v_overdue_cnt INT DEFAULT 0;
    DECLARE v_copy_id     INT DEFAULT NULL;

    -- Find reader
    SELECT reader_id, status
    INTO v_reader_id, v_reader_status
    FROM readers WHERE phone = p_reader_phone LIMIT 1;

    IF v_reader_id IS NULL THEN
        SET p_result = 'ERROR: Reader not found.';
    ELSEIF v_reader_status = 'BLOCKED' THEN
        SET p_result = 'ERROR: Reader is blocked.';
    ELSE
        -- Check overdue
        SELECT COUNT(*) INTO v_overdue_cnt
        FROM loans
        WHERE reader_id = v_reader_id AND status = 'OVERDUE';

        IF v_overdue_cnt > 0 THEN
            SET p_result = 'ERROR: Reader has overdue books. Return them first.';
        ELSE
            -- Find available copy
            SELECT bc.copy_id INTO v_copy_id
            FROM book_copies bc
            JOIN books b ON bc.book_id = b.book_id
            WHERE b.title = p_book_title AND bc.status = 'AVAILABLE'
            LIMIT 1;

            IF v_copy_id IS NULL THEN
                SET p_result = 'ERROR: No available copy for this book.';
            ELSE
                INSERT INTO loans (reader_id, copy_id, borrow_date, due_date)
                VALUES (v_reader_id, v_copy_id, CURDATE(), DATE_ADD(CURDATE(), INTERVAL p_days DAY));

                SET p_result = CONCAT('SUCCESS: Borrowed copy #', v_copy_id, ' due in ', p_days, ' days.');
            END IF;
        END IF;
    END IF;
END$$

-- Return a book by barcode
CREATE PROCEDURE sp_return_book(
    IN  p_barcode   VARCHAR(50),
    OUT p_result    VARCHAR(255)
)
BEGIN
    DECLARE v_loan_id   INT DEFAULT NULL;
    DECLARE v_due_date  DATE;
    DECLARE v_overdue   INT DEFAULT 0;

    SELECT l.loan_id, l.due_date INTO v_loan_id, v_due_date
    FROM loans l
    JOIN book_copies bc ON l.copy_id = bc.copy_id
    WHERE bc.barcode = p_barcode AND l.status IN ('BORROWED','OVERDUE')
    LIMIT 1;

    IF v_loan_id IS NULL THEN
        SET p_result = 'ERROR: No active loan found for this barcode.';
    ELSE
        SET v_overdue = GREATEST(0, DATEDIFF(CURDATE(), v_due_date));

        UPDATE loans
        SET return_date = CURDATE(), status = 'RETURNED'
        WHERE loan_id = v_loan_id;

        IF v_overdue > 0 THEN
            SET p_result = CONCAT('SUCCESS: Returned. Overdue by ', v_overdue, ' day(s). Fine may apply.');
        ELSE
            SET p_result = 'SUCCESS: Book returned on time.';
        END IF;
    END IF;
END$$

-- Get overdue report
CREATE PROCEDURE sp_overdue_report()
BEGIN
    SELECT
        reader_name,
        phone,
        book_title,
        barcode,
        borrow_date,
        due_date,
        overdue_days
    FROM v_overdue_loans;
END$$

DELIMITER ;

-- ============================================================
-- USER DEFINED FUNCTIONS
-- ============================================================

DELIMITER $$

CREATE FUNCTION fn_overdue_fine(p_loan_id INT, p_fine_per_day DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_overdue INT;
    SELECT GREATEST(0, DATEDIFF(IFNULL(return_date, CURDATE()), due_date))
    INTO v_overdue
    FROM loans WHERE loan_id = p_loan_id;
    RETURN v_overdue * p_fine_per_day;
END$$

CREATE FUNCTION fn_count_available_copies(p_book_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count
    FROM book_copies
    WHERE book_id = p_book_id AND status = 'AVAILABLE';
    RETURN v_count;
END$$

DELIMITER ;
