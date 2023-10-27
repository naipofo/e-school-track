import { HttpException, HttpStatus, Injectable } from "@nestjs/common";
import { compare } from "bcrypt";
import { db } from "../database";
import { makeJwt } from "./jwt";

@Injectable()
export class LoginService {
  async login(username: string, password: string) {
    const results = await db
      .selectFrom("auth")
      .select(["user_id", "hash"])
      .where("nickname", "=", username)
      .selectAll()
      .execute();

    if (results.length == 0) {
      throw new HttpException("Account not found", HttpStatus.NOT_FOUND);
    }

    const { hash, user_id } = results[0];

    if (!(await compare(password, hash))) {
      throw new HttpException("Wrong password", HttpStatus.UNAUTHORIZED);
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
