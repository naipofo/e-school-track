import { HttpException, HttpStatus, Injectable } from "@nestjs/common";
import { compare } from "bcrypt";
import { db } from "./database";
import { makeJwt } from "./jwt";

@Injectable()
export class LoginService {
  async login(username: string, password: string) {
    const { hash, user_id } = await db
      .selectFrom("auth")
      .select(["user_id", "hash"])
      .where("nickname", "=", username)
      .selectAll()
      .executeTakeFirstOrThrow();

    console.log(password, hash);
    if (!(await compare(password, hash))) {
      throw new HttpException("Unauthorized", HttpStatus.UNAUTHORIZED);
    }

    const isAdmin = (
      await db
        .selectFrom("admins")
        .select(["user_id"])
        .where("user_id", "=", user_id)
        .execute()
    ).length > 0;

    // TODO: teachers

    return await makeJwt(user_id, isAdmin ? "admin" : "student");
  }
}
