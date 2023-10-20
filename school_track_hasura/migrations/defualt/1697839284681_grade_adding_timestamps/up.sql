alter table "public"."grades" add column "added_on" timestamptz
 not null default now();
