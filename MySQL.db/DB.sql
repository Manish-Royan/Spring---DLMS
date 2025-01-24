-- Create Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    user_type ENUM('ADMIN', 'LIBRARIAN', 'STUDENT', 'RESEARCHER') NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Books Table
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publisher VARCHAR(100),
    publication_year INT,
    category VARCHAR(50),
    total_copies INT NOT NULL,
    available_copies INT NOT NULL,
    language VARCHAR(50)
);

-- Create Loan Table
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    book_id INT,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('ACTIVE', 'RETURNED', 'OVERDUE') DEFAULT 'ACTIVE',
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- Create Reservation Table
CREATE TABLE Reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    book_id INT,
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('PENDING', 'APPROVED', 'CANCELLED') DEFAULT 'PENDING',
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- Create Fine Table
CREATE TABLE Fines (
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT,
    amount DECIMAL(10,2) NOT NULL,
    fine_date DATE NOT NULL,
    status ENUM('PENDING', 'PAID') DEFAULT 'PENDING',
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);

-- Sample Insert Queries
-- Insert User
INSERT INTO Users (username, email, password, full_name, user_type) VALUES 
('manish_b', 'manish@example.com', 'hashed_password', 'Manish Bishwakarma', 'STUDENT');

-- Insert Book
INSERT INTO Books (title, author, isbn, publisher, publication_year, category, total_copies, available_copies, language) VALUES 
('Clean Code', 'Robert C. Martin', '978-0132350884', 'Pearson', 2008, 'Computer Science', 5, 5, 'English');

-- Sample Select Queries
-- Get All Available Books
SELECT * FROM Books WHERE available_copies > 0;

-- Get User Loan History
SELECT b.title, l.loan_date, l.due_date, l.return_date 
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
WHERE l.user_id = 1;

-- Get Overdue Loans
SELECT u.full_name, b.title, l.due_date
FROM Loans l
JOIN Users u ON l.user_id = u.user_id
JOIN Books b ON l.book_id = b.book_id
WHERE l.status = 'OVERDUE';

-- Sample Update Queries
-- Update Book Availability
UPDATE Books 
SET available_copies = available_copies - 1 
WHERE book_id = 1;

-- Mark Loan as Returned
UPDATE Loans 
SET return_date = CURRENT_DATE, status = 'RETURNED' 
WHERE loan_id = 1;

-- Sample Delete Query
-- Cancel Reservation
DELETE FROM Reservations 
WHERE reservation_id = 1;