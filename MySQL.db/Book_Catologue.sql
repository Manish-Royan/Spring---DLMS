-- Comprehensive Book Catalogue Query
SELECT 
    b.book_id,
    b.title,
    b.author,
    b.isbn,
    b.publisher,
    b.publication_year,
    b.category,
    b.total_copies,
    b.available_copies,
    b.language,
    COUNT(l.book_id) AS total_loans,
    COUNT(r.book_id) AS total_reservations
FROM 
    Books b
LEFT JOIN 
    Loans l ON b.book_id = l.book_id AND l.status = 'ACTIVE'
LEFT JOIN 
    Reservations r ON b.book_id = r.book_id AND r.status = 'PENDING'
GROUP BY 
    b.book_id, b.title, b.author, b.isbn, b.publisher, 
    b.publication_year, b.category, b.total_copies, 
    b.available_copies, b.language
ORDER BY 
    b.title;

-- Advanced Search Query
SELECT * FROM Books
WHERE 
    (title LIKE '%keyword%' OR 
     author LIKE '%keyword%' OR 
     category LIKE '%keyword%')
    AND available_copies > 0
ORDER BY 
    publication_year DESC;

-- Book Category Analysis
SELECT 
    category, 
    COUNT(*) AS total_books,
    SUM(total_copies) AS total_copies,
    SUM(available_copies) AS available_copies
FROM 
    Books
GROUP BY 
    category
ORDER BY 
    total_books DESC;

-- Most Popular Books
SELECT 
    b.title, 
    b.author, 
    COUNT(l.loan_id) AS loan_count
FROM 
    Books b
JOIN 
    Loans l ON b.book_id = l.book_id
GROUP BY 
    b.book_id, b.title, b.author
ORDER BY 
    loan_count DESC
LIMIT 10;