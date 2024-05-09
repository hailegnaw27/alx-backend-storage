-- Script to create an index named idx_name_first on the table names
-- The index will be created on the first letter of the name column

CREATE INDEX idx_name_first
ON names (name(1));

