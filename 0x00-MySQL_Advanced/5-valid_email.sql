-- Script to create a trigger that resets the attribute valid_email only when the email has been changed
-- Trigger should activate before an UPDATE operation on the users table

DELIMITER //

CREATE TRIGGER reset_valid_email
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    -- Check if the email has changed
    IF NEW.email <> OLD.email THEN
        -- Reset valid_email to 0
        SET NEW.valid_email = 0;
    END IF;
END;
//

DELIMITER ;

