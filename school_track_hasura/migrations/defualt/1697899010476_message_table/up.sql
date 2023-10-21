CREATE TABLE "public"."messages" ("id" serial NOT NULL, "sender_id" integer NOT NULL, "recipient_id" integer NOT NULL, "read_receipt" boolean NOT NULL DEFAULT false, "title" text NOT NULL, "content" text NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("sender_id") REFERENCES "public"."users"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("recipient_id") REFERENCES "public"."users"("id") ON UPDATE restrict ON DELETE restrict);

alter table "public"."messages" add column "sent_on" timestamptz
 not null default now();
