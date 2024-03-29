# Project setup

1. To start docker services:

```sh
docker-compose -p posther up -d
```

2. Navigate to http://172.18.0.1:8080 and setup a postgresql database with the name `defualt` and connection via PG_DATABASE_URL
3. In the `school_track_hasura` directory, run:

```sh
hasura migrate apply --admin-secret myadminsecretkey --endpoint http://172.18.0.1:8080
hasura metadata apply --admin-secret myadminsecretkey --endpoint http://172.18.0.1:8080
```

4. In the root directory run `bash generate.sh`
5. In the `auth_server` direcotry run

```sh
npm i
npm run start
```

6. In the root directory run `bash generate.sh` again
6. In the `school_track_front` direcotry run

```sh
flutter pub get
flutter pub run build_runner build
```

You can run the app with `flutter run`.
Run this in the hasura directiory to access the console:
```sh
hasura console --admin-secret myadminsecretkey --endpoint http://172.18.0.1:8080 --address 127.0.0.1 --no-browser
```

To access the system, add a new acount, add a row in admins table and create a new temp password auth for that account.


After edting the schema run the generator script and `dart run build_runner build`