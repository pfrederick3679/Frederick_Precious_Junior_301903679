-- Portfolio 3 concurrency exercise: Session A in pgAdmin Query Tool tab A.
-- Keep this tab connected to the same database as tab B.

-- Step 1: run; expected value is 1.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT score_id, p3_processed_count
FROM portfolio.score
WHERE score_id = 4001;

-- Step 3: after Session B has also read 1, run this and COMMIT.
UPDATE portfolio.score
SET p3_processed_count = 2
WHERE score_id = 4001
RETURNING score_id, p3_processed_count;
COMMIT;

-- Step 5: after the lost-update example, reset to 1 (outside a transaction).
UPDATE portfolio.score
SET p3_processed_count = 1
WHERE score_id = 4001
RETURNING score_id, p3_processed_count;

-- Step 6: run this and leave the transaction open while Session B requests its lock.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT score_id, p3_processed_count
FROM portfolio.score
WHERE score_id = 4001
FOR UPDATE;

-- Step 8: after Session B's SELECT FOR UPDATE has been waiting, run this and COMMIT.
UPDATE portfolio.score
SET p3_processed_count = 2
WHERE score_id = 4001
RETURNING score_id, p3_processed_count;
COMMIT;
