-- Create Users Table with Authentication Fields
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    salt VARCHAR(50) NOT NULL,
    last_login TIMESTAMP,
    login_attempts INT DEFAULT 0,
    account_locked BOOLEAN DEFAULT FALSE,
    account_locked_time TIMESTAMP
);

-- User Login Authentication Query
SELECT user_id, username, password, salt, 
       account_locked, login_attempts
FROM Users 
WHERE email = ? OR username = ?;

-- Update Login Attempts
UPDATE Users 
SET login_attempts = login_attempts + 1,
    account_locked = CASE 
        WHEN login_attempts >= 5 THEN TRUE 
        ELSE FALSE 
    END,
    account_locked_time = CASE 
        WHEN login_attempts >= 5 THEN CURRENT_TIMESTAMP 
        ELSE NULL 
    END
WHERE user_id = ?;

-- Reset Login Attempts
UPDATE Users 
SET login_attempts = 0, 
    account_locked = FALSE, 
    account_locked_time = NULL
WHERE user_id = ?;

-- Update Last Login
UPDATE Users 
SET last_login = CURRENT_TIMESTAMP 
WHERE user_id = ?;

-- Password Change Query
UPDATE Users 
SET password = ?, 
    salt = ? 
WHERE user_id = ?;