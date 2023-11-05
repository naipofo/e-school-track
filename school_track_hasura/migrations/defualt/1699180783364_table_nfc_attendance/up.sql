CREATE TABLE "public"."nfc_attendance" ("id" serial NOT NULL, "user_id" integer NOT NULL, "class_id" integer NOT NULL, "date" date NOT NULL, "period_id" integer NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("class_id") REFERENCES "public"."classes"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("period_id") REFERENCES "public"."lesson_periods"("id") ON UPDATE restrict ON DELETE restrict);