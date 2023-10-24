use diesel::prelude::*;

#[derive(Queryable, Selectable, Debug)]
#[diesel(table_name = crate::schema::users)]
pub struct User {
    pub id: i32,
    pub first_name: String,
    pub last_name: String,
}
