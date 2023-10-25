
CREATE TABLE "public"."parents" ("user_id" integer NOT NULL, "overseen_id" integer NOT NULL, PRIMARY KEY ("user_id") , FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("overseen_id") REFERENCES "public"."users"("id") ON UPDATE restrict ON DELETE restrict);

CREATE TABLE "public"."admins" ("user_id" integer NOT NULL, PRIMARY KEY ("user_id") , FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE restrict ON DELETE restrict);

CREATE TABLE "public"."auth" ("user_id" integer NOT NULL, "nickname" text NOT NULL, "hash" text NOT NULL, "temporary" boolean NOT NULL DEFAULT true, PRIMARY KEY ("user_id") , FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE restrict ON DELETE restrict);
