-- Portfolio 3 setup for pgAdmin Query Tool.
-- Select the correct database before running this script.
-- Safe to run again: the column and check constraint are added only if missing.

ALTER TABLE portfolio.score
    ADD COLUMN IF NOT EXISTS p3_processed_count integer NOT NULL DEFAULT 0;

DO $setup$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'p3_count_nonnegative'
          AND conrelid = 'portfolio.score'::regclass
    ) THEN
        ALTER TABLE portfolio.score
            ADD CONSTRAINT p3_count_nonnegative
            CHECK (p3_processed_count >= 0);
    END IF;
END;
$setup$;

-- Confirm the row used by this exercise exists and starts at zero.
SELECT score_id, p3_processed_count
FROM portfolio.score
WHERE score_id = 4001;

