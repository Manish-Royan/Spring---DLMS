-- Create Roles Table
CREATE TABLE Roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

-- Insert Predefined Roles
INSERT INTO Roles (role_name) VALUES 
('ADMIN'), 
('LIBRARIAN'), 
('STUDENT'), 
('RESEARCHER');

-- Modified Users Table with Role
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_id INT,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

-- Login Procedure
DELIMITER //
CREATE PROCEDURE UserLogin(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255)
)
BEGIN
    SELECT 
        u.user_id, 
        u.username, 
        u.email, 
        r.role_name,
        u.status
    FROM 
        Users u
    JOIN 
        Roles r ON u.role_id = r.role_id
    WHERE 
        u.username = p_username 
        AND u.password = SHA2(p_password, 256)
        AND u.status = 'ACTIVE';
END //
DELIMITER ;

-- Create User with Role
DELIMITER //
CREATE PROCEDURE CreateUser(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_role VARCHAR(50)
)
BEGIN
    INSERT INTO Users (
        username, 
        email, 
        password, 
        role_id
    ) VALUES (
        p_username, 
        p_email, 
        SHA2(p_password, 256),
        (SELECT role_id FROM Roles WHERE role_name = p_role)
    );
END //
DELIMITER ;

-- Example Usage
-- Call UserLogin
CALL UserLogin('manish_admin', 'secure_password');

-- Call CreateUser
CALL CreateUser('john_student', 'john@example.com', 'student_pass', 'STUDENT');