# ArenaPulse Gaming:Real-time Game Leaderboard — database design

My case study records player, game, match, score.

## Users

- Players submitting scores
- Viewers checking leaderboards
- Operators reviewing completed matches

## Main operations

- Register players and games
- Create matches and record or correct player scores
- View match rankings and game-wide totals

## Entities

| Entity | Information stored |
| --- | --- |
| player | Stores leaderboard participants. |
| game | Stores games that host matches and leaderboards. |
| match | Stores a game session, its schedule, status, and region. |
| score | Stores each player's score and recording time for a match. |

## player

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| player_id | BIGINT | PK | Yes |
| handle | TEXT | Unique | Yes |
| display_name | TEXT |  | Yes |
| joined_at | TIMESTAMPTZ |  | Yes |
- Unique key: (handle).

## game

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| game_id | BIGINT | PK | Yes |
| title | TEXT | Unique | Yes |
| genre | TEXT |  | Yes |
| released_on | DATE |  | No |
- Unique key: (title).

## match

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| match_id | BIGINT | PK | Yes |
| game_id | BIGINT | FK | Yes |
| starts_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
| region | TEXT |  | Yes |
- game_id → game.game_id

## score

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| score_id | BIGINT | PK | Yes |
| match_id | BIGINT | FK | Yes |
| player_id | BIGINT | FK | Yes |
| points | BIGINT |  | Yes |
| recorded_at | TIMESTAMPTZ |  | Yes |
- match_id → match.match_id
- player_id → player.player_id
- Unique key: (match_id, player_id).

## Relationships and business rules

- Every player handle is required and unique.
- Every match references an existing game.
- Match status must be scheduled, active, or completed.
- A recorded score must be zero or greater.
- A player has at most one score row per match, including concurrent submissions.
- Every score references an existing match.
- Every score references an existing player.

## Assumptions

- Each match belongs to one game, and each score belongs to one player and one match.
- A player has at most one score record per match; corrections update that record.
- Scores are nonnegative integers, and match status is scheduled, active, or completed.
- Identifiers are generated from a globally unique namespace; handles and game titles are unique.
- Game-wide leaderboard totals sum scores from completed matches, and ties may share a rank.
- Separate benchmark plan: generate 50,000 synthetic score rows, compare equivalent match_id filters with and without a B-tree index, and check plan shape and result equivalence. This is a proposed procedure, not a result.


