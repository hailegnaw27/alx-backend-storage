-- Script to create a composite index named idx_name_first_score on the names table
-- The index will be created on the first letter of the name column and the score column

CREATE INDEX idx_name_first_score
ON names (name(1), score);

