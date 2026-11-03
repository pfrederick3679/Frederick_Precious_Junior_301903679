# ArenaPulse Gaming: Real-time Game Leaderboard — Portfolio 5: Distributed and Cloud Design

## Status

This is a **proposed architecture and discussion**, not a deployed cloud system. No replica set, PostgreSQL high-availability service, sharded cluster, failover, or backup recovery test was configured or run for this portfolio.


## Deployment evidence and scope

The supplied diagram is the evidence for the proposed deployment layout. It shows the intended components and event path, while the sections below explain the data flow and operational trade-offs. No cloud provider was selected and no deployment configuration, replica-set status, failover output or backup-restore output exists for this submission.
## How this design matches the database project

The relational database remains the source of truth for player, game, match and score records in PostgreSQL schema `portfolio`:

- `player`: player IDs and unique handles.
- `game`: game IDs and unique titles.
- `match`: game reference, start time, status and region.
- `score`: player/match references, points and recording time. `(match_id, player_id)` is unique and points cannot be negative.

Portfolio 4 demonstrates a separate MongoDB database, `portfolio_nosql`, with the `leaderboard_events` collection. Its documents represent `score_submitted` and `score_corrected` events and embed event-time snapshots of the player, match and game. The corrected Portfolio 4 fixture illustrates score 4001 changing from 120 to 135 and score 4002 from 85 to 90. These are simulated events; the Portfolio 4 script does not update or synchronize the PostgreSQL rows.

The two databases are separate systems. MongoDB replication only copies MongoDB data among MongoDB replica-set members; it does not replicate PostgreSQL data.

## Proposed architecture and integration

The diagram is a logical proposal. It shows PostgreSQL and MongoDB as separate data services and is not evidence of a running deployment. PostgreSQL high availability must be configured independently from MongoDB replication.

For a future implementation, use PostgreSQL for authoritative score transactions and add a **transactional outbox** in PostgreSQL. The same PostgreSQL transaction would update a score and insert an outbox event. A retrying publisher would send that event to MongoDB, using a stable event ID as an idempotency key. This avoids pretending that a normal transaction can atomically commit across PostgreSQL and MongoDB. The current Portfolio 1 and Portfolio 4 scripts do not implement this outbox or publisher.

MongoDB can then serve event-history or leaderboard-projection reads. If event delivery is delayed, the MongoDB view may lag PostgreSQL. Retried event delivery must be handled idempotently; the event `_id` can identify duplicate deliveries, but the current sample script only demonstrates duplicate-ID rejection.

## MongoDB replication and availability

The proposal uses one MongoDB replica set with three data-bearing voting members in three availability zones in one region:

- One primary accepts writes.
- Two secondaries asynchronously copy and apply the primary's operation log.
- If the primary becomes unavailable, eligible members can elect a replacement when a voting majority can communicate. In a three-voter set, a majority is two. Writes may pause during an election and a side of a partition without a majority cannot elect a primary.
- Majority write concern requires acknowledgement from a majority of data-bearing voting members. With three data-bearing members, the write normally needs the primary and one secondary. This can increase latency; a write-concern timeout does not necessarily mean the primary failed to apply the write.

Three availability zones in one region reduce exposure to a single-zone failure, but they do not provide regional disaster recovery. Three processes on one computer would not provide meaningful machine-level redundancy.

## Consistency policy for leaderboard events

A reasonable starting policy for event writes is `writeConcern: { w: "majority", wtimeout: ... }`. Use primary reads for current leaderboard results. Use majority read concern when the caller needs majority-committed data. Secondary reads can return stale data because replication is asynchronous, so use them only when the application can tolerate lag. A timeout should lead to an idempotent retry or reconciliation because the write may already exist.

This policy applies to the proposed MongoDB event store. It does not replace PostgreSQL's primary keys, foreign keys, unique constraints or check constraints, and it does not create a cross-database transaction.

## Sharding trade-off

The four Portfolio 4 sample documents do not need sharding. Replication provides copies for availability; sharding partitions a large collection across shards for scale. If the event collection grows substantially, select a shard key only after measuring the real write and query patterns.

Portfolio 4 queries events by `eventType`, `occurredAt`, and nested `source.key.score_id`; it also creates a compound index on `eventType` and `occurredAt`. A hashed, high-cardinality score identifier may distribute inserts more evenly, but time-range queries may have to contact multiple shards. A monotonically increasing time key can concentrate new writes. A supporting index is not automatically a good shard key.

## Cloud security, backup and recovery

A real deployment would require private network access, authentication, least-privilege roles, TLS, monitoring and tested backups. Replication also copies accidental updates or deletions, so it is not a backup. A separate backup and restore plan is needed for MongoDB and PostgreSQL needs its own managed high-availability and recovery plan. Cross-region recovery would need to be designed and tested separately.

## Limitations and evidence

The architecture image is a proposal only. The portfolio contains no cloud configuration, replica-set status output, failover evidence, shard configuration, or backup-restore result.

## References

- [MongoDB: Replication](https://www.mongodb.com/docs/manual/replication/)
- [MongoDB: Replica Set Primary and Elections](https://www.mongodb.com/docs/manual/core/replica-set-primary/)
- [MongoDB: Write Concern](https://www.mongodb.com/docs/manual/reference/write-concern/)
- [MongoDB: Read Concern `majority`](https://www.mongodb.com/docs/manual/reference/read-concern-majority/)
- [MongoDB: Read Isolation, Consistency, and Recency](https://www.mongodb.com/docs/manual/core/read-isolation-consistency-recency/)
- [MongoDB: Sharding](https://www.mongodb.com/docs/manual/sharding/)
- [MongoDB: Hashed Sharding](https://www.mongodb.com/docs/manual/core/hashed-sharding/)

![Proposed architecture; not deployed](Frederick_Precious_Junior_301903679_screenshots/ProposedDesign.png)

