// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("leaderboard_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("leaderboard_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "score_submitted",
                    "score_corrected"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "score"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "score_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("leaderboard_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "score_corrected",
        "occurredAt": ISODate("2026-10-25T18:50:00Z"),
        "source": {
            "entity": "score",
            "key": {
                "score_id": 4001
            },
            "snapshot": {
                "score_id": 4001,
                "match_id": 3001,
                "player_id": 1001,
                "points": 135,
                "recorded_at": "2026-10-25T18:50:00Z"
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
            "channel": "mobile",
            "previousPoints": 120,
            "correctedPoints": 135,
            "correctionReason": "score corrected after review",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "client_metadata": "illustrative client_metadata",
                "bonus_breakdown": "illustrative bonus_breakdown",
                "device_context": "illustrative device_context"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "score_submitted",
        "occurredAt": ISODate("2026-10-26T19:20:00Z"),
        "source": {
            "entity": "score",
            "key": {
                "score_id": 4002
            },
            "snapshot": {
                "score_id": 4002,
                "match_id": 3002,
                "player_id": 1002,
                "points": 85,
                "recorded_at": "2026-10-26T19:20:00+00:00"
            }
        },
        "embedded": {
            "player": [
                {
                    "key": {
                        "player_id": 1002
                    },
                    "snapshot": {
                        "player_id": 1002,
                        "handle": "orbit_sam",
                        "display_name": "Orbit Sam",
                        "joined_at": "2026-10-21T14:30:00+00:00"
                    },
                    "via": [
                        "score.player_id → player"
                    ]
                }
            ],
            "match": [
                {
                    "key": {
                        "match_id": 3002
                    },
                    "snapshot": {
                        "match_id": 3002,
                        "game_id": 2002,
                        "starts_at": "2026-10-26T19:00:00+00:00",
                        "status": "active",
                        "region": "us-east"
                    },
                    "via": [
                        "score.match_id → match"
                    ]
                }
            ],
            "game": [
                {
                    "key": {
                        "game_id": 2002
                    },
                    "snapshot": {
                        "game_id": 2002,
                        "title": "Signal Garden",
                        "genre": "Strategy",
                        "released_on": null
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
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "score_corrected",
        "occurredAt": ISODate("2026-10-26T19:25:00Z"),
        "source": {
            "entity": "score",
            "key": {
                "score_id": 4002
            },
            "snapshot": {
                "score_id": 4002,
                "match_id": 3002,
                "player_id": 1002,
                "points": 90,
                "recorded_at": "2026-10-26T19:25:00Z"
            }
        },
        "embedded": {
            "player": [
                {
                    "key": {
                        "player_id": 1002
                    },
                    "snapshot": {
                        "player_id": 1002,
                        "handle": "orbit_sam",
                        "display_name": "Orbit Sam",
                        "joined_at": "2026-10-21T14:30:00+00:00"
                    },
                    "via": [
                        "score.player_id → player"
                    ]
                }
            ],
            "match": [
                {
                    "key": {
                        "match_id": 3002
                    },
                    "snapshot": {
                        "match_id": 3002,
                        "game_id": 2002,
                        "starts_at": "2026-10-26T19:00:00+00:00",
                        "status": "active",
                        "region": "us-east"
                    },
                    "via": [
                        "score.match_id → match"
                    ]
                }
            ],
            "game": [
                {
                    "key": {
                        "game_id": 2002
                    },
                    "snapshot": {
                        "game_id": 2002,
                        "title": "Signal Garden",
                        "genre": "Strategy",
                        "released_on": null
                    },
                    "via": [
                        "score.match_id → match.game_id → game"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "previousPoints": 85,
            "correctedPoints": 90,
            "correctionReason": "score corrected after review",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "client_metadata": "illustrative client_metadata",
                "bonus_breakdown": "illustrative bonus_breakdown",
                "device_context": "illustrative device_context"
            }
        }
    }
]));
  await db.getCollection("leaderboard_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("leaderboard_events").find({"eventType":"score_submitted"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("leaderboard_events").find({"source.key.score_id":4001}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("leaderboard_events").find({"occurredAt":{"$gte":ISODate("2026-10-25T18:00:00Z"), "$lt":ISODate("2026-10-27T00:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("leaderboard_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("leaderboard_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("leaderboard_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("leaderboard_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });


