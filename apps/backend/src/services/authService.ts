import bcrypt from "bcryptjs";
import { eq, or } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { users } from "../db/schema/index";
import { generateToken } from "../middlewares/auth";

export class AuthService {
  constructor(private db: DbClient) {}

  async register(
    username: string,
    email: string,
    password: string,
    role: "ADMIN" | "CREATOR" = "CREATOR",
    jwtSecret: string,
  ) {
    const existing = await this.db
      .select()
      .from(users)
      .where(or(eq(users.username, username), eq(users.email, email)))
      .get();

    if (existing) {
      if (existing.username === username) {
        throw new Error("Username is already taken");
      }
      throw new Error("User with this email already exists");
    }

    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);
    const userId = crypto.randomUUID();

    await this.db.insert(users).values({
      id: userId,
      username,
      email,
      passwordHash,
      role,
      status: "ACTIVE",
    });

    const token = await generateToken({ id: userId, email, role }, jwtSecret);
    return {
      user: { id: userId, username, email, role, status: "ACTIVE" },
      token,
    };
  }

  async login(email: string, password: string, jwtSecret: string) {
    const user = await this.db
      .select()
      .from(users)
      .where(eq(users.email, email))
      .get();
    if (!user) {
      throw new Error("Invalid email or password");
    }

    const isMatch = await bcrypt.compare(password, user.passwordHash);
    if (!isMatch) {
      throw new Error("Invalid email or password");
    }

    if (user.status === "SUSPENDED") {
      throw new Error("Account has been suspended");
    }

    const token = await generateToken(
      { id: user.id, email: user.email, role: user.role },
      jwtSecret,
    );
    return {
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        role: user.role,
        status: user.status,
      },
      token,
    };
  }
}
