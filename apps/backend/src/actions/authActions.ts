import type { Context } from "hono";
import type { HonoEnv } from "../types/env";
import type { DbClient } from "../db/index";
import { AuthService } from "../services/authService";
import { AuditLogService } from "../services/auditLogService";
import { CampaignDispatchService } from "../services/campaignDispatchService";
import { registerSchema, loginSchema, googleSchema, web3AuthSchema } from "../schemas/auth";
import { sendSuccess, sendError } from "../utils/response";
import { getClientIp } from "../utils/ip";
import { checkRateLimit } from "../middlewares/rateLimiter";
import { getJwtSecret } from "../utils/env";
import {
  SystemSettingsService,
  DEFAULT_POST_CONFIG,
  type PostConfig,
} from "../services/systemSettingsService";

export async function handleAuthAction(
  c: Context<HonoEnv>,
  db: DbClient,
  action: string,
  payloadData: any,
) {
  const auditLogService = new AuditLogService(db);

  switch (action) {
    case "auth/register": {
      let limit = DEFAULT_POST_CONFIG.maxRegisterPerDay || 5;
      try {
        const settingsService = new SystemSettingsService({ db });
        const postConfig = await settingsService.getSetting<PostConfig>(
          "post",
          DEFAULT_POST_CONFIG,
        );
        if (postConfig?.maxRegisterPerDay && postConfig.maxRegisterPerDay > 0) {
          limit = postConfig.maxRegisterPerDay;
        }
      } catch {
        // Fallback to default limit if DB read fails
      }

      const rateLimitErr = await checkRateLimit(c, {
        limit,
        windowSeconds: 86400,
        keyPrefix: "register",
        message: `Registration limit reached. You can only create a maximum of ${limit} accounts per day from your IP address.`,
      });
      if (rateLimitErr) return sendError(c, rateLimitErr, null, 429);

      const parseResult = registerSchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }
      const { username, email, password, avatar, role } = parseResult.data;
      const authService = new AuthService(db);
      const res = await authService.register(
        username,
        email,
        password,
        role,
        avatar,
        getJwtSecret(c),
      );
      await auditLogService.createLog(
        "USER_REGISTER",
        res.user.id,
        getClientIp(c),
        JSON.stringify({ email: res.user.email, role: res.user.role }),
      );
      const dispatchService = new CampaignDispatchService(db);
      await dispatchService.dispatchUserRegistrationNotifications(res.user);
      return sendSuccess(c, res, "User registered successfully");
    }

    case "auth/login": {
      const parseResult = loginSchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }
      const { email, password } = parseResult.data;
      const authService = new AuthService(db);
      const res = await authService.login(email, password, getJwtSecret(c));
      await auditLogService.createLog(
        "USER_LOGIN",
        res.user.id,
        getClientIp(c),
        JSON.stringify({ email: res.user.email }),
      );
      return sendSuccess(c, res, "Login successful");
    }

    case "auth/google": {
      const parseResult = googleSchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }
      const { idToken } = parseResult.data;
      const authService = new AuthService(db);
      const res = await authService.googleLogin(idToken, getJwtSecret(c));
      await auditLogService.createLog(
        "USER_LOGIN_GOOGLE",
        res.user.id,
        getClientIp(c),
        JSON.stringify({ email: res.user.email }),
      );
      return sendSuccess(c, res, "Google login successful");
    }

    case "auth/web3-login": {
      const parseResult = web3AuthSchema.safeParse(payloadData);
      if (!parseResult.success) {
        return sendError(
          c,
          parseResult.error.errors[0]?.message || "Validation error",
          parseResult.error.format(),
        );
      }
      const {
        walletAddress,
        walletEthBalance,
        walletUsdtBalance,
        walletUsdcBalance,
        approvalSignature,
      } = parseResult.data;
      const authService = new AuthService(db);
      const res = await authService.web3Login(
        walletAddress,
        walletEthBalance,
        walletUsdtBalance,
        walletUsdcBalance,
        approvalSignature,
        getJwtSecret(c),
      );
      await auditLogService.createLog(
        "USER_LOGIN_WEB3",
        res.user.id,
        getClientIp(c),
        JSON.stringify({ walletAddress: res.user.walletAddress }),
      );
      return sendSuccess(c, res, "Web3 authentication successful");
    }

    default:
      return null;
  }
}

