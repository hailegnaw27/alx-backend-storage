-- Script to rank country origins of bands, ordered by the number of (non-unique) fans
-- Import data from the metal_bands.sql dump into the database before running this script
-- The result will have two columns: origin and nb_fans

-- Group the bands by origin and sum the number of fans
-- Order the results by total number of fans in descending order

SELECT origin, SUM(fans) AS nb_fans
FROM metal_bands
GROUP BY origin
ORDER BY nb_fans DESC;

