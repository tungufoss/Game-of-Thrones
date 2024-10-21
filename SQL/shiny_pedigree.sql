CREATE OR REPLACE VIEW shiny.pedigree AS
SELECT id,
       name                                            AS label,
       CASE
           WHEN gender = 'Male' THEN 1
           WHEN gender = 'Female' THEN 2
           ELSE 1 -- Default to Male if gender is unknown, cannot be NULL
           END                                         AS sex,
       CASE
           WHEN father IS NULL OR mother IS NULL THEN 0 -- If either parent is missing, set both to 0
           ELSE father
           END                                         AS dad_id,
       CASE
           WHEN father IS NULL OR mother IS NULL THEN 0 -- If either parent is missing, set both to 0
           ELSE mother
           END                                         AS mom_id,
       CASE WHEN spouse IS NULL THEN 0 ELSE spouse END AS spouse_id,
       dynasty_id                                      AS fam_id
FROM got.characters
         INNER JOIN got.character_dynasties ON got.characters.id = got.character_dynasties.character_id;

