

alter table "public"."lesson_periods" drop column "start" cascade;

alter table "public"."lesson_periods" drop column "length" cascade;

alter table "public"."lesson_periods" add column "name" text
 null;

CREATE TABLE "public"."schedules" ("id" serial NOT NULL, "name" text NOT NULL, PRIMARY KEY ("id") );

CREATE TABLE "public"."period_times" ("id" serial NOT NULL, "schedule_id" integer, "period_id" integer NOT NULL, "start" time NOT NULL, "length" interval NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("schedule_id") REFERENCES "public"."schedules"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("period_id") REFERENCES "public"."lesson_periods"("id") ON UPDATE restrict ON DELETE restrict);

alter table "public"."period_times" add constraint "period_times_schedule_id_period_id_key" unique ("schedule_id", "period_id");
