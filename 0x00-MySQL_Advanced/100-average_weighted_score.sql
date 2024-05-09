-- Script to create a stored procedure ComputeAverageWeightedScoreForUser
-- The procedure computes and stores the average weighted score for a student

DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUser(
    IN user_id INT
)
BEGIN
    -- Declare variables for total weighted score and total weight
    DECLARE total_weighted_score FLOAT;
    DECLARE total_weight FLOAT;

    -- Calculate the total weighted score for the user
    SELECT SUM(corrections.score * projects.weight)
    INTO total_weighted_score
    FROM corrections
    JOIN projects ON corrections.project_id = projects.id
    WHERE corrections.user_id = user_id;

    -- Calculate the total weight for the user
    SELECT SUM(projects.weight)
    INTO total_weight
    FROM corrections
    JOIN projects ON corrections.project_id = projects.id
    WHERE corrections.user_id = user_id;

    -- Calculate the average weighted score
    DECLARE average_weighted_score FLOAT;
    IF total_weight <> 0 THEN
        SET average_weighted_score = total_weighted_score / total_weight;
    ELSE
        SET average_weighted_score = 0;
    END IF;

    -- Update the user's average_score with the calculated average weighted score
    UPDATE users
    SET average_score = average_weighted_score
    WHERE id = user_id;
END;
//

DELIMITER ;

