-- Portfolio 3 concurrency exercise: Session B in pgAdmin Query Tool tab B.
-- Connect this second tab to the SAME database as Session A.

-- Step 2: run after Session A has read 1; expected value is also 1.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT score_id, p3_processed_count
FROM portfolio.score
WHERE score_id = 4001;

-- Step 4: after Session A commits its update to 2, run this stale write and COMMIT.
-- The final value is 2, demonstrating the lost increment (expected atomic result: 3).
UPDATE portfolio.score
SET p3_processed_count = 2
WHERE score_id = 4001
RETURNING score_id, p3_processed_count;
COMMIT;
SELECT score_id, p3_processed_count
FROM portfolio.score
WHERE score_id = 4001;

-- Step 7: after Session A has locked the row, run this SELECT.
-- It should wait until Session A commits, then return the updated value 2.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT score_id, p3_processed_count
FROM portfolio.score
WHERE score_id = 4001
FOR UPDATE;

-- Step 9: run after the SELECT above returns 2; then COMMIT.
UPDATE portfolio.score
SET p3_processed_count = p3_processed_count + 1
WHERE score_id = 4001
RETURNING score_id, p3_processed_count;
COMMIT;
SELECT score_id, p3_processed_count
FROM portfolio.score
WHERE score_id = 4001;
