
CREATE TABLE "public"."users" ("id" serial NOT NULL, "first_name" text NOT NULL, "last_name" text NOT NULL, PRIMARY KEY ("id") );

CREATE TABLE "public"."subjects" ("id" serial NOT NULL, "title" text NOT NULL, PRIMARY KEY ("id") );

CREATE TABLE "public"."groups" ("id" serial NOT NULL, "name" text NOT NULL, PRIMARY KEY ("id") );

CREATE TABLE "public"."user_group" ("id" serial NOT NULL, "user_id" integer NOT NULL, "group_id" integer NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON UPDATE restrict ON DELETE restrict);

CREATE TABLE "public"."classes" ("id" serial NOT NULL, "group_id" integer NOT NULL, "subject_id" integer NOT NULL, "teacher_id" integer, PRIMARY KEY ("id") , FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("subject_id") REFERENCES "public"."subjects"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("teacher_id") REFERENCES "public"."users"("id") ON UPDATE restrict ON DELETE restrict);

alter table "public"."groups" add column "homeroom_teacher_id" integer
 null;

alter table "public"."groups"
  add constraint "groups_homeroom_teacher_id_fkey"
  foreign key ("homeroom_teacher_id")
  references "public"."users"
  ("id") on update restrict on delete restrict;

CREATE TABLE "public"."grades" ("id" serial NOT NULL, "value" integer NOT NULL, "weight" integer NOT NULL DEFAULT 1, "comment" text, "class_id" integer NOT NULL, "teacher_id" integer NOT NULL, "student_id" integer NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("class_id") REFERENCES "public"."classes"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("teacher_id") REFERENCES "public"."users"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("student_id") REFERENCES "public"."users"("id") ON UPDATE restrict ON DELETE restrict);
