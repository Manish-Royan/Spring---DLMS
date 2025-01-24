-- Check Book Availability
SELECT available_copies 
FROM Books 
WHERE book_id = [book_id];

-- Create Book Reservation
INSERT INTO Reservations 
(user_id, book_id, reservation_date, status) 
VALUES 
([user_id], [book_id], CURRENT_TIMESTAMP, 'PENDING');

-- Update Book Availability After Reservation
UPDATE Books 
SET available_copies = available_copies - 1 
WHERE book_id = [book_id] AND available_copies > 0;

-- Cancel Reservation
UPDATE Reservations 
SET status = 'CANCELLED' 
WHERE reservation_id = [reservation_id];

-- Get User's Active Reservations
SELECT r.reservation_id, b.title, r.reservation_date, r.status
FROM Reservations r
JOIN Books b ON r.book_id = b.book_id
WHERE r.user_id = [user_id] AND r.status = 'PENDING';

-- Approve Reservation
UPDATE Reservations 
SET status = 'APPROVED' 
WHERE reservation_id = [reservation_id];

-- Check Existing Reservations for a Book
SELECT COUNT(*) as reservation_count
FROM Reservations 
WHERE book_id = [book_id] AND status = 'PENDING';