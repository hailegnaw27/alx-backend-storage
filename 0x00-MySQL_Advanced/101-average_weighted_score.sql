-- Script to create a stored procedure ComputeAverageWeightedScoreForUsers
-- The procedure computes and stores the average weighted score for all students

DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    -- Declare variables
    DECLARE done INT DEFAULT 0;
    DECLARE user_id INT;
    DECLARE total_weighted_score FLOAT;
    DECLARE total_weight FLOAT;
    DECLARE average_weighted_score FLOAT;

    -- Declare a cursor to iterate over each user
    DECLARE user_cursor CURSOR FOR
    SELECT id FROM users;

    -- Declare a handler to handle end of data for the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET done = 1;

    -- Open the cursor
    OPEN user_cursor;

    -- Iterate over each user
    WHILE NOT done DO
        -- Fetch the current user's ID from the cursor
        FETCH user_cursor INTO user_id;

        -- Calculate total weighted score and total weight for the current user
        SELECT SUM(corrections.score * projects.weight)
        INTO total_weighted_score
        FROM corrections
        JOIN projects ON corrections.project_id = projects.id
        WHERE corrections.user_id = user_id;

        SELECT SUM(projects.weight)
        INTO total_weight
        FROM corrections
        JOIN projects ON corrections.project_id = projects.id
        WHERE corrections.user_id = user_id;

        -- Calculate the average weighted score
        IF total_weight <> 0 THEN
            SET average_weighted_score = total_weighted_score / total_weight;
        ELSE
            SET average_weighted_score = 0;
        END IF;

        -- Update the user's average_score in the users table
        UPDATE users
        SET average_score = average_weighted_score
        WHERE id = user_id;
    END WHILE;

    -- Close the cursor
    CLOSE user_cursor;
END;
//

DELIMITER ;

