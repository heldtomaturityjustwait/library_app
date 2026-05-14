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
    ('Andrew Ng'),
    ('Martin Fowler'),
    ('Donald Knuth'),
    ('Bjarne Stroustrup'),
    ('Brian Kernighan'),
    ('Dennis Ritchie'),
    ('Kent Beck'),
    ('Erich Gamma'),
    ('Richard Helm'),
    ('Ralph Johnson'),
    ('John Vlissides'),
    ('Steve McConnell'),
    ('Gayle Laakmann McDowell'),
    ('Martin Kleppmann'),
    ('Cathy O''Neil'),
    ('Nassim Nicholas Taleb'),
    ('Daniel Kahneman'),
    ('Peter Thiel'),
    ('Clayton Christensen'),
    ('Michael Porter'),
    ('Simon Sinek'),
    ('Adam Grant'),
    ('Cal Newport'),
    ('James Clear'),
    ('Peter Norvig'),
    ('Stuart Russell'),
    ('Ian Goodfellow'),
    ('Yoshua Bengio'),
    ('Aaron Courville'),
    ('Aurélien Géron'),
    ('Jake VanderPlas'),
    ('Joel Grus'),
    ('Hadley Wickham'),
    ('Garrett Grolemund'),
    ('Chris Date'),
    ('Hector Garcia-Molina'),
    ('Jeffrey Ullman'),
    ('Jennifer Widom'),
    ('Raghu Ramakrishnan'),
    ('Johannes Gehrke'),
    ('Mark Richards'),
    ('Neal Ford'),
    ('Sam Newman'),
    ('Vaughn Vernon'),
    ('Gregor Hohpe'),
    ('Bobby Woolf'),
    ('Frederick Brooks'),
    ('David Thomas'),
    ('Andrew Hunt'),
    ('Sandi Metz'),
    ('Robert Sedgewick'),
    ('Kevin Wayne'),
    ('Jon Kleinberg'),
    ('Éva Tardos'),
    ('Steven Skiena'),
    ('Noam Chomsky'),
    ('Bertrand Russell'),
    ('Ludwig Wittgenstein'),
    ('Marcus Aurelius'),
    ('Plato'),
    ('Aristotle'),
    ('Friedrich Nietzsche'),
    ('Albert Camus'),
    ('Jean-Paul Sartre'),
    ('Simone de Beauvoir'),
    ('Michel Foucault'),
    ('Hannah Arendt'),
    ('Confucius'),
    ('Laozi'),
    ('Sun Tzu'),
    ('Ray Dalio'),
    ('Ben Horowitz'),
    ('Jim Collins'),
    ('Thomas Davenport'),
    ('DJ Patil'),
    ('Max Tegmark'),
    ('Nick Bostrom'),
    ('Judea Pearl'),
    ('Douglas Hofstadter'),
    ('Steven Pinker'),
    ('Richard Dawkins'),
    ('Carl Sagan'),
    ('Stephen Hawking'),
    ('Virginia Eubanks'),
    ('Shoshana Zuboff'),
    ('Edward Tufte'),
    ('Stephen Few'),
    ('Kimball Ralph'),
    ('Bill Inmon'),
    ('Andy Kirk'),
    ('Kieran Healy'),
    ('Alex Xu'),
    ('Jay Kreps'),
    ('Nathan Marz'),
    ('James Warren'),
    ('Holden Karau'),
    ('Matei Zaharia'),
    ('Maja Mataric'),
    ('Pedro Domingos'),
    ('Tom Mitchell');

INSERT INTO books (title, author_id, category_id, publish_year, isbn) VALUES
    ('Clean Systems', 1, 1, 1992, '978-1000000001'),
    ('Practical Systems', 2, 1, 1999, '978-1000000002'),
    ('Modern Systems', 3, 1, 2006, '978-1000000003'),
    ('Effective Systems', 4, 1, 2013, '978-1000000004'),
    ('The Systems Handbook', 5, 1, 2020, '978-1000000005'),
    ('Systems in Practice', 6, 1, 1987, '978-1000000006'),
    ('Advanced Systems', 7, 1, 1994, '978-1000000007'),
    ('Refactoring Systems', 8, 1, 2001, '978-1000000008'),
    ('Systems Patterns', 9, 1, 2008, '978-1000000009'),
    ('Mastering Systems', 10, 1, 2015, '978-1000000010'),
    ('Clean Thinking', 11, 1, 2022, '978-1000000011'),
    ('Practical Thinking', 12, 1, 1989, '978-1000000012'),
    ('Modern Thinking', 13, 1, 1996, '978-1000000013'),
    ('Effective Thinking', 14, 1, 2003, '978-1000000014'),
    ('The Thinking Handbook', 15, 1, 2010, '978-1000000015'),
    ('Thinking in Practice', 16, 1, 2017, '978-1000000016'),
    ('Advanced Thinking', 17, 1, 2024, '978-1000000017'),
    ('Refactoring Thinking', 18, 1, 1991, '978-1000000018'),
    ('Thinking Patterns', 19, 1, 1998, '978-1000000019'),
    ('Mastering Thinking', 20, 1, 2005, '978-1000000020'),
    ('Clean Practice', 21, 1, 2012, '978-1000000021'),
    ('Practical Practice', 22, 1, 2019, '978-1000000022'),
    ('Modern Practice', 23, 1, 1986, '978-1000000023'),
    ('Effective Practice', 24, 1, 1993, '978-1000000024'),
    ('The Practice Handbook', 25, 1, 2000, '978-1000000025'),
    ('Practice in Practice', 26, 1, 2007, '978-1000000026'),
    ('Advanced Practice', 27, 1, 2014, '978-1000000027'),
    ('Refactoring Practice', 28, 1, 2021, '978-1000000028'),
    ('Practice Patterns', 29, 1, 1988, '978-1000000029'),
    ('Mastering Practice', 30, 1, 1995, '978-1000000030'),
    ('Clean Design', 31, 1, 2002, '978-1000000031'),
    ('Practical Design', 32, 1, 2009, '978-1000000032'),
    ('Modern Design', 33, 1, 2016, '978-1000000033'),
    ('Effective Design', 34, 1, 2023, '978-1000000034'),
    ('The Design Handbook', 35, 1, 1990, '978-1000000035'),
    ('Design in Practice', 36, 1, 1997, '978-1000000036'),
    ('Advanced Design', 37, 1, 2004, '978-1000000037'),
    ('Refactoring Design', 38, 1, 2011, '978-1000000038'),
    ('Design Patterns', 39, 1, 2018, '978-1000000039'),
    ('Mastering Design', 40, 1, 1985, '978-1000000040'),
    ('Clean Learning', 41, 1, 1992, '978-1000000041'),
    ('Practical Learning', 42, 1, 1999, '978-1000000042'),
    ('Modern Learning', 43, 1, 2006, '978-1000000043'),
    ('Effective Learning', 44, 1, 2013, '978-1000000044'),
    ('The Learning Handbook', 45, 1, 2020, '978-1000000045'),
    ('Learning in Practice', 46, 1, 1987, '978-1000000046'),
    ('Advanced Learning', 47, 1, 1994, '978-1000000047'),
    ('Refactoring Learning', 48, 1, 2001, '978-1000000048'),
    ('Learning Patterns', 49, 1, 2008, '978-1000000049'),
    ('Mastering Learning', 50, 1, 2015, '978-1000000050'),
    ('Clean Reasoning', 51, 1, 2022, '978-1000000051'),
    ('Practical Reasoning', 52, 1, 1989, '978-1000000052'),
    ('Modern Reasoning', 53, 1, 1996, '978-1000000053'),
    ('Effective Reasoning', 54, 1, 2003, '978-1000000054'),
    ('The Reasoning Handbook', 55, 1, 2010, '978-1000000055'),
    ('Reasoning in Practice', 56, 1, 2017, '978-1000000056'),
    ('Advanced Reasoning', 57, 1, 2024, '978-1000000057'),
    ('Refactoring Reasoning', 58, 1, 1991, '978-1000000058'),
    ('Reasoning Patterns', 59, 1, 1998, '978-1000000059'),
    ('Mastering Reasoning', 60, 1, 2005, '978-1000000060'),
    ('Clean Computation', 61, 1, 2012, '978-1000000061'),
    ('Practical Computation', 62, 1, 2019, '978-1000000062'),
    ('Modern Computation', 63, 1, 1986, '978-1000000063'),
    ('Effective Computation', 64, 1, 1993, '978-1000000064'),
    ('The Computation Handbook', 65, 1, 2000, '978-1000000065'),
    ('Computation in Practice', 66, 1, 2007, '978-1000000066'),
    ('Advanced Computation', 67, 1, 2014, '978-1000000067'),
    ('Refactoring Computation', 68, 1, 2021, '978-1000000068'),
    ('Computation Patterns', 69, 1, 1988, '978-1000000069'),
    ('Mastering Computation', 70, 1, 1995, '978-1000000070'),
    ('Clean Knowledge', 71, 1, 2002, '978-1000000071'),
    ('Practical Knowledge', 72, 1, 2009, '978-1000000072'),
    ('Modern Knowledge', 73, 1, 2016, '978-1000000073'),
    ('Effective Knowledge', 74, 1, 2023, '978-1000000074'),
    ('The Knowledge Handbook', 75, 1, 1990, '978-1000000075'),
    ('Knowledge in Practice', 76, 1, 1997, '978-1000000076'),
    ('Advanced Knowledge', 77, 1, 2004, '978-1000000077'),
    ('Refactoring Knowledge', 78, 1, 2011, '978-1000000078'),
    ('Knowledge Patterns', 79, 1, 2018, '978-1000000079'),
    ('Mastering Knowledge', 80, 1, 1985, '978-1000000080'),
    ('Clean Methods', 81, 1, 1992, '978-1000000081'),
    ('Practical Methods', 82, 1, 1999, '978-1000000082'),
    ('Modern Methods', 83, 1, 2006, '978-1000000083'),
    ('Effective Methods', 84, 1, 2013, '978-1000000084'),
    ('The Methods Handbook', 85, 1, 2020, '978-1000000085'),
    ('Methods in Practice', 86, 1, 1987, '978-1000000086'),
    ('Advanced Methods', 87, 1, 1994, '978-1000000087'),
    ('Refactoring Methods', 88, 1, 2001, '978-1000000088'),
    ('Methods Patterns', 89, 1, 2008, '978-1000000089'),
    ('Mastering Methods', 90, 1, 2015, '978-1000000090'),
    ('Clean Principles', 91, 1, 2022, '978-1000000091'),
    ('Practical Principles', 92, 1, 1989, '978-1000000092'),
    ('Modern Principles', 93, 1, 1996, '978-1000000093'),
    ('Effective Principles', 94, 1, 2003, '978-1000000094'),
    ('The Principles Handbook', 95, 1, 2010, '978-1000000095'),
    ('Principles in Practice', 96, 1, 2017, '978-1000000096'),
    ('Advanced Principles', 97, 1, 2024, '978-1000000097'),
    ('Refactoring Principles', 98, 1, 1991, '978-1000000098'),
    ('Principles Patterns', 99, 1, 1998, '978-1000000099'),
    ('Mastering Principles', 100, 1, 2005, '978-1000000100'),
    ('Clean Foundations', 101, 1, 2012, '978-1000000101'),
    ('Practical Foundations', 102, 1, 2019, '978-1000000102'),
    ('Modern Foundations', 103, 1, 1986, '978-1000000103'),
    ('Effective Foundations', 104, 1, 1993, '978-1000000104'),
    ('The Foundations Handbook', 105, 1, 2000, '978-1000000105'),
    ('Foundations in Practice', 106, 1, 2007, '978-1000000106'),
    ('Advanced Foundations', 1, 1, 2014, '978-1000000107'),
    ('Refactoring Foundations', 2, 1, 2021, '978-1000000108'),
    ('Foundations Patterns', 3, 1, 1988, '978-1000000109'),
    ('Mastering Foundations', 4, 1, 1995, '978-1000000110'),
    ('Clean Applications', 5, 1, 2002, '978-1000000111'),
    ('Practical Applications', 6, 1, 2009, '978-1000000112'),
    ('Modern Applications', 7, 1, 2016, '978-1000000113'),
    ('Effective Applications', 8, 1, 2023, '978-1000000114'),
    ('The Applications Handbook', 9, 1, 1990, '978-1000000115'),
    ('Applications in Practice', 10, 1, 1997, '978-1000000116'),
    ('Advanced Applications', 11, 1, 2004, '978-1000000117'),
    ('Refactoring Applications', 12, 1, 2011, '978-1000000118'),
    ('Applications Patterns', 13, 1, 2018, '978-1000000119'),
    ('Mastering Applications', 14, 1, 1985, '978-1000000120'),
    ('Clean Craft', 15, 1, 1992, '978-1000000121'),
    ('Practical Craft', 16, 1, 1999, '978-1000000122'),
    ('Modern Craft', 17, 1, 2006, '978-1000000123'),
    ('Effective Craft', 18, 1, 2013, '978-1000000124'),
    ('The Craft Handbook', 19, 1, 2020, '978-1000000125'),
    ('Craft in Practice', 20, 1, 1987, '978-1000000126'),
    ('Advanced Craft', 21, 1, 1994, '978-1000000127'),
    ('Refactoring Craft', 22, 1, 2001, '978-1000000128'),
    ('Craft Patterns', 23, 1, 2008, '978-1000000129'),
    ('Mastering Craft', 24, 1, 2015, '978-1000000130'),
    ('Clean Analysis', 25, 1, 2022, '978-1000000131'),
    ('Practical Analysis', 26, 1, 1989, '978-1000000132'),
    ('Modern Analysis', 27, 1, 1996, '978-1000000133'),
    ('Effective Analysis', 28, 1, 2003, '978-1000000134'),
    ('The Analysis Handbook', 29, 1, 2010, '978-1000000135'),
    ('Analysis in Practice', 30, 1, 2017, '978-1000000136'),
    ('Advanced Analysis', 31, 1, 2024, '978-1000000137'),
    ('Refactoring Analysis', 32, 1, 1991, '978-1000000138'),
    ('Analysis Patterns', 33, 1, 1998, '978-1000000139'),
    ('Mastering Analysis', 34, 1, 2005, '978-1000000140'),
    ('Clean Architecture', 35, 1, 2012, '978-1000000141'),
    ('Practical Architecture', 36, 1, 2019, '978-1000000142'),
    ('Modern Architecture', 37, 1, 1986, '978-1000000143'),
    ('Effective Architecture', 38, 1, 1993, '978-1000000144'),
    ('The Architecture Handbook', 39, 1, 2000, '978-1000000145'),
    ('Architecture in Practice', 40, 1, 2007, '978-1000000146'),
    ('Advanced Architecture', 41, 1, 2014, '978-1000000147'),
    ('Refactoring Architecture', 42, 1, 2021, '978-1000000148'),
    ('Architecture Patterns', 43, 1, 1988, '978-1000000149'),
    ('Mastering Architecture', 44, 1, 1995, '978-1000000150'),
    ('Clean Models', 45, 1, 2002, '978-1000000151'),
    ('Practical Models', 46, 1, 2009, '978-1000000152'),
    ('Modern Models', 47, 1, 2016, '978-1000000153'),
    ('Effective Models', 48, 1, 2023, '978-1000000154'),
    ('The Models Handbook', 49, 1, 1990, '978-1000000155'),
    ('Models in Practice', 50, 1, 1997, '978-1000000156'),
    ('Advanced Models', 51, 1, 2004, '978-1000000157'),
    ('Refactoring Models', 52, 1, 2011, '978-1000000158'),
    ('Models Patterns', 53, 1, 2018, '978-1000000159'),
    ('Mastering Models', 54, 1, 1985, '978-1000000160'),
    ('Clean Tools', 55, 1, 1992, '978-1000000161'),
    ('Practical Tools', 56, 1, 1999, '978-1000000162'),
    ('Modern Tools', 57, 1, 2006, '978-1000000163'),
    ('Effective Tools', 58, 1, 2013, '978-1000000164'),
    ('The Tools Handbook', 59, 1, 2020, '978-1000000165'),
    ('Tools in Practice', 60, 1, 1987, '978-1000000166'),
    ('Advanced Tools', 61, 1, 1994, '978-1000000167'),
    ('Refactoring Tools', 62, 1, 2001, '978-1000000168'),
    ('Tools Patterns', 63, 1, 2008, '978-1000000169'),
    ('Mastering Tools', 64, 1, 2015, '978-1000000170'),
    ('Clean Workflows', 65, 1, 2022, '978-1000000171'),
    ('Practical Workflows', 66, 1, 1989, '978-1000000172'),
    ('Modern Workflows', 67, 1, 1996, '978-1000000173'),
    ('Effective Workflows', 68, 1, 2003, '978-1000000174'),
    ('The Workflows Handbook', 69, 1, 2010, '978-1000000175'),
    ('Workflows in Practice', 70, 1, 2017, '978-1000000176'),
    ('Advanced Workflows', 71, 1, 2024, '978-1000000177'),
    ('Refactoring Workflows', 72, 1, 1991, '978-1000000178'),
    ('Workflows Patterns', 73, 1, 1998, '978-1000000179'),
    ('Mastering Workflows', 74, 1, 2005, '978-1000000180'),
    ('Clean Problems', 75, 1, 2012, '978-1000000181'),
    ('Practical Problems', 76, 1, 2019, '978-1000000182'),
    ('Modern Problems', 77, 1, 1986, '978-1000000183'),
    ('Effective Problems', 78, 1, 1993, '978-1000000184'),
    ('The Problems Handbook', 79, 1, 2000, '978-1000000185'),
    ('Problems in Practice', 80, 1, 2007, '978-1000000186'),
    ('Advanced Problems', 81, 1, 2014, '978-1000000187'),
    ('Refactoring Problems', 82, 1, 2021, '978-1000000188'),
    ('Problems Patterns', 83, 1, 1988, '978-1000000189'),
    ('Mastering Problems', 84, 1, 1995, '978-1000000190'),
    ('Clean Solutions', 85, 1, 2002, '978-1000000191'),
    ('Practical Solutions', 86, 1, 2009, '978-1000000192'),
    ('Modern Solutions', 87, 1, 2016, '978-1000000193'),
    ('Effective Solutions', 88, 1, 2023, '978-1000000194'),
    ('The Solutions Handbook', 89, 1, 1990, '978-1000000195'),
    ('Solutions in Practice', 90, 1, 1997, '978-1000000196'),
    ('Advanced Solutions', 91, 1, 2004, '978-1000000197'),
    ('Refactoring Solutions', 92, 1, 2011, '978-1000000198'),
    ('Solutions Patterns', 93, 1, 2018, '978-1000000199'),
    ('Mastering Solutions', 94, 1, 1985, '978-1000000200'),
    ('Clean Ideas', 95, 1, 1992, '978-1000000201'),
    ('Practical Ideas', 96, 1, 1999, '978-1000000202'),
    ('Modern Ideas', 97, 1, 2006, '978-1000000203'),
    ('Effective Ideas', 98, 1, 2013, '978-1000000204'),
    ('The Ideas Handbook', 99, 1, 2020, '978-1000000205'),
    ('Ideas in Practice', 100, 1, 1987, '978-1000000206'),
    ('Advanced Ideas', 101, 1, 1994, '978-1000000207'),
    ('Refactoring Ideas', 102, 1, 2001, '978-1000000208'),
    ('Ideas Patterns', 103, 1, 2008, '978-1000000209'),
    ('Mastering Ideas', 104, 1, 2015, '978-1000000210'),
    ('Clean Decisions', 105, 1, 2022, '978-1000000211'),
    ('Practical Decisions', 106, 1, 1989, '978-1000000212'),
    ('Modern Decisions', 1, 1, 1996, '978-1000000213'),
    ('Effective Decisions', 2, 1, 2003, '978-1000000214'),
    ('The Decisions Handbook', 3, 1, 2010, '978-1000000215'),
    ('Decisions in Practice', 4, 1, 2017, '978-1000000216'),
    ('Advanced Decisions', 5, 1, 2024, '978-1000000217'),
    ('Refactoring Decisions', 6, 1, 1991, '978-1000000218'),
    ('Decisions Patterns', 7, 1, 1998, '978-1000000219'),
    ('Mastering Decisions', 8, 1, 2005, '978-1000000220'),
    ('Clean Patterns', 9, 1, 2012, '978-1000000221'),
    ('Practical Patterns', 10, 1, 2019, '978-1000000222'),
    ('Modern Patterns', 11, 1, 1986, '978-1000000223'),
    ('Effective Patterns', 12, 1, 1993, '978-1000000224'),
    ('The Patterns Handbook', 13, 1, 2000, '978-1000000225'),
    ('Patterns in Practice', 14, 1, 2007, '978-1000000226'),
    ('Advanced Patterns', 15, 1, 2014, '978-1000000227'),
    ('Refactoring Patterns', 16, 1, 2021, '978-1000000228'),
    ('Patterns Patterns', 17, 1, 1988, '978-1000000229'),
    ('Mastering Patterns', 18, 1, 1995, '978-1000000230'),
    ('Clean Research', 19, 1, 2002, '978-1000000231'),
    ('Practical Research', 20, 1, 2009, '978-1000000232'),
    ('Modern Research', 21, 1, 2016, '978-1000000233'),
    ('Effective Research', 22, 1, 2023, '978-1000000234'),
    ('The Research Handbook', 23, 1, 1990, '978-1000000235'),
    ('Research in Practice', 24, 1, 1997, '978-1000000236'),
    ('Advanced Research', 25, 1, 2004, '978-1000000237'),
    ('Refactoring Research', 26, 1, 2011, '978-1000000238'),
    ('Research Patterns', 27, 1, 2018, '978-1000000239'),
    ('Mastering Research', 28, 1, 1985, '978-1000000240'),
    ('Clean Theory', 29, 1, 1992, '978-1000000241'),
    ('Practical Theory', 30, 1, 1999, '978-1000000242'),
    ('Modern Theory', 31, 1, 2006, '978-1000000243'),
    ('Effective Theory', 32, 1, 2013, '978-1000000244'),
    ('The Theory Handbook', 33, 1, 2020, '978-1000000245'),
    ('Theory in Practice', 34, 1, 1987, '978-1000000246'),
    ('Advanced Theory', 35, 1, 1994, '978-1000000247'),
    ('Refactoring Theory', 36, 1, 2001, '978-1000000248'),
    ('Theory Patterns', 37, 1, 2008, '978-1000000249'),
    ('Mastering Theory', 38, 1, 2015, '978-1000000250'),
    ('Clean Implementation', 39, 1, 2022, '978-1000000251'),
    ('Practical Implementation', 40, 1, 1989, '978-1000000252'),
    ('Modern Implementation', 41, 1, 1996, '978-1000000253'),
    ('Effective Implementation', 42, 1, 2003, '978-1000000254'),
    ('The Implementation Handbook', 43, 1, 2010, '978-1000000255'),
    ('Implementation in Practice', 44, 1, 2017, '978-1000000256'),
    ('Advanced Implementation', 45, 1, 2024, '978-1000000257'),
    ('Refactoring Implementation', 46, 1, 1991, '978-1000000258'),
    ('Implementation Patterns', 47, 1, 1998, '978-1000000259'),
    ('Mastering Implementation', 48, 1, 2005, '978-1000000260'),
    ('Clean Performance', 49, 1, 2012, '978-1000000261'),
    ('Practical Performance', 50, 1, 2019, '978-1000000262'),
    ('Modern Performance', 51, 1, 1986, '978-1000000263'),
    ('Effective Performance', 52, 1, 1993, '978-1000000264'),
    ('The Performance Handbook', 53, 1, 2000, '978-1000000265'),
    ('Performance in Practice', 54, 1, 2007, '978-1000000266'),
    ('Advanced Performance', 55, 1, 2014, '978-1000000267'),
    ('Refactoring Performance', 56, 1, 2021, '978-1000000268'),
    ('Performance Patterns', 57, 1, 1988, '978-1000000269'),
    ('Mastering Performance', 58, 1, 1995, '978-1000000270'),
    ('Clean Reliability', 59, 1, 2002, '978-1000000271'),
    ('Practical Reliability', 60, 1, 2009, '978-1000000272'),
    ('Modern Reliability', 61, 1, 2016, '978-1000000273'),
    ('Effective Reliability', 62, 1, 2023, '978-1000000274'),
    ('The Reliability Handbook', 63, 1, 1990, '978-1000000275'),
    ('Reliability in Practice', 64, 1, 1997, '978-1000000276'),
    ('Advanced Reliability', 65, 1, 2004, '978-1000000277'),
    ('Refactoring Reliability', 66, 1, 2011, '978-1000000278'),
    ('Reliability Patterns', 67, 1, 2018, '978-1000000279'),
    ('Mastering Reliability', 68, 1, 1985, '978-1000000280'),
    ('Clean Security', 69, 1, 1992, '978-1000000281'),
    ('Practical Security', 70, 1, 1999, '978-1000000282'),
    ('Modern Security', 71, 1, 2006, '978-1000000283'),
    ('Effective Security', 72, 1, 2013, '978-1000000284'),
    ('The Security Handbook', 73, 1, 2020, '978-1000000285'),
    ('Security in Practice', 74, 1, 1987, '978-1000000286'),
    ('Advanced Security', 75, 1, 1994, '978-1000000287'),
    ('Refactoring Security', 76, 1, 2001, '978-1000000288'),
    ('Security Patterns', 77, 1, 2008, '978-1000000289'),
    ('Mastering Security', 78, 1, 2015, '978-1000000290'),
    ('Clean Scale', 79, 1, 2022, '978-1000000291'),
    ('Practical Scale', 80, 1, 1989, '978-1000000292'),
    ('Modern Scale', 81, 1, 1996, '978-1000000293'),
    ('Effective Scale', 82, 1, 2003, '978-1000000294'),
    ('The Scale Handbook', 83, 1, 2010, '978-1000000295'),
    ('Scale in Practice', 84, 1, 2017, '978-1000000296'),
    ('Advanced Scale', 85, 1, 2024, '978-1000000297'),
    ('Refactoring Scale', 86, 1, 1991, '978-1000000298'),
    ('Scale Patterns', 87, 1, 1998, '978-1000000299'),
    ('Mastering Scale', 88, 1, 2005, '978-1000000300'),
    ('Clean Pipelines', 89, 1, 2012, '978-1000000301'),
    ('Practical Pipelines', 90, 1, 2019, '978-1000000302'),
    ('Modern Pipelines', 91, 1, 1986, '978-1000000303'),
    ('Effective Pipelines', 92, 1, 1993, '978-1000000304'),
    ('The Pipelines Handbook', 93, 1, 2000, '978-1000000305'),
    ('Pipelines in Practice', 94, 1, 2007, '978-1000000306'),
    ('Advanced Pipelines', 95, 1, 2014, '978-1000000307'),
    ('Refactoring Pipelines', 96, 1, 2021, '978-1000000308'),
    ('Pipelines Patterns', 97, 1, 1988, '978-1000000309'),
    ('Mastering Pipelines', 98, 1, 1995, '978-1000000310'),
    ('Clean Automation', 99, 1, 2002, '978-1000000311'),
    ('Practical Automation', 100, 1, 2009, '978-1000000312'),
    ('Modern Automation', 101, 1, 2016, '978-1000000313'),
    ('Effective Automation', 102, 1, 2023, '978-1000000314'),
    ('The Automation Handbook', 103, 1, 1990, '978-1000000315'),
    ('Automation in Practice', 104, 1, 1997, '978-1000000316'),
    ('Advanced Automation', 105, 1, 2004, '978-1000000317'),
    ('Refactoring Automation', 106, 1, 2011, '978-1000000318'),
    ('Automation Patterns', 1, 1, 2018, '978-1000000319'),
    ('Mastering Automation', 2, 1, 1985, '978-1000000320'),
    ('Clean Insight', 3, 1, 1992, '978-1000000321'),
    ('Practical Insight', 4, 1, 1999, '978-1000000322'),
    ('Modern Insight', 5, 1, 2006, '978-1000000323'),
    ('Effective Insight', 6, 1, 2013, '978-1000000324'),
    ('The Insight Handbook', 7, 1, 2020, '978-1000000325'),
    ('Insight in Practice', 8, 1, 1987, '978-1000000326'),
    ('Advanced Insight', 9, 1, 1994, '978-1000000327'),
    ('Refactoring Insight', 10, 1, 2001, '978-1000000328'),
    ('Insight Patterns', 11, 1, 2008, '978-1000000329'),
    ('Mastering Insight', 12, 1, 2015, '978-1000000330'),
    ('Clean Strategy', 13, 1, 2022, '978-1000000331'),
    ('Practical Strategy', 14, 1, 1989, '978-1000000332'),
    ('Modern Strategy', 15, 1, 1996, '978-1000000333'),
    ('Effective Strategy', 16, 1, 2003, '978-1000000334'),
    ('The Strategy Handbook', 17, 1, 2010, '978-1000000335'),
    ('Strategy in Practice', 18, 1, 2017, '978-1000000336'),
    ('Advanced Strategy', 19, 1, 2024, '978-1000000337'),
    ('Refactoring Strategy', 20, 1, 1991, '978-1000000338'),
    ('Strategy Patterns', 21, 1, 1998, '978-1000000339'),
    ('Mastering Strategy', 22, 1, 2005, '978-1000000340'),
    ('Clean Experiments', 23, 1, 2012, '978-1000000341'),
    ('Practical Experiments', 24, 1, 2019, '978-1000000342'),
    ('Modern Experiments', 25, 1, 1986, '978-1000000343'),
    ('Effective Experiments', 26, 1, 1993, '978-1000000344'),
    ('The Experiments Handbook', 27, 1, 2000, '978-1000000345'),
    ('Experiments in Practice', 28, 1, 2007, '978-1000000346'),
    ('Advanced Experiments', 29, 1, 2014, '978-1000000347'),
    ('Refactoring Experiments', 30, 1, 2021, '978-1000000348'),
    ('Experiments Patterns', 31, 1, 1988, '978-1000000349'),
    ('Mastering Experiments', 32, 1, 1995, '978-1000000350'),
    ('Clean Interpretation', 33, 1, 2002, '978-1000000351'),
    ('Practical Interpretation', 34, 1, 2009, '978-1000000352'),
    ('Modern Interpretation', 35, 1, 2016, '978-1000000353'),
    ('Effective Interpretation', 36, 1, 2023, '978-1000000354'),
    ('The Interpretation Handbook', 37, 1, 1990, '978-1000000355'),
    ('Interpretation in Practice', 38, 1, 1997, '978-1000000356'),
    ('Advanced Interpretation', 39, 1, 2004, '978-1000000357'),
    ('Refactoring Interpretation', 40, 1, 2011, '978-1000000358'),
    ('Interpretation Patterns', 41, 1, 2018, '978-1000000359'),
    ('Mastering Interpretation', 42, 1, 1985, '978-1000000360'),
    ('Clean Forecasting', 43, 1, 1992, '978-1000000361'),
    ('Practical Forecasting', 44, 1, 1999, '978-1000000362'),
    ('Modern Forecasting', 45, 1, 2006, '978-1000000363'),
    ('Effective Forecasting', 46, 1, 2013, '978-1000000364'),
    ('The Forecasting Handbook', 47, 1, 2020, '978-1000000365'),
    ('Forecasting in Practice', 48, 1, 1987, '978-1000000366'),
    ('Advanced Forecasting', 49, 1, 1994, '978-1000000367'),
    ('Refactoring Forecasting', 50, 1, 2001, '978-1000000368'),
    ('Forecasting Patterns', 51, 1, 2008, '978-1000000369'),
    ('Mastering Forecasting', 52, 1, 2015, '978-1000000370'),
    ('Clean Ethics', 53, 1, 2022, '978-1000000371'),
    ('Practical Ethics', 54, 1, 1989, '978-1000000372'),
    ('Modern Ethics', 55, 1, 1996, '978-1000000373'),
    ('Effective Ethics', 56, 1, 2003, '978-1000000374'),
    ('The Ethics Handbook', 57, 1, 2010, '978-1000000375'),
    ('Ethics in Practice', 58, 1, 2017, '978-1000000376'),
    ('Advanced Ethics', 59, 1, 2024, '978-1000000377'),
    ('Refactoring Ethics', 60, 1, 1991, '978-1000000378'),
    ('Ethics Patterns', 61, 1, 1998, '978-1000000379'),
    ('Mastering Ethics', 62, 1, 2005, '978-1000000380'),
    ('Clean Networks', 63, 1, 2012, '978-1000000381'),
    ('Practical Networks', 64, 1, 2019, '978-1000000382'),
    ('Modern Networks', 65, 1, 1986, '978-1000000383'),
    ('Effective Networks', 66, 1, 1993, '978-1000000384'),
    ('The Networks Handbook', 67, 1, 2000, '978-1000000385'),
    ('Networks in Practice', 68, 1, 2007, '978-1000000386'),
    ('Advanced Networks', 69, 1, 2014, '978-1000000387'),
    ('Refactoring Networks', 70, 1, 2021, '978-1000000388'),
    ('Networks Patterns', 71, 1, 1988, '978-1000000389'),
    ('Mastering Networks', 72, 1, 1995, '978-1000000390'),
    ('Clean Interfaces', 73, 1, 2002, '978-1000000391'),
    ('Practical Interfaces', 74, 1, 2009, '978-1000000392'),
    ('Modern Interfaces', 75, 1, 2016, '978-1000000393'),
    ('Effective Interfaces', 76, 1, 2023, '978-1000000394'),
    ('The Interfaces Handbook', 77, 1, 1990, '978-1000000395'),
    ('Interfaces in Practice', 78, 1, 1997, '978-1000000396'),
    ('Advanced Interfaces', 79, 1, 2004, '978-1000000397'),
    ('Refactoring Interfaces', 80, 1, 2011, '978-1000000398'),
    ('Interfaces Patterns', 81, 1, 2018, '978-1000000399'),
    ('Mastering Interfaces', 82, 1, 1985, '978-1000000400'),
    ('Clean Abstractions', 83, 1, 1992, '978-1000000401'),
    ('Practical Abstractions', 84, 1, 1999, '978-1000000402'),
    ('Modern Abstractions', 85, 1, 2006, '978-1000000403'),
    ('Effective Abstractions', 86, 1, 2013, '978-1000000404'),
    ('The Abstractions Handbook', 87, 1, 2020, '978-1000000405'),
    ('Abstractions in Practice', 88, 1, 1987, '978-1000000406'),
    ('Advanced Abstractions', 89, 1, 1994, '978-1000000407'),
    ('Refactoring Abstractions', 90, 1, 2001, '978-1000000408'),
    ('Abstractions Patterns', 91, 1, 2008, '978-1000000409'),
    ('Mastering Abstractions', 92, 1, 2015, '978-1000000410'),
    ('Clean Optimization', 93, 1, 2022, '978-1000000411'),
    ('Practical Optimization', 94, 1, 1989, '978-1000000412'),
    ('Modern Optimization', 95, 1, 1996, '978-1000000413'),
    ('Effective Optimization', 96, 1, 2003, '978-1000000414'),
    ('The Optimization Handbook', 97, 1, 2010, '978-1000000415'),
    ('Optimization in Practice', 98, 1, 2017, '978-1000000416'),
    ('Advanced Optimization', 99, 1, 2024, '978-1000000417'),
    ('Refactoring Optimization', 100, 1, 1991, '978-1000000418'),
    ('Optimization Patterns', 101, 1, 1998, '978-1000000419'),
    ('Mastering Optimization', 102, 1, 2005, '978-1000000420'),
    ('Clean Planning', 103, 1, 2012, '978-1000000421'),
    ('Practical Planning', 104, 1, 2019, '978-1000000422'),
    ('Modern Planning', 105, 1, 1986, '978-1000000423'),
    ('Effective Planning', 106, 1, 1993, '978-1000000424'),
    ('The Planning Handbook', 1, 1, 2000, '978-1000000425'),
    ('Planning in Practice', 2, 1, 2007, '978-1000000426'),
    ('Advanced Planning', 3, 1, 2014, '978-1000000427'),
    ('Refactoring Planning', 4, 1, 2021, '978-1000000428'),
    ('Planning Patterns', 5, 1, 1988, '978-1000000429'),
    ('Mastering Planning', 6, 1, 1995, '978-1000000430'),
    ('Clean Evidence', 7, 1, 2002, '978-1000000431'),
    ('Practical Evidence', 8, 1, 2009, '978-1000000432'),
    ('Modern Evidence', 9, 1, 2016, '978-1000000433'),
    ('Effective Evidence', 10, 1, 2023, '978-1000000434'),
    ('The Evidence Handbook', 11, 1, 1990, '978-1000000435'),
    ('Evidence in Practice', 12, 1, 1997, '978-1000000436'),
    ('Advanced Evidence', 13, 1, 2004, '978-1000000437'),
    ('Refactoring Evidence', 14, 1, 2011, '978-1000000438'),
    ('Evidence Patterns', 15, 1, 2018, '978-1000000439'),
    ('Mastering Evidence', 16, 1, 1985, '978-1000000440'),
    ('Clean Communication', 17, 1, 1992, '978-1000000441'),
    ('Practical Communication', 18, 1, 1999, '978-1000000442'),
    ('Modern Communication', 19, 1, 2006, '978-1000000443'),
    ('Effective Communication', 20, 1, 2013, '978-1000000444'),
    ('The Communication Handbook', 21, 1, 2020, '978-1000000445'),
    ('Communication in Practice', 22, 1, 1987, '978-1000000446'),
    ('Advanced Communication', 23, 1, 1994, '978-1000000447'),
    ('Refactoring Communication', 24, 1, 2001, '978-1000000448'),
    ('Communication Patterns', 25, 1, 2008, '978-1000000449'),
    ('Mastering Communication', 26, 1, 2015, '978-1000000450'),
    ('Clean Governance', 27, 1, 2022, '978-1000000451'),
    ('Practical Governance', 28, 1, 1989, '978-1000000452'),
    ('Modern Governance', 29, 1, 1996, '978-1000000453'),
    ('Effective Governance', 30, 1, 2003, '978-1000000454'),
    ('The Governance Handbook', 31, 1, 2010, '978-1000000455'),
    ('Governance in Practice', 32, 1, 2017, '978-1000000456'),
    ('Advanced Governance', 33, 1, 2024, '978-1000000457'),
    ('Refactoring Governance', 34, 1, 1991, '978-1000000458'),
    ('Governance Patterns', 35, 1, 1998, '978-1000000459'),
    ('Mastering Governance', 36, 1, 2005, '978-1000000460'),
    ('Clean Structure', 37, 1, 2012, '978-1000000461'),
    ('Practical Structure', 38, 1, 2019, '978-1000000462'),
    ('Modern Structure', 39, 1, 1986, '978-1000000463'),
    ('Effective Structure', 40, 1, 1993, '978-1000000464'),
    ('The Structure Handbook', 41, 1, 2000, '978-1000000465'),
    ('Structure in Practice', 42, 1, 2007, '978-1000000466'),
    ('Advanced Structure', 43, 1, 2014, '978-1000000467'),
    ('Refactoring Structure', 44, 1, 2021, '978-1000000468'),
    ('Structure Patterns', 45, 1, 1988, '978-1000000469'),
    ('Mastering Structure', 46, 1, 1995, '978-1000000470'),
    ('Clean Quality', 47, 1, 2002, '978-1000000471'),
    ('Practical Quality', 48, 1, 2009, '978-1000000472'),
    ('Modern Quality', 49, 1, 2016, '978-1000000473'),
    ('Effective Quality', 50, 1, 2023, '978-1000000474'),
    ('The Quality Handbook', 51, 1, 1990, '978-1000000475'),
    ('Quality in Practice', 52, 1, 1997, '978-1000000476'),
    ('Advanced Quality', 53, 1, 2004, '978-1000000477'),
    ('Refactoring Quality', 54, 1, 2011, '978-1000000478'),
    ('Quality Patterns', 55, 1, 2018, '978-1000000479'),
    ('Mastering Quality', 56, 1, 1985, '978-1000000480'),
    ('Clean Debugging', 57, 1, 1992, '978-1000000481'),
    ('Practical Debugging', 58, 1, 1999, '978-1000000482'),
    ('Modern Debugging', 59, 1, 2006, '978-1000000483'),
    ('Effective Debugging', 60, 1, 2013, '978-1000000484'),
    ('The Debugging Handbook', 61, 1, 2020, '978-1000000485'),
    ('Debugging in Practice', 62, 1, 1987, '978-1000000486'),
    ('Advanced Debugging', 63, 1, 1994, '978-1000000487'),
    ('Refactoring Debugging', 64, 1, 2001, '978-1000000488'),
    ('Debugging Patterns', 65, 1, 2008, '978-1000000489'),
    ('Mastering Debugging', 66, 1, 2015, '978-1000000490'),
    ('Clean Engineering', 67, 1, 2022, '978-1000000491'),
    ('Practical Engineering', 68, 1, 1989, '978-1000000492'),
    ('Modern Engineering', 69, 1, 1996, '978-1000000493'),
    ('Effective Engineering', 70, 1, 2003, '978-1000000494'),
    ('The Engineering Handbook', 71, 1, 2010, '978-1000000495'),
    ('Engineering in Practice', 72, 1, 2017, '978-1000000496'),
    ('Advanced Engineering', 73, 1, 2024, '978-1000000497'),
    ('Refactoring Engineering', 74, 1, 1991, '978-1000000498'),
    ('Engineering Patterns', 75, 1, 1998, '978-1000000499'),
    ('Mastering Engineering', 76, 1, 2005, '978-1000000500');

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
