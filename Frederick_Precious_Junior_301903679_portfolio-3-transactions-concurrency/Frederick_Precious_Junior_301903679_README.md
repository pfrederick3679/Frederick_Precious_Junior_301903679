# Portfolio 3 — Transactions and Concurrency

 Run the exercise in the same database where Portfolio 1's `portfolio.score` table and sample row `score_id = 4001` exist.

## Files

- `Frederick_Precious_Junior_301903679_Setup.sql` — adds the temporary counter and its check constraint. Safe to run more than once.
- `Frederick_Precious_Junior_301903679_Transactions.sql` — demonstrates COMMIT and a constraint error followed by ROLLBACK.
- `Frederick_Precious_Junior_301903679_SessionA.sql` and `Frederick_Precious_Junior_301903679_SessionB.sql` — demonstrate a lost update and the effect of `SELECT FOR UPDATE` using two Query Tool tabs.

## 1. Open the correct database

1. In pgAdmin, expand **Servers**, connect to your PostgreSQL server, and select the database containing the Portfolio 1 tables.
2. Right-click that database and choose **Query Tool**.
3. Confirm the connection/database shown in the Query Tool is the right one. The scripts refer to `portfolio.score` and `score_id = 4001`.
4. Open `Frederick_Precious_Junior_301903679_Setup.sql` in the Query Tool and click **Execute/Refresh** (or press **F5**). The final result should show row 4001 with `p3_processed_count = 0` the first time. If it is not zero because you have already run the exercise, reset it with:

```sql
UPDATE portfolio.score
SET p3_processed_count = 0
WHERE score_id = 4001;
```

## 2. Demonstrate COMMIT

In `Frederick_Precious_Junior_301903679_Transactions.sql`, select the complete **SECTION A** block (`BEGIN` through `COMMIT`) and execute it. The returned counter should become 1. Run the following `SELECT` to confirm the committed value is visible.

## 3. Demonstrate a failed constraint and ROLLBACK

In the same file, select and execute **SECTION B** (`BEGIN` and both `UPDATE` statements). The first update temporarily changes the counter from 1 to 11. The second update should fail because the check constraint prohibits a negative value; PostgreSQL reports check violation SQLSTATE `23514`.

After that error, the transaction is aborted. Select and execute `ROLLBACK` from **SECTION C** as a separate action, then run its `SELECT`. The counter should be back at 1 because the entire failed transaction was rolled back. Do not run the setup script again to reset the value.

## 4. Demonstrate a lost update with two Query Tool tabs

Open a second Query Tool tab connected to the **same database**. Label the tabs A and B for clarity. Run the steps in this exact order; execute each indicated statement/block separately:

1. **A:** Run `BEGIN` and the first `SELECT` in `Frederick_Precious_Junior_301903679_SessionA.sql`. It reads 1 and leaves the transaction open.
2. **B:** Run `BEGIN` and the first `SELECT` in `Frederick_Precious_Junior_301903679_SessionB.sql`. It also reads 1.
3. **A:** Run its update to 2 and `COMMIT`.
4. **B:** Run its update to 2 and `COMMIT`, then the `SELECT`. The final value is 2: B overwrote A's increment using the stale value it read earlier. Two increments from 1 would produce 3, so one increment was lost.
5. **A:** Run the reset update (outside a transaction). It sets the counter back to 1.

## 5. Demonstrate row locking

Continue using the same two tabs and follow the numbered lock sections:

6. **A:** Run `BEGIN` and `SELECT ... FOR UPDATE`. The row is now locked by A; leave this transaction open.
7. **B:** Run `BEGIN` and `SELECT ... FOR UPDATE`. This query should wait while A holds the lock. Do not cancel it.
8. **A:** Run its update to 2 and `COMMIT`. This releases the lock.
9. **B:** Its waiting `SELECT` should now return the updated value 2. Run B's increment update (`p3_processed_count + 1`) and `COMMIT`. The final `SELECT` should show 3.

If Query Tool executes a selected block and remains busy while waiting for the lock, switch to tab A and commit there. If using one tab for both sessions, the concurrency demonstration will not work: PostgreSQL needs two separate connections.

## Expected observations

| Demonstration | Expected final counter | Meaning |
| --- | ---: | --- |
| Commit | 1 | The committed update persists. |
| Failed check then rollback | 1 | The failed transaction's earlier `+10` is undone. |
| Two stale read/write sessions | 2 | One increment is lost. |
| `SELECT FOR UPDATE` sessions | 3 | B waits, reads A's committed value, and applies its increment. |

## Important notes

- The counter is a temporary exercise helper, not part of the Portfolio 1 business schema. It does not change the case's player, match, or score points.
- Run the setup script only in the intended project database. It adds a column and constraint to `portfolio.score`.
- If you make a mistake and a transaction remains open, run `ROLLBACK;` in that same Query Tool tab before continuing.
- Record screenshots from your own pgAdmin session for the successful commit, check error/rollback, lost update, and lock wait/final result. Do not label a result successful unless you observed it.

## References

- [PostgreSQL: Transaction Isolation](https://www.postgresql.org/docs/17/transaction-iso.html)
- [PostgreSQL: Explicit Locking](https://www.postgresql.org/docs/17/explicit-locking.html)
