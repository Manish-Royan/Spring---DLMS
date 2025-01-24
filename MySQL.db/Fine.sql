-- Calculate Fine for Overdue Books
CREATE PROCEDURE CalculateFine()
BEGIN
    INSERT INTO Fines (loan_id, amount, fine_date, status)
    SELECT 
        loan_id, 
        DATEDIFF(CURRENT_DATE, due_date) * 10.00 AS fine_amount,
        CURRENT_DATE,
        'PENDING'
    FROM Loans
    WHERE status = 'OVERDUE' 
    AND return_date IS NULL;
END;

-- Query to Mark Loans as Overdue
UPDATE Loans 
SET status = 'OVERDUE'
WHERE due_date < CURRENT_DATE AND return_date IS NULL;

-- Get Unpaid Fines for a Specific User
SELECT 
    u.full_name, 
    b.title, 
    f.amount, 
    f.fine_date
FROM Fines f
JOIN Loans l ON f.loan_id = l.loan_id
JOIN Users u ON l.user_id = u.user_id
JOIN Books b ON l.book_id = b.book_id
WHERE u.user_id = ? AND f.status = 'PENDING';

-- Pay Fine
UPDATE Fines 
SET status = 'PAID'
WHERE fine_id = ?;

-- Total Fine Amount for User
SELECT 
    SUM(amount) AS total_fine_amount
FROM Fines f
JOIN Loans l ON f.loan_id = l.loan_id
WHERE l.user_id = ? AND f.status = 'PENDING';