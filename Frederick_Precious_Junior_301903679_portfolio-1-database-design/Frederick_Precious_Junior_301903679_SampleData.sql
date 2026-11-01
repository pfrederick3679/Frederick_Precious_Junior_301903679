-- Fictional sample records for Real-time Game Leaderboard.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at") VALUES (1001, 'pixel_fox', 'Pixel Fox', '2026-10-20T09:00:00Z');
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at") VALUES (1002, 'orbit_sam', 'Orbit Sam', '2026-10-21T14:30:00+00:00');
INSERT INTO portfolio."game" ("game_id", "title", "genre", "released_on") VALUES (2001, 'Nebula Circuit', 'Racing', '2024-05-10');
INSERT INTO portfolio."game" ("game_id", "title", "genre", "released_on") VALUES (2002, 'Signal Garden', 'Strategy', NULL);
INSERT INTO portfolio."match" ("match_id", "game_id", "starts_at", "status", "region") VALUES (3001, 2001, '2026-10-25T18:00:00Z', 'completed', 'eu-west');
INSERT INTO portfolio."match" ("match_id", "game_id", "starts_at", "status", "region") VALUES (3002, 2002, '2026-10-26T19:00:00+00:00', 'active', 'us-east');
INSERT INTO portfolio."score" ("score_id", "match_id", "player_id", "points", "recorded_at") VALUES (4001, 3001, 1001, 120, '2026-10-25T18:45:00Z');
INSERT INTO portfolio."score" ("score_id", "match_id", "player_id", "points", "recorded_at") VALUES (4002, 3002, 1002, 85, '2026-10-26T19:20:00+00:00');
COMMIT;
