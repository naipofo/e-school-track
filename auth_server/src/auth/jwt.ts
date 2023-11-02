import { SignJWT } from "jose";
import { db } from "src/database";

const secret = new TextEncoder().encode(
  "oursupersecretsupersecurekey1234567890",
);
const alg = "HS256";

export async function makeJwt(userId: number & { __brand: "UsersId" }) {
  const isAdmin = (
    await db
      .selectFrom("admins")
      .select(["user_id"])
      .where("user_id", "=", userId)
      .execute()
  ).length > 0;

  const isTeacher = (
    await db.selectFrom("classes").select(["teacher_id"]).execute()
  )
    .map((e) => e.teacher_id)
    .includes(userId);

  const role = isAdmin ? "admin" : isTeacher ? "teacher" : "student";

  return await new SignJWT({
    "https://hasura.io/jwt/claims": {
      "x-hasura-default-role": role,
      "x-hasura-allowed-roles": [role],
      "X-Hasura-User-Id": userId.toString(),
    },
  })
    .setProtectedHeader({ alg })
    .sign(secret);
}
