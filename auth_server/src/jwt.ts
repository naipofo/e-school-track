import { SignJWT } from "jose";

const secret = new TextEncoder().encode(
  "oursupersecretsupersecurekey1234567890",
);
const alg = "HS256";

export async function makeJwt(userId: number, role: string) {
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
