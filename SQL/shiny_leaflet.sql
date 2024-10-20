CREATE OR REPLACE VIEW shiny.houses AS
WITH cadet_branches_names AS (SELECT h.id               AS house_id,
                                     array_agg(cb.name) AS cadet_branch_names
                              FROM got.houses h
                                       LEFT JOIN unnest(h.cadet_branches) AS cb_id
                                                 ON TRUE -- Unnest cadet_branches array
                                       LEFT JOIN got.houses cb ON cb.id = cb_id -- JOIN to got.houses to get cadet branch names
                              GROUP BY h.id)

SELECT houses.id                                   AS id,
       houses.name                                 AS house_name,
       coalesce(houses.region, 'Outside Westeros') AS kingdom_name,
       ST_AsText(loc.geog)                         AS geom_wkt,
       concat('<h3>', houses.name, '</h3>',
              '<p><b>Region:</b> ', houses.region, '</p>',
              coalesce('<p><b>Motto:</b> ' || words || '</p>', ''),
              coalesce('<p><b>Current Lord:</b> ' || current_lord.name || '</p>', ''),
              coalesce('<p><b>Heir:</b> ' || heir.name || '</p>', ''),
              coalesce('<p><b>Founded:</b> ' || founded || '</p>', ''),
              coalesce('<p><b>Died Out:</b> ' || died_out || '</p>', ''),
              coalesce('<p><b>Ancestral Weapons:</b> ' || array_to_string(ancestral_weapons, ', '), ''),
              coalesce('<p><b>Seats:</b> ' || array_to_string(seats, ', '), ''),
              coalesce('<p><b>Titles:</b> ' || array_to_string(houses.titles, ', '), ''),
              coalesce('<p><b>Coat of Arms:</b> ' || coat_of_arms, ''),
              coalesce('<p><b>Sworn members:</b> ' || array_length(sworn_members, 1), ''),
              CASE
                  WHEN houses.cadet_branches IS NOT NULL THEN
                      coalesce('<p><b>Cadet Branches:</b> ' ||
                               array_to_string(cbn.cadet_branch_names, ', '), '')
                  END
           )                                       AS house_info,
       concat('https://awoiaf.westeros.org/images/',
              coalesce(image, '5/58/None.svg'))    AS coat_of_arms_url
FROM got.houses
         INNER JOIN lausn.tables_mapping map ON map.house_id = houses.id
         INNER JOIN atlas.locations loc ON map.location_id = loc.gid
         LEFT JOIN got.characters current_lord ON current_lord.id = houses.current_lord
         LEFT JOIN got.characters heir ON heir.id = houses.heir
         LEFT JOIN cadet_branches_names cbn ON cbn.house_id = houses.id;


CREATE OR REPLACE VIEW shiny.kingdoms AS
with kingdom_type_cnt AS (select kingdoms.gid                     AS kingdom_id,
                                 type,
                                 count(*)                         AS cnt,
                                 string_agg(locations.name, ', ') AS names
                          FROM atlas.locations
                                   inner JOIN atlas.kingdoms on st_intersects(locations.geog, kingdoms.geog)
                          group by 1, 2),
     kingdom_cnt AS (SELECT kingdom_id,
                            string_agg(concat('<b>', type, ':</b> ', names, ' (#', cnt, ')'),
                                       '<br>') AS location_summary
                     FROM kingdom_type_cnt
                     GROUP BY kingdom_id)
SELECT gid             AS id,
       name            AS kingdom_name,
       ST_AsText(geog) AS geom_wkt,
       color,
       concat('<h3>', name, '</h3>',
              '<p><b>Claimed by:</b> ', claimedby,
              '<br><b>Size:</b> ', (st_area(geog) / 1e6):: INT, ' km²</p>',
              '<h4>Summary</h4><p>', summary, '</p>'
                  '<h4>Locations</h4><p>', location_summary, '</p>'
           )           AS kingdom_info
FROM atlas.kingdoms
         INNER JOIN kingdom_cnt ON kingdom_cnt.kingdom_id = gid;


CREATE OR REPLACE VIEW shiny.locations AS
SELECT locations.gid                                    AS id,
       type                                             AS location_type,
       locations.name                                   AS location_name,
       coalesce(kingdoms.name, 'Outside Westeros')      AS kingdom_name,
       ST_AsText(locations.geog)                        AS geom_wkt,
       concat('<h3>', locations.name, '</h3><h4>', type, '</h4><p>', locations.summary,
              '<br><a href="', locations.url,
              '" target="_blank">Read More...</a></p>') AS location_info,
       concat('https://cdn.patricktriest.com/atlas-of-thrones/icons/', lower(type::TEXT),
              '.svg')                                   AS icon_url
FROM atlas.locations
         LEFT JOIN atlas.kingdoms ON st_intersects(locations.geog, kingdoms.geog);
