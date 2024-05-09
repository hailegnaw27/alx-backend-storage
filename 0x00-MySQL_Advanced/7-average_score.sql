-- Script to create a stored procedure ComputeAverageScoreForUser
-- The procedure computes and stores the average score for a student

DELIMITER //

CREATE PROCEDURE ComputeAverageScoreForUser(
    IN user_id INT
)
BEGIN
    -- Declare a variable to hold the calculated average score
    DECLARE average_score FLOAT;

    -- Calculate the average score for the user
    SELECT AVG(score)
    INTO average_score
    FROM corrections
    WHERE user_id = user_id;

    -- Update the average_score for the user in the users table
    UPDATE users
    SET average_score = average_score
    WHERE id = user_id;
END;
//

DELIMITER ;

