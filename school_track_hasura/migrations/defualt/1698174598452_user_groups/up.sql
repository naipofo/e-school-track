
alter table "public"."groups" drop column "homeroom_teacher_id" cascade;

alter table "public"."messages" drop column "recipient_id" cascade;

alter table "public"."messages" drop column "read_receipt" cascade;

CREATE TABLE "public"."recipient_user" ("message_id" integer NOT NULL, "user_id" integer NOT NULL, PRIMARY KEY ("message_id","user_id") , FOREIGN KEY ("message_id") REFERENCES "public"."messages"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE restrict ON DELETE restrict);

CREATE TABLE "public"."recipient_group" ("message_id" integer NOT NULL, "group_id" integer NOT NULL, PRIMARY KEY ("message_id","group_id") , FOREIGN KEY ("message_id") REFERENCES "public"."messages"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON UPDATE restrict ON DELETE restrict);

CREATE TABLE "public"."inbox_entries" ("id" serial NOT NULL, "user_id" integer NOT NULL, "message_id" integer NOT NULL, "read_receipt" boolean NOT NULL DEFAULT false, PRIMARY KEY ("id") , FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("message_id") REFERENCES "public"."messages"("id") ON UPDATE restrict ON DELETE restrict);

CREATE VIEW public.recipients AS
SELECT message_id, user_id
FROM public.recipient_user
UNION ALL
SELECT message_id, user_id
FROM public.recipient_group
JOIN public.user_group ON public.recipient_group.group_id = public.user_group.group_id;

CREATE OR REPLACE FUNCTION public.send_message(hasura_session json, title text, content text, recipient_users integer[], recipient_groups integer[])
 RETURNS SETOF messages
 LANGUAGE plpgsql
AS $function$
DECLARE
  message_id integer;
  recipient_id integer;
BEGIN
  INSERT INTO public.messages (title, content, sender_id)
  VALUES (title, content, (hasura_session ->> 'X-Hasura-User-Id')) RETURNING id INTO message_id;
 
  FOREACH recipient_id IN ARRAY recipient_users
  LOOP
    INSERT INTO public.recipient_user (message_id, user_id)
    VALUES (message_id, recipient_id);
  END LOOP;
 
  FOREACH recipient_id IN ARRAY recepient_groups
  LOOP
    INSERT INTO public.recipient_group (message_id, group_id)
    VALUES (message_id, recipient_id);
  END LOOP;

  RETURN QUERY SELECT * FROM public.messages WHERE id=message_id;
END;
$function$;
