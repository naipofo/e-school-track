
CREATE TABLE "public"."rooms" ("id" serial NOT NULL, "name" text NOT NULL, PRIMARY KEY ("id") , UNIQUE ("name"));

alter table "public"."lessons" add column "room_id" integer
 null;

alter table "public"."lessons"
  add constraint "lessons_room_id_fkey"
  foreign key ("room_id")
  references "public"."rooms"
  ("id") on update restrict on delete restrict;
