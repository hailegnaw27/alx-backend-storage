-- Script to list all bands with Glam rock as their main style, ranked by their longevity
-- Import data from the metal_bands.sql dump into the database before running this script
-- The result will have two columns: band_name and lifespan (in years until 2022)

-- Select bands with Glam rock as their main style
-- Compute lifespan as the difference between 2022 and the formed year,
-- or between split and formed if the band has split,
-- and rank bands by longevity in descending order

SELECT band_name,
    CASE
        WHEN split IS NULL THEN 2022 - formed
        ELSE split - formed
    END AS lifespan
FROM metal_bands
WHERE main_style = 'Glam rock'
ORDER BY lifespan DESC, band_name;

