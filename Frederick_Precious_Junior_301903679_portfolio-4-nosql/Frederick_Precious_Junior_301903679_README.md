# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection leaderboard_events for score_submitted and score_corrected events. These are simulated event examples based on the same score, match, player and game IDs used in Portfolio 1. The correction events illustrate hypothetical changes and do not modify or sync the PostgreSQL data.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; simulated event timestamps use the 2026 sample-data dates |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related player, match, game details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "score_submitted",
    "occurredAt": ISODate("2026-10-25T18:45:00Z"),
    "source": {
        "entity": "score",
        "key": {
            "score_id": 4001
        },
        "snapshot": {
            "score_id": 4001,
            "match_id": 3001,
            "player_id": 1001,
            "points": 120,
            "recorded_at": "2026-10-25T18:45:00Z"
        }
    },
    "embedded": {
        "player": [
            {
                "key": {
                    "player_id": 1001
                },
                "snapshot": {
                    "player_id": 1001,
                    "handle": "pixel_fox",
                    "display_name": "Pixel Fox",
                    "joined_at": "2026-10-20T09:00:00Z"
                },
                "via": [
                    "score.player_id → player"
                ]
            }
        ],
        "match": [
            {
                "key": {
                    "match_id": 3001
                },
                "snapshot": {
                    "match_id": 3001,
                    "game_id": 2001,
                    "starts_at": "2026-10-25T18:00:00Z",
                    "status": "completed",
                    "region": "eu-west"
                },
                "via": [
                    "score.match_id → match"
                ]
            }
        ],
        "game": [
            {
                "key": {
                    "game_id": 2001
                },
                "snapshot": {
                    "game_id": 2001,
                    "title": "Nebula Circuit",
                    "genre": "Racing",
                    "released_on": "2024-05-10"
                },
                "via": [
                    "score.match_id → match.game_id → game"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 2 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 4 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("leaderboard_events").find({"eventType":"score_submitted"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "score_submitted",
    "occurredAt": {
      "$date": "2026-10-25T18:45:00Z"
    },
    "source": {
      "score_id": 4001
    }
  },
  {
    "_id": "event_000003",
    "eventType": "score_submitted",
    "occurredAt": {
      "$date": "2026-10-26T19:20:00Z"
    },
    "source": {
      "score_id": 4002
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("leaderboard_events").find({"source.key.score_id":4001}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "score_submitted",
    "occurredAt": {
      "$date": "2026-10-25T18:45:00Z"
    },
    "source": {
      "score_id": 4001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "score_corrected",
    "occurredAt": {
      "$date": "2026-10-25T18:50:00Z"
    },
    "source": {
      "score_id": 4001
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("leaderboard_events").find({"occurredAt":{"$gte":ISODate("2026-10-25T18:00:00Z"), "$lt":ISODate("2026-10-27T00:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "score_submitted",
    "occurredAt": {
      "$date": "2026-10-25T18:45:00Z"
    },
    "source": {
      "score_id": 4001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "score_corrected",
    "occurredAt": {
      "$date": "2026-10-25T18:50:00Z"
    },
    "source": {
      "score_id": 4001
    }
  },
  {
    "_id": "event_000003",
    "eventType": "score_submitted",
    "occurredAt": {
      "$date": "2026-10-26T19:20:00Z"
    },
    "source": {
      "score_id": 4002
    }
  },
  {
    "_id": "event_000004",
    "eventType": "score_corrected",
    "occurredAt": {
      "$date": "2026-10-26T19:25:00Z"
    },
    "source": {
      "score_id": 4002
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("leaderboard_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| score_corrected | 2 |
| score_submitted | 2 |

## Validation and suitability

Expected when the script runs successfully: 4 valid documents are inserted; the invalid date is rejected by the validator (expected code 121), and the duplicate event ID is rejected by the built-in `_id` uniqueness rule (expected code 11000). The final count should remain 4. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed. These expected results have not been re-run after the correction to the sample events.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Install MongoDB Community Server and `mongosh`, start the local MongoDB service, then open PowerShell. Run the script using its full path:

```powershell
mongosh --file "C:\path\to\MongoDB.js"
```

The script selects `portfolio_nosql` and creates `leaderboard_events`. It stops if that collection already exists. To repeat the exercise, remove only the sample collection first from mongosh:

```javascript
db = db.getSiblingDB("portfolio_nosql");
db.leaderboard_events.drop();
```

This removes the MongoDB exercise documents and does not change PostgreSQL. After running the corrected script, capture fresh evidence from your own MongoDB session. The screenshot in the original ZIP shows the old dates and must not be used for the corrected version.
## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)


## Simulated score corrections

| Event | PostgreSQL sample score | Simulated corrected value | Event time (UTC) |
| --- | ---: | ---: | --- |
| `event_000002` | 120 | 135 | 2026-10-25 18:50 |
| `event_000004` | 85 | 90 | 2026-10-26 19:25 |

The event stream uses the same source score IDs as the PostgreSQL sample, but the corrections are hypothetical NoSQL events; running this script does not update PostgreSQL. Event `event_000002` illustrates score 4001 changing from 120 to 135 at 2026-10-25 18:50 UTC. Event `event_000004` illustrates score 4002 changing from 85 to 90 at 2026-10-26 19:25 UTC. Each correction document keeps the corrected value in `source.snapshot` and records the prior and corrected values in `details`. The dates are now consistent with the 2026 sample records instead of being future 2030 dates.

The four events are a teaching fixture, not proof that these corrections were applied to the PostgreSQL `score` rows. Keep the portfolio's live relational sample unchanged unless you separately decide to change and re-verify that project.




