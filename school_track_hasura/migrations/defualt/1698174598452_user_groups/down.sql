
DROP VIEW public.recipients;

DROP FUNCTION public.send_message;

DROP TABLE "public"."inbox_entries";

DROP TABLE "public"."recipient_group";

DROP TABLE "public"."recipient_user";

DROP TABLE "public"."user_recipient";

alter table "public"."messages" alter column "read_receipt" set default false;
alter table "public"."messages" alter column "read_receipt" drop not null;
alter table "public"."messages" add column "read_receipt" bool;

alter table "public"."messages"
  add constraint "messages_recipient_id_fkey"
  foreign key (recipient_id)
  references "public"."users"
  (id) on update restrict on delete restrict;
alter table "public"."messages" alter column "recipient_id" drop not null;
alter table "public"."messages" add column "recipient_id" int4;

alter table "public"."groups"
  add constraint "groups_homeroom_teacher_id_fkey"
  foreign key (homeroom_teacher_id)
  references "public"."users"
  (id) on update restrict on delete restrict;
alter table "public"."groups" alter column "homeroom_teacher_id" drop not null;
alter table "public"."groups" add column "homeroom_teacher_id" int4;
