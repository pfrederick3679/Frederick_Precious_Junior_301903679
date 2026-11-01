-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. player pk. Expected: pk_player, SQLSTATE 23505.
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at")
VALUES (1001, 'pk_probe_player', 'PK Probe', '2026-10-26T10:00:00Z');

-- 2. player unique. Expected: uq_player_0, SQLSTATE 23505.
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at")
VALUES (1101, 'pixel_fox', 'Unique Probe', '2026-10-26T10:00:00Z');

-- 3. player nn id. Expected: player_id, SQLSTATE 23502.
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at")
VALUES (NULL, 'nn_probe_player_id', 'NN Probe', '2026-10-26T10:00:00Z');

-- 4. player nn handle. Expected: handle, SQLSTATE 23502.
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at")
VALUES (1102, NULL, 'NN Probe', '2026-10-26T10:00:00Z');

-- 5. player nn name. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at")
VALUES (1103, 'nn_probe_name', NULL, '2026-10-26T10:00:00Z');

-- 6. player nn joined. Expected: joined_at, SQLSTATE 23502.
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at")
VALUES (1104, 'nn_probe_joined', 'NN Probe', NULL);

-- 7. game pk. Expected: pk_game, SQLSTATE 23505.
INSERT INTO portfolio."game" ("game_id", "title", "genre", "released_on")
VALUES (2001, 'PK Probe Game', 'Puzzle', NULL);

-- 8. game unique. Expected: uq_game_0, SQLSTATE 23505.
INSERT INTO portfolio."game" ("game_id", "title", "genre", "released_on")
VALUES (2101, 'Nebula Circuit', 'Puzzle', NULL);

-- 9. game nn id. Expected: game_id, SQLSTATE 23502.
INSERT INTO portfolio."game" ("game_id", "title", "genre", "released_on")
VALUES (NULL, 'NN Probe Game', 'Puzzle', NULL);

-- 10. game nn title. Expected: title, SQLSTATE 23502.
INSERT INTO portfolio."game" ("game_id", "title", "genre", "released_on")
VALUES (2102, NULL, 'Puzzle', NULL);

-- 11. game nn genre. Expected: genre, SQLSTATE 23502.
INSERT INTO portfolio."game" ("game_id", "title", "genre", "released_on")
VALUES (2103, 'NN Probe Genre', NULL, NULL);

-- 12. match pk. Expected: pk_match, SQLSTATE 23505.
INSERT INTO portfolio."match" ("match_id", "game_id", "starts_at", "status", "region")
VALUES (3001, 2002, '2026-10-26T10:00:00Z', 'scheduled', 'probe-region');

-- 13. match fk game. Expected: fk_match_0, SQLSTATE 23503.
INSERT INTO portfolio."match" ("match_id", "game_id", "starts_at", "status", "region")
VALUES (3101, 29999, '2026-10-26T10:00:00Z', 'scheduled', 'probe-region');

-- 14. match nn id. Expected: match_id, SQLSTATE 23502.
INSERT INTO portfolio."match" ("match_id", "game_id", "starts_at", "status", "region")
VALUES (NULL, 2001, '2026-10-26T10:00:00Z', 'scheduled', 'probe-region');

-- 15. match nn game. Expected: game_id, SQLSTATE 23502.
INSERT INTO portfolio."match" ("match_id", "game_id", "starts_at", "status", "region")
VALUES (3102, NULL, '2026-10-26T10:00:00Z', 'scheduled', 'probe-region');

-- 16. match nn starts. Expected: starts_at, SQLSTATE 23502.
INSERT INTO portfolio."match" ("match_id", "game_id", "starts_at", "status", "region")
VALUES (3103, 2001, NULL, 'scheduled', 'probe-region');

-- 17. match nn status. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."match" ("match_id", "game_id", "starts_at", "status", "region")
VALUES (3104, 2001, '2026-10-26T10:00:00Z', NULL, 'probe-region');

-- 18. match nn region. Expected: region, SQLSTATE 23502.
INSERT INTO portfolio."match" ("match_id", "game_id", "starts_at", "status", "region")
VALUES (3105, 2001, '2026-10-26T10:00:00Z', 'scheduled', NULL);

-- 19. match bad status. Expected: match_status_allowed, SQLSTATE 23514.
INSERT INTO portfolio."match" ("match_id", "game_id", "starts_at", "status", "region")
VALUES (3106, 2001, '2026-10-26T10:00:00Z', 'paused', 'probe-region');

-- 20. score pk. Expected: pk_score, SQLSTATE 23505.
INSERT INTO portfolio."score" ("score_id", "match_id", "player_id", "points", "recorded_at")
VALUES (4001, 3001, 1002, 50, '2026-10-26T10:00:00Z');

-- 21. score unique. Expected: uq_score_0, SQLSTATE 23505.
INSERT INTO portfolio."score" ("score_id", "match_id", "player_id", "points", "recorded_at")
VALUES (4101, 3001, 1001, 50, '2026-10-26T10:00:00Z');

-- 22. score fk match. Expected: fk_score_0, SQLSTATE 23503.
INSERT INTO portfolio."score" ("score_id", "match_id", "player_id", "points", "recorded_at")
VALUES (4102, 39999, 1001, 50, '2026-10-26T10:00:00Z');

-- 23. score fk player. Expected: fk_score_1, SQLSTATE 23503.
INSERT INTO portfolio."score" ("score_id", "match_id", "player_id", "points", "recorded_at")
VALUES (4103, 3001, 19999, 50, '2026-10-26T10:00:00Z');

-- 24. score nn id. Expected: score_id, SQLSTATE 23502.
INSERT INTO portfolio."score" ("score_id", "match_id", "player_id", "points", "recorded_at")
VALUES (NULL, 3001, 1002, 50, '2026-10-26T10:00:00Z');

-- 25. score nn match. Expected: match_id, SQLSTATE 23502.
INSERT INTO portfolio."score" ("score_id", "match_id", "player_id", "points", "recorded_at")
VALUES (4104, NULL, 1002, 50, '2026-10-26T10:00:00Z');

-- 26. score nn player. Expected: player_id, SQLSTATE 23502.
INSERT INTO portfolio."score" ("score_id", "match_id", "player_id", "points", "recorded_at")
VALUES (4105, 3001, NULL, 50, '2026-10-26T10:00:00Z');

-- 27. score nn points. Expected: points, SQLSTATE 23502.
INSERT INTO portfolio."score" ("score_id", "match_id", "player_id", "points", "recorded_at")
VALUES (4106, 3001, 1002, NULL, '2026-10-26T10:00:00Z');

-- 28. score nn recorded. Expected: recorded_at, SQLSTATE 23502.
INSERT INTO portfolio."score" ("score_id", "match_id", "player_id", "points", "recorded_at")
VALUES (4107, 3001, 1002, 50, NULL);

-- 29. score negative points. Expected: score_points_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."score" ("score_id", "match_id", "player_id", "points", "recorded_at")
VALUES (4108, 3001, 1002, -1, '2026-10-26T10:00:00Z');
