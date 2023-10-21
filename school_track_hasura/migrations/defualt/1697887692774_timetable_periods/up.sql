
CREATE TABLE "public"."lesson_periods" ("id" serial NOT NULL, "start" time NOT NULL, "length" interval NOT NULL, PRIMARY KEY ("id") );

CREATE TABLE "public"."lessons" ("id" serial NOT NULL, "period_id" integer NOT NULL, "class_id" integer NOT NULL, "weekday" integer NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("period_id") REFERENCES "public"."lesson_periods"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("class_id") REFERENCES "public"."classes"("id") ON UPDATE restrict ON DELETE restrict);
