-- Show related score, player, match records (up to 20).
SELECT t0."score_id" AS "score_score_id",
       t0."points" AS "score_points",
       t2."player_id" AS "player_player_id",
       t2."handle" AS "player_handle",
       t1."match_id" AS "match_match_id",
       t1."starts_at" AS "match_starts_at"
FROM portfolio."score" t0
JOIN portfolio."match" t1 ON t0."match_id" = t1."match_id"
JOIN portfolio."player" t2 ON t0."player_id" = t2."player_id"
ORDER BY t0."score_id", t2."player_id", t1."match_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."score_id" AS "score_score_id",
       t0."points" AS "score_points",
       t2."player_id" AS "player_player_id",
       t2."handle" AS "player_handle",
       t1."match_id" AS "match_match_id",
       t1."starts_at" AS "match_starts_at"
FROM portfolio."score" t0
JOIN portfolio."match" t1 ON t0."match_id" = t1."match_id"
JOIN portfolio."player" t2 ON t0."player_id" = t2."player_id"
ORDER BY t0."score_id", t2."player_id", t1."match_id"
LIMIT 20;

-- Find game records where title matches "Nebula Circuit" (up to 20).
SELECT * FROM portfolio."game"
WHERE "title" IS NOT DISTINCT FROM 'Nebula Circuit'
ORDER BY "game_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."game"
WHERE "title" IS NOT DISTINCT FROM 'Nebula Circuit'
ORDER BY "game_id"
LIMIT 20;



-- Match leaderboard: rank players by score in one selected match.
SELECT m."match_id", p."player_id", p."handle", s."points",
       RANK() OVER (PARTITION BY s."match_id" ORDER BY s."points" DESC) AS player_rank
FROM portfolio."score" AS s
JOIN portfolio."player" AS p ON p."player_id" = s."player_id"
JOIN portfolio."match" AS m ON m."match_id" = s."match_id"
WHERE m."match_id" = 3001
ORDER BY player_rank, p."handle";

-- Game-wide totals and ranking across completed matches.
SELECT g."game_id", g."title" AS game_title, p."player_id", p."handle",
       SUM(s."points") AS total_points,
       RANK() OVER (PARTITION BY g."game_id" ORDER BY SUM(s."points") DESC) AS leaderboard_rank
FROM portfolio."score" AS s
JOIN portfolio."player" AS p ON p."player_id" = s."player_id"
JOIN portfolio."match" AS m ON m."match_id" = s."match_id"
JOIN portfolio."game" AS g ON g."game_id" = m."game_id"
WHERE m."status" = 'completed'
GROUP BY g."game_id", g."title", p."player_id", p."handle"
ORDER BY g."title", leaderboard_rank, p."handle";

-- Count score records for each match_id (up to 20 groups).
SELECT "match_id", count(*) AS record_count
FROM portfolio."score"
GROUP BY "match_id"
ORDER BY record_count DESC, "match_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "match_id", count(*) AS record_count
FROM portfolio."score"
GROUP BY "match_id"
ORDER BY record_count DESC, "match_id" NULLS LAST
LIMIT 20;
