# ArenaPulse Gaming:Real-time Game Leaderboard — SQL queries

## 1. Show related score, player, match records (up to 20).

```sql
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
```

| score_score_id | score_points | player_player_id | player_handle | match_match_id | match_starts_at |
| --- | --- | --- | --- | --- | --- |
| 4001 | 120 | 1001 | pixel_fox | 3001 | 2026-10-25T18:00:00+00:00 |
| 4002 | 85 | 1002 | orbit_sam | 3002 | 2026-10-26T19:00:00+00:00 |

## 2. Find game records where title matches "Nebula Circuit" (up to 20).

```sql
SELECT * FROM portfolio."game"
WHERE "title" IS NOT DISTINCT FROM 'Nebula Circuit'
ORDER BY "game_id"
LIMIT 20;
```

| game_id | title | genre | released_on |
| --- | --- | --- | --- |
| 2001 | Nebula Circuit | Racing | 2024-05-10 |

## 3. Count score records for each match_id (up to 20 groups).

```sql
SELECT "match_id", count(*) AS record_count
FROM portfolio."score"
GROUP BY "match_id"
ORDER BY record_count DESC, "match_id" NULLS LAST
LIMIT 20;
```

| match_id | record_count |
| --- | --- |
| 3001 | 1 |
| 3002 | 1 |

## 4. Leaderboard queries

The SQL script includes a per-match ranking with `RANK()` and game-wide total points ranked across completed matches. Tied scores share a rank. These query definitions are included for execution against the sample schema; their output has not been added to the evidence tables, and the two-row sample is only illustrative.

## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.91 | 1.948, 1.91, 1.906 | Sort → Seq Scan | 274 |
| After index | 0.252 | 0.345, 0.25, 0.252 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 1.91 ms to 0.252 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.918..1.921 rows=50 loops=1)
  Seq Scan on score (actual time=0.015..1.875 rows=50 loops=1)
Planning Time: 0.313 ms
Execution Time: 1.948 ms
```

### Before index, run 2

```text
Sort (actual time=1.881..1.884 rows=50 loops=1)
  Seq Scan on score (actual time=0.015..1.84 rows=50 loops=1)
Planning Time: 0.295 ms
Execution Time: 1.91 ms
```

### Before index, run 3

```text
Sort (actual time=1.878..1.882 rows=50 loops=1)
  Seq Scan on score (actual time=0.016..1.839 rows=50 loops=1)
Planning Time: 0.303 ms
Execution Time: 1.906 ms
```

### After index, run 1

```text
Sort (actual time=0.278..0.281 rows=50 loops=1)
  Bitmap Heap Scan on score (actual time=0.035..0.229 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.018 rows=50 loops=1)
Planning Time: 0.682 ms
Execution Time: 0.345 ms
```

### After index, run 2

```text
Sort (actual time=0.198..0.2 rows=50 loops=1)
  Bitmap Heap Scan on score (actual time=0.028..0.163 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=50 loops=1)
Planning Time: 0.466 ms
Execution Time: 0.25 ms
```

### After index, run 3

```text
Sort (actual time=0.2..0.203 rows=50 loops=1)
  Bitmap Heap Scan on score (actual time=0.029..0.163 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.015 rows=50 loops=1)
Planning Time: 0.474 ms
Execution Time: 0.252 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Queries.sql, then Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)


## Leaderboard operations

The SQL script also demonstrates a per-match `RANK()` and per-game total points ranked across completed matches. Tied totals share a rank. The query definitions are included for execution against the sample schema; the two-row sample is only illustrative and does not establish production performance.


