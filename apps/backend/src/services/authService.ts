import bcrypt from "bcryptjs";
import { eq, or } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { users } from "../db/schema/index";
import { generateToken } from "../utils/jwt";

export class AuthService {
  constructor(private db: DbClient) {}

  async register(
    username: string,
    email: string,
    password: string,
    role: "ADMIN" | "CREATOR" = "CREATOR",
    avatar?: string,
    jwtSecret: string = "fallback-secret",
    portfolioLink?: string,
    country?: string,
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
      avatar,
      portfolioLink,
      country,
      role,
      status: "ACTIVE",
    });

    const token = await generateToken({ id: userId, email, role }, jwtSecret);
    return {
      user: { id: userId, username, email, avatar, portfolioLink, country, role, status: "ACTIVE" },
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
        avatar: user.avatar,
        role: user.role,
        status: user.status,
      },
      token,
    };
  }

  async googleLogin(idToken: string, jwtSecret: string) {
    const res = await fetch(
      `https://oauth2.googleapis.com/tokeninfo?id_token=${encodeURIComponent(idToken)}`,
    );
    if (!res.ok) {
      throw new Error("Invalid Google ID token");
    }
    const payload = (await res.json()) as {
      email?: string;
      name?: string;
      picture?: string;
      sub?: string;
    };
    if (!payload.email) {
      throw new Error("Google account email not found");
    }

    const email = payload.email;
    let user = await this.db
      .select()
      .from(users)
      .where(eq(users.email, email))
      .get();

    if (!user) {
      const userId = crypto.randomUUID();
      const emailPrefix = email.split("@")[0] || "user";
      const baseUsername = emailPrefix.replace(/[^a-zA-Z0-9_]/g, "");
      const username = `${baseUsername}_${crypto.randomUUID().slice(0, 6)}`;
      const salt = await bcrypt.genSalt(10);
      const passwordHash = await bcrypt.hash(crypto.randomUUID(), salt);

      await this.db.insert(users).values({
        id: userId,
        username,
        email,
        passwordHash,
        avatar: payload.picture,
        role: "CREATOR",
        status: "ACTIVE",
      });

      user = {
        id: userId,
        username,
        email,
        passwordHash,
        avatar: payload.picture || null,
        portfolioLink: null,
        country: null,
        apiKeys: null,
        role: "CREATOR",
        status: "ACTIVE",
        createdAt: new Date(),
        updatedAt: new Date(),
      };
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
        avatar: user.avatar,
        role: user.role,
        status: user.status,
      },
      token,
    };
  }
}

