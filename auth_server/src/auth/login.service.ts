import { HttpException, HttpStatus, Injectable } from "@nestjs/common";
import { compare, hash as bHash } from "bcrypt";
import { db } from "../database";
import { makeJwt } from "./jwt";

@Injectable()
export class LoginService {
  async getAccountData(username: string) {
    const results = await db
      .selectFrom("auth")
      .select(["user_id", "hash", "temporary"])
      .where("nickname", "=", username)
      .selectAll()
      .execute();

    if (results.length == 0) {
      throw new HttpException("Account not found", HttpStatus.NOT_FOUND);
    }

    return results[0];
  }

  async login(username: string, password: string) {
    const { hash, user_id, temporary } = await this.getAccountData(username);

    if (temporary && hash == password) {
      throw new HttpException("Temporary password", HttpStatus.FORBIDDEN);
    } else if (temporary || !(await compare(password, hash))) {
      throw new HttpException("Wrong password", HttpStatus.UNAUTHORIZED);
    }

    const isAdmin = (
      await db
        .selectFrom("admins")
        .select(["user_id"])
        .where("user_id", "=", user_id)
        .execute()
    ).length > 0;

    const isTeacher = (
      await db.selectFrom("classes").select(["teacher_id"]).execute()
    )
      .map((e) => e.teacher_id)
      .includes(user_id);

    // TODO: teachers

    return await makeJwt(user_id, isAdmin ? "admin" : isTeacher ? "teacher" : "student");
  }

  async setTemp(username: string, tempPassword: string, newPassword: string) {
    const { hash, user_id, temporary } = await this.getAccountData(username);
    if (!temporary) {
      throw new HttpException("Not a temporary password", HttpStatus.FORBIDDEN);
    } else if (hash != tempPassword) {
      throw new HttpException("Wrong password", HttpStatus.UNAUTHORIZED);
    }
    db.updateTable("auth")
      .set({ temporary: false, hash: await bHash(newPassword, 12) })
      .where("user_id", "=", user_id)
      .execute();
  }
}
