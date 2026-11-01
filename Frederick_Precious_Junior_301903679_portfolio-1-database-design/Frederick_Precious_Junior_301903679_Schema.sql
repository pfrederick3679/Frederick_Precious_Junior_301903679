--ArenaPulse Gaming: Real-time Game Leaderboard: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."player" (
  "player_id" bigint NOT NULL,
  "handle" text NOT NULL,
  "display_name" text NOT NULL,
  "joined_at" timestamptz NOT NULL,
  CONSTRAINT "pk_player" PRIMARY KEY ("player_id"),
  CONSTRAINT "uq_player_0" UNIQUE ("handle")
);
CREATE TABLE portfolio."game" (
  "game_id" bigint NOT NULL,
  "title" text NOT NULL,
  "genre" text NOT NULL,
  "released_on" date,
  CONSTRAINT "pk_game" PRIMARY KEY ("game_id"),
  CONSTRAINT "uq_game_0" UNIQUE ("title")
);
CREATE TABLE portfolio."match" (
  "match_id" bigint NOT NULL,
  "game_id" bigint NOT NULL,
  "starts_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  "region" text NOT NULL,
  CONSTRAINT "pk_match" PRIMARY KEY ("match_id")
);
CREATE TABLE portfolio."score" (
  "score_id" bigint NOT NULL,
  "match_id" bigint NOT NULL,
  "player_id" bigint NOT NULL,
  "points" bigint NOT NULL,
  "recorded_at" timestamptz NOT NULL,
  CONSTRAINT "pk_score" PRIMARY KEY ("score_id"),
  CONSTRAINT "uq_score_0" UNIQUE ("match_id", "player_id")
);
ALTER TABLE portfolio."match" ADD CONSTRAINT "fk_match_0" FOREIGN KEY ("game_id") REFERENCES portfolio."game" ("game_id");
ALTER TABLE portfolio."score" ADD CONSTRAINT "fk_score_0" FOREIGN KEY ("match_id") REFERENCES portfolio."match" ("match_id");
ALTER TABLE portfolio."score" ADD CONSTRAINT "fk_score_1" FOREIGN KEY ("player_id") REFERENCES portfolio."player" ("player_id");
ALTER TABLE portfolio."match" ADD CONSTRAINT "match_status_allowed" CHECK (("status" = 'scheduled') OR ("status" = 'active') OR ("status" = 'completed'));
ALTER TABLE portfolio."score" ADD CONSTRAINT "score_points_nonnegative" CHECK ("points" >= 0);
COMMIT;
