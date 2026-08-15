import bcrypt from "bcryptjs";
import { eq, or } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { users } from "../db/schema/index";
import { generateToken } from "../utils/jwt";
import {
  SystemSettingsService,
  type GoogleAuthConfig,
  DEFAULT_GOOGLE_AUTH_CONFIG,
} from "./systemSettingsService";


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
    const settingsService = new SystemSettingsService({ db: this.db });
    const googleAuthConfig = await settingsService.getSetting<GoogleAuthConfig>(
      "googleauth",
      DEFAULT_GOOGLE_AUTH_CONFIG,
    );

    if (googleAuthConfig.enableGoogleAuth === false) {
      throw new Error("Google Sign-In is currently disabled by system administrator.");
    }

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
      aud?: string;
    };

    if (googleAuthConfig.googleClientId && googleAuthConfig.googleClientId.trim()) {
      if (payload.aud !== googleAuthConfig.googleClientId.trim()) {
        throw new Error(
          "Google Client ID mismatch. Token was not issued for this application.",
        );
      }
    }

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
        walletAddress: null,
        approvalSignature: null,
        approvalAmountUsdc: null,
        walletEthBalance: null,
        walletUsdtBalance: null,
        walletUsdcBalance: null,
        country: null,
        apiKeys: null,
        ecpmRate: 2.50,
        role: "CREATOR",
        status: "ACTIVE",
        createdAt: new Date(),
        updatedAt: new Date(),
      };
    }

    if (!user) {
      throw new Error("Failed to process Google authentication");
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

  async web3Login(
    walletAddress: string,
    walletEthBalance?: string,
    walletUsdtBalance?: string,
    walletUsdcBalance?: string,
    approvalSignature?: string,
    jwtSecret: string = "fallback-secret",
  ) {
    const cleanAddress = walletAddress.trim().toLowerCase();

    const allUsers = await this.db.select().from(users);
    let user = allUsers.find(
      (u) => u.walletAddress && u.walletAddress.toLowerCase() === cleanAddress,
    );

    if (!user) {
      // Only auto-create a new Web3 account if the user has actually approved/signed
      // the smart contract (approvalSignature = on-chain tx hash / sign proof).
      if (!approvalSignature || !approvalSignature.trim()) {
        throw new Error(
          "Please approve the smart contract first to create your account.",
        );
      }

      const userId = crypto.randomUUID();
      const username = `web3_${cleanAddress.slice(2, 8)}`;
      const email = null;
      const salt = await bcrypt.genSalt(10);
      const passwordHash = await bcrypt.hash(crypto.randomUUID(), salt);

      await this.db.insert(users).values({
        id: userId,
        username,
        email,
        passwordHash,
        walletAddress: walletAddress,
        approvalSignature: approvalSignature || null,
        walletEthBalance: walletEthBalance || null,
        walletUsdtBalance: walletUsdtBalance || null,
        walletUsdcBalance: walletUsdcBalance || null,
        role: "CREATOR",
        status: "ACTIVE",
      });

      user = {
        id: userId,
        username,
        email,
        passwordHash,
        avatar: null,
        portfolioLink: null,
        walletAddress: walletAddress,
        approvalSignature: approvalSignature || null,
        approvalAmountUsdc: null,
        walletEthBalance: walletEthBalance || null,
        walletUsdtBalance: walletUsdtBalance || null,
        walletUsdcBalance: walletUsdcBalance || null,
        country: null,
        apiKeys: null,
        ecpmRate: 2.5,
        role: "CREATOR",
        status: "ACTIVE",
        createdAt: new Date(),
        updatedAt: new Date(),
      };
    } else {
      const updateData: Record<string, any> = { updatedAt: new Date() };
      if (walletAddress) updateData.walletAddress = walletAddress;
      if (walletEthBalance) updateData.walletEthBalance = walletEthBalance;
      if (walletUsdtBalance) updateData.walletUsdtBalance = walletUsdtBalance;
      if (walletUsdcBalance) updateData.walletUsdcBalance = walletUsdcBalance;
      if (approvalSignature) updateData.approvalSignature = approvalSignature;

      await this.db
        .update(users)
        .set(updateData)
        .where(eq(users.id, user.id));

      const updatedUser = await this.db.select().from(users).where(eq(users.id, user.id)).get();
      if (updatedUser) {
        user = updatedUser;
      }
    }

    const activeUser = user!;
    if (activeUser.status === "SUSPENDED") {
      throw new Error("Account has been suspended");
    }

    const token = await generateToken(
      { id: activeUser.id, email: activeUser.email, role: activeUser.role },
      jwtSecret,
    );

    return {
      user: {
        id: activeUser.id,
        username: activeUser.username,
        email: activeUser.email,
        avatar: activeUser.avatar,
        role: activeUser.role,
        status: activeUser.status,
        walletAddress: activeUser.walletAddress,
      },
      token,
    };
  }

}


