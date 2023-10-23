alter table "public"."attendance" add constraint "attendance_student_id_date_period_id_key" unique ("student_id", "date", "period_id");
