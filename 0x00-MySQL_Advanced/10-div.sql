-- Script to create the SafeDiv function
-- The function divides the first argument a by the second argument b and returns 0 if b is equal to 0

DELIMITER //

CREATE FUNCTION SafeDiv(a INT, b INT)
RETURNS FLOAT
BEGIN
    -- Declare the variable for the result
    DECLARE result FLOAT;

    -- Check if b is zero
    IF b = 0 THEN
        -- Return 0 if b is zero
        SET result = 0;
    ELSE
        -- Otherwise, return a divided by b
        SET result = a / b;
    END IF;

    -- Return the calculated result
    RETURN result;
END;
//

DELIMITER ;

