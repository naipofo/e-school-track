
alter table "public"."period_times" drop constraint "period_times_schedule_id_period_id_key";


DROP TABLE "public"."period_times";

DROP TABLE "public"."schedules";

alter table "public"."lesson_periods" drop column "name" cascade;

alter table "public"."lesson_periods" add column "length" interval;
alter table "public"."lesson_periods" alter column "length" drop not null;

alter table "public"."lesson_periods" add column "start" time;
alter table "public"."lesson_periods" alter column "start" drop not null;
