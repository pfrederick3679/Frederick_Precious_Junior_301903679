#ArenaPulse Gaming: Real-time Game Leaderboard — normalisation

This explanation uses the implemented player, game, match and score relations. The starting table below is a deliberately denormalised view that repeats player, match and game descriptions beside each score. Repeating these values creates update, insertion and deletion anomalies.

## Starting unnormalised view

| score_id | match_id | player_id | handle | points | game_id | game_title | match_status |
| --- | --- | --- | --- | ---: | --- | --- | --- |
| 4001 | 3001 | 1001 | pixel_fox | 120 | 2001 | Nebula Circuit | completed |
| 4002 | 3002 | 1002 | orbit_sam | 85 | 2002 | Signal Garden | active |

A production version of this starting view could contain multiple score IDs in a list for one match; that repeating group must be expanded so every score is one row.

## First Normal Form (1NF)

Each cell contains one value and each row represents one score record. The table above has atomic values and `score_id` identifies each row. This alone does not remove repeated descriptions: the same handle, match or game details would appear on every related score row.

## Second Normal Form (2NF)

A relation is in 2NF when it is in 1NF and every non-key attribute depends on the whole of every candidate key. In the implemented `score` relation, `score_id` is a single-column primary key. The alternate candidate key `(match_id, player_id)` is also unique. `points` and `recorded_at` describe that particular player-in-that-match score and depend on the whole pair; neither is determined by `match_id` alone or `player_id` alone. There is therefore no partial dependency among the score attributes.

For the deliberately denormalised starting view, match attributes depend on `match_id`, player attributes on `player_id`, and game attributes on `game_id`, rather than on the whole composite `(match_id, player_id)` score key. Decomposing those attributes removes the partial dependencies.

## Third Normal Form (3NF)

The final design separates each entity's descriptive attributes so non-key attributes depend on the key, the whole key and nothing but the key:

| Relation | Primary key and functional dependency | Additional candidate key |
| --- | --- | --- |
| `player` | `player_id → handle, display_name, joined_at` | `handle` |
| `game` | `game_id → title, genre, released_on` | `title` |
| `match` | `match_id → game_id, starts_at, status, region` | — |
| `score` | `score_id → match_id, player_id, points, recorded_at` | `(match_id, player_id)` |

The `match` relation stores `game_id` as a foreign key; the game title remains in `game`. The `score` relation stores the player and match keys; player, match and game descriptions remain in their own relations. These declared dependencies assume handles and game titles are unique, and each player has at most one score per match.

## Final relations and sample rows

### player

| player_id | handle | display_name | joined_at |
| --- | --- | --- | --- |
| 1001 | pixel_fox | Pixel Fox | 2026-10-20T09:00:00+00:00 |
| 1002 | orbit_sam | Orbit Sam | 2026-10-21T14:30:00+00:00 |

### game

| game_id | title | genre | released_on |
| --- | --- | --- | --- |
| 2001 | Nebula Circuit | Racing | 2024-05-10 |
| 2002 | Signal Garden | Strategy | NULL |

### match

| match_id | game_id | starts_at | status | region |
| --- | --- | --- | --- | --- |
| 3001 | 2001 | 2026-10-25T18:00:00+00:00 | completed | eu-west |
| 3002 | 2002 | 2026-10-26T19:00:00+00:00 | active | us-east |

### score

| score_id | match_id | player_id | points | recorded_at |
| --- | --- | --- | ---: | --- |
| 4001 | 3001 | 1001 | 120 | 2026-10-25T18:45:00+00:00 |
| 4002 | 3002 | 1002 | 85 | 2026-10-26T19:20:00+00:00 |

This decomposition reduces repeated descriptions and the update, insertion and deletion anomalies they cause. Joining the relations through their foreign keys reconstructs the corresponding score view without storing those descriptions repeatedly.
