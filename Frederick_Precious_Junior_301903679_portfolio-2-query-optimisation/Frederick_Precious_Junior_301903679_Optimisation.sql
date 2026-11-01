-- A separate performance table using the case's score.match_id type.
-- Only this field and a lab row ID are copied. Business constraints stay in Portfolio 1.
-- Generated values are for measuring a selective lookup, not complete case records.
CREATE SCHEMA query_lab;
CREATE TABLE query_lab."score" AS
SELECT "match_id", 0::bigint AS "lab_row_id" FROM portfolio."score" WITH NO DATA;
INSERT INTO query_lab."score" ("match_id", "lab_row_id")
SELECT (g % 1000)::bigint, g FROM generate_series(1, 50000) AS g;
ANALYZE query_lab."score";

-- Before: warm the lookup, then measure it three times.
SELECT "lab_row_id", "match_id"
FROM query_lab."score"
WHERE "match_id" = (42 % 1000)::bigint
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "match_id"
FROM query_lab."score"
WHERE "match_id" = (42 % 1000)::bigint
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "match_id"
FROM query_lab."score"
WHERE "match_id" = (42 % 1000)::bigint
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "match_id"
FROM query_lab."score"
WHERE "match_id" = (42 % 1000)::bigint
ORDER BY "lab_row_id";

CREATE INDEX p2_filter_idx ON query_lab."score" USING btree ("match_id");

-- After: run the same lookup and repeat the measurements.
SELECT "lab_row_id", "match_id"
FROM query_lab."score"
WHERE "match_id" = (42 % 1000)::bigint
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "match_id"
FROM query_lab."score"
WHERE "match_id" = (42 % 1000)::bigint
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "match_id"
FROM query_lab."score"
WHERE "match_id" = (42 % 1000)::bigint
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "match_id"
FROM query_lab."score"
WHERE "match_id" = (42 % 1000)::bigint
ORDER BY "lab_row_id";
