use diesel::{Connection, PgConnection, QueryDsl, RunQueryDsl, SelectableHelper};

use database_models::models::User;

fn main() {
    let database_url = "postgres://postgres:postgrespassword@localhost:5432/postgres";
    let mut connection = PgConnection::establish(database_url).unwrap();

    use database_models::schema::users::dsl::*;
    let results = users
        .limit(3)
        .select(User::as_select())
        .load(&mut connection)
        .unwrap();

    println!("{results:#?}");
}
