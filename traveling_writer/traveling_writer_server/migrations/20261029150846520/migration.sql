BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "plot_node" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "summary" text NOT NULL,
    "content" text,
    "positionX" double precision NOT NULL,
    "positionY" double precision NOT NULL,
    "connectedNodeIds" json,
    "entityIds" json,
    "status" text NOT NULL
);


--
-- MIGRATION VERSION FOR traveling_writer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('traveling_writer', '20261029150846520', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261029150846520', "timestamp" = now();

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
