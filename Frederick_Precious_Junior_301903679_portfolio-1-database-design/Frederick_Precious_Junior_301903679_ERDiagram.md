#ArenaPulse Gaming: Real-time Game Leaderboard — ER diagram

```mermaid
erDiagram
    direction LR
    player {
        bigint player_id PK
        text handle UK
        text display_name
        timestamptz joined_at
    }
    game {
        bigint game_id PK
        text title UK
        text genre
        date released_on "Optional"
    }
    match {
        bigint match_id PK
        bigint game_id FK
        timestamptz starts_at
        text status
        text region
    }
    score {
        bigint score_id PK
        bigint match_id FK
        bigint player_id FK
        bigint points
        timestamptz recorded_at
    }
    game ||--o{ match : "game_id"
    match ||--o{ score : "match_id"
    player ||--o{ score : "player_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/ERDiagram.png)

