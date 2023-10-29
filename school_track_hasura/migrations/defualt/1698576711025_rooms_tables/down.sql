
alter table "public"."lessons" drop constraint "lessons_room_id_fkey";

ALTER TABLE "public"."lessons" DROP COLUMN "room_id";

DROP TABLE "public"."rooms";
