alter table "public"."user_group" add constraint "user_group_user_id_group_id_key" unique ("user_id", "group_id");
