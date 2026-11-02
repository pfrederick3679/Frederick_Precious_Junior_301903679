-- Portfolio 3 commit/rollback exercise for pgAdmin Query Tool.
-- Run the sections separately as described in Frederick_Precious_Junior_301903679_README.md.

-- SECTION A: select and run these statements together for the successful COMMIT.
BEGIN ISOLATION LEVEL READ COMMITTED;

UPDATE portfolio.score
SET p3_processed_count = p3_processed_count + 1
WHERE score_id = 4001
RETURNING score_id, p3_processed_count;

COMMIT;

SELECT score_id, p3_processed_count
FROM portfolio.score
WHERE score_id = 4001;

-- SECTION B: select and run through the deliberately failing UPDATE.
-- The negative value should produce a check-constraint error (SQLSTATE 23514).
-- After the error, run ROLLBACK as a separate command (SECTION C).
BEGIN ISOLATION LEVEL READ COMMITTED;

UPDATE portfolio.score
SET p3_processed_count = p3_processed_count + 10
WHERE score_id = 4001
RETURNING score_id, p3_processed_count;

UPDATE portfolio.score
SET p3_processed_count = -1
WHERE score_id = 4001
RETURNING score_id, p3_processed_count;

-- SECTION C: after SECTION B reports the expected error, run these separately.
ROLLBACK;

SELECT score_id, p3_processed_count
FROM portfolio.score
WHERE score_id = 4001;
