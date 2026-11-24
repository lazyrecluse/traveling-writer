BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "plot_node" ADD COLUMN "worldId" bigint;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "world" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "genre" text,
    "description" text,
    "ownerId" text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "world_entity" ADD COLUMN "worldId" bigint;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "world_rule" ADD COLUMN "worldId" bigint;

--
-- MIGRATION VERSION FOR traveling_writer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('traveling_writer', '20261121110919978', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261121110919978', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
