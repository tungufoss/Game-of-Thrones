CREATE OR REPLACE VIEW shiny.pedigree AS
SELECT
    id,
    name AS label,
    gender,
    CASE
        WHEN father IS NULL OR mother IS NULL THEN 0  -- If either parent is missing, set both to 0
        ELSE father
    END AS dadid,
    CASE
        WHEN father IS NULL OR mother IS NULL THEN 0  -- If either parent is missing, set both to 0
        ELSE mother
    END AS momid,
    CASE
        WHEN gender = 'Male' THEN 1
        WHEN gender = 'Female' THEN 2
        ELSE 1  -- Default to Male if gender is unknown
    END AS sex,
    1 AS famid  -- You can update this if you have multiple families
FROM
    got.characters;