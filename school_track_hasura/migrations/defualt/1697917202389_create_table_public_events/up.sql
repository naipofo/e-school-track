CREATE TABLE "public"."events" ("id" serial NOT NULL, "class_id" integer NOT NULL, "user_id" integer NOT NULL, "date" date NOT NULL, "period_id" integer NOT NULL, "title" text NOT NULL, "comment" text NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("class_id") REFERENCES "public"."classes"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("period_id") REFERENCES "public"."lesson_periods"("id") ON UPDATE restrict ON DELETE restrict);