UPDATE atlas.kingdoms
SET color = CASE
                WHEN name = 'The North' THEN '#5F9EA0'
                WHEN name = 'The Vale' THEN '#87CEEB'
                WHEN name = 'The Westerlands' THEN '#FFD700'
                WHEN name = 'Gift' THEN '#228B22'
                WHEN name = 'The Riverlands' THEN '#4169E1'
                WHEN name = 'Dorne' THEN '#FFA500'
                WHEN name = 'The Reach' THEN '#32CD32'
                WHEN name = 'The Stormlands' THEN '#000000'
                WHEN name = 'Iron Islands' THEN '#2F4F4F'
                WHEN name = 'The Crownsland' THEN '#8B0000'
                ELSE NULL -- If a kingdom doesn't match, leave the color as NULL
    END
where 1 = 1;
