import { Body, Controller, Post } from "@nestjs/common";
import { LoginDto } from "./login.dto";
import { LoginService } from "./login.service";

@Controller()
export class LoginController {
  constructor(private readonly appService: LoginService) {}

  @Post("login")
  async login(@Body() { username, password }: LoginDto): Promise<string> {
    const userId = await this.appService.login(username, password);
    return userId.toString();
  }
}
