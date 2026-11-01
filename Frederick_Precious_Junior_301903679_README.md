# ArenaPulse Gaming — Real-Time Leaderboard System

**Course:** MIT 8103 Advanced Database Systems  
**Portfolio author:** Precious Junior Frederick  
**Student ID:** 301903679

ArenaPulse Gaming is the fictional organisation used for this database case study. The project models a real-time game leaderboard and demonstrates relational database design, query optimisation, transaction handling, a NoSQL event model, and a distributed/cloud design proposal.

## Database overview

The primary relational database is PostgreSQL. Its `portfolio` schema contains four tables:

- `player` stores player handles, display names, and join dates.
- `game` stores game titles, genres, and optional release dates.
- `match` stores a game's match schedule, status, and region.
- `score` stores each player's score in a match and when it was recorded.

Primary keys identify each record. Foreign keys link matches to games and scores to players and matches. Player handles and game titles are unique. A unique constraint on `(match_id, player_id)` permits one score row per player per match; check constraints limit match status and prevent negative points.

MongoDB is used separately in Portfolio 4 to demonstrate simulated leaderboard events. It is not synchronised with or a replacement for the PostgreSQL database. Portfolio 5 discusses a proposed distributed/cloud design; it is not evidence of a deployed cloud environment.

## Portfolio sections

1. [Portfolio 1 — Database design](Frederick_Precious_Junior_301903679_portfolio-1-database-design/) — design notes, ER diagram, schema, sample data, normalisation, and constraint checks.
2. [Portfolio 2 — Query optimisation](Frederick_Precious_Junior_301903679_portfolio-2-query-optimisation/) — SQL queries, index comparison, and query-plan evidence.
3. [Portfolio 3 — Transactions and concurrency](Frederick_Precious_Junior_301903679_portfolio-3-transactions-concurrency/) — transaction control, rollback, and concurrent-update exercises.
4. [Portfolio 4 — NoSQL](Frederick_Precious_Junior_301903679_portfolio-4-nosql/) — MongoDB event documents, validation, indexes, and queries.
5. [Portfolio 5 — Distributed/cloud design](Frederick_Precious_Junior_301903679_portfolio-5-distributed-cloud/) — proposed replication, availability, consistency, sharding, and deployment considerations.

The SQL and MongoDB exercises were run and tested by me. Portfolio 5 is a design discussion and proposal; it was not deployed to a cloud service or tested as a live distributed cluster.

## Final summary

- [Documentation (Markdown)](Documentation.md)
- [Documentation (PDF)](Documentation.pdf)

## GitHub

[Frederick Precious Junior MIT 8103 Portfolio](https://github.com/pfrederick3679/Frederick_Precious_Junior_301903679)