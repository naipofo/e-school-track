import { Body, Controller, Post } from "@nestjs/common";
import { LoginDto } from "./login.dto";
import { LoginService } from "./login.service";
import { UpdateTemporary } from "./update-temporary.dto";

@Controller()
export class LoginController {
  constructor(private readonly appService: LoginService) {}

  @Post("login")
  async login(@Body() { username, password }: LoginDto): Promise<string> {
    const userId = await this.appService.login(username, password);
    return userId.toString();
  }

  @Post("temporary")
  async temporary(@Body() { username, tempPassword, newPassword }: UpdateTemporary): Promise<void> {
    await this.appService.setTemp(username, tempPassword, newPassword);
  }
}
