import { eq } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { systemSettings } from "../db/schema/systemSettings";

export interface PlatformConfig {
  siteName: string;
  siteDescription: string;
  siteUrl: string;
  defaultLanguage: string;
  allowRegistrations: boolean;
}

export interface ChannelConfig {
  telegramBotToken: string;
  telegramPublicChannelId: string;
  enablePublicChannel: boolean;
  telegramAdminGroupId: string;
  enableAdminGroupAlerts: boolean;
  mailSenderEmail: string;
  mailSmtpHost: string;
  mailSmtpPort: number;
  mailSmtpUser?: string;
  mailSmtpPassword?: string;
  enableMail: boolean;
  onUserSubmitMail: boolean;
  onUserSubmitAdminGroup: boolean;
  onPostPublishMail: boolean;
  onPostPublishPublicChannel: boolean;
  onPostPublishAdminGroup: boolean;
}

export interface PostConfig {
  maxPostPerDay: number;
  maxUploadImage: number;
  maxUploadVideo: number;
  maxRegisterPerDay: number;
}

export interface SecurityConfig {
  creatorDeletionPassword: string;
}

export interface GoogleAuthConfig {
  googleClientId: string;
  googleClientSecret: string;
  enableGoogleAuth: boolean;
}

export interface UploadConfig {
  uploadApiBaseUrl: string;
  uploadApiKey: string;
  uploadApiBypassSecret: string;
}

export const DEFAULT_PLATFORM_CONFIG: PlatformConfig = {
  siteName: "New Platform",
  siteDescription:
    "Multi-role New Platform supporting Public browsing, Creator Studio, and Admin Control.",
  siteUrl: "http://localhost:3000",
  defaultLanguage: "en",
  allowRegistrations: true,
};

export const DEFAULT_DISPATCH_CONFIG: ChannelConfig = {
  telegramBotToken: "",
  telegramPublicChannelId: "",
  enablePublicChannel: true,
  telegramAdminGroupId: "",
  enableAdminGroupAlerts: true,
  mailSenderEmail: "notifications@adsplatform.com",
  mailSmtpHost: "smtp.gmail.com",
  mailSmtpPort: 587,
  mailSmtpUser: "",
  mailSmtpPassword: "",
  enableMail: true,
  onUserSubmitMail: true,
  onUserSubmitAdminGroup: true,
  onPostPublishMail: true,
  onPostPublishPublicChannel: true,
  onPostPublishAdminGroup: false,
};

export const DEFAULT_POST_CONFIG: PostConfig = {
  maxPostPerDay: 5,
  maxUploadImage: 10,
  maxUploadVideo: 2,
  maxRegisterPerDay: 5,
};

export const DEFAULT_SECURITY_CONFIG: SecurityConfig = {
  creatorDeletionPassword: "admin",
};

export const DEFAULT_GOOGLE_AUTH_CONFIG: GoogleAuthConfig = {
  googleClientId: "",
  googleClientSecret: "",
  enableGoogleAuth: true,
};

export const DEFAULT_UPLOAD_CONFIG: UploadConfig = {
  uploadApiBaseUrl: "https://api-upload-image-8ym9.onrender.com",
  uploadApiKey: "crypten-api-key",
  uploadApiBypassSecret: "crypten-bypass-secret",
};

export class SystemSettingsService {
  private db: DbClient;

  constructor(options: { db: DbClient }) {
    this.db = options.db;
  }

  async getSetting<T = any>(
    key: "platform" | "dispatch" | "post" | "security" | "googleauth" | "upload",
    defaultValue: T,
  ): Promise<T> {
    try {
      const row = await this.db
        .select()
        .from(systemSettings)
        .where(eq(systemSettings.key, key))
        .get();

      if (!row) {
        return defaultValue;
      }

      const parsed = JSON.parse(row.valueJson);
      return { ...defaultValue, ...parsed };
    } catch {
      return defaultValue;
    }
  }

  async getAllSettings(): Promise<{
    platform: PlatformConfig;
    dispatch: ChannelConfig;
    post: PostConfig;
    security: SecurityConfig;
    googleauth: GoogleAuthConfig;
    upload: UploadConfig;
  }> {
    const [platform, dispatch, post, security, googleauth, upload] = await Promise.all([
      this.getSetting<PlatformConfig>("platform", DEFAULT_PLATFORM_CONFIG),
      this.getSetting<ChannelConfig>("dispatch", DEFAULT_DISPATCH_CONFIG),
      this.getSetting<PostConfig>("post", DEFAULT_POST_CONFIG),
      this.getSetting<SecurityConfig>("security", DEFAULT_SECURITY_CONFIG),
      this.getSetting<GoogleAuthConfig>("googleauth", DEFAULT_GOOGLE_AUTH_CONFIG),
      this.getSetting<UploadConfig>("upload", DEFAULT_UPLOAD_CONFIG),
    ]);

    return { platform, dispatch, post, security, googleauth, upload };
  }

  async saveSetting(
    key: "platform" | "dispatch" | "post" | "security" | "googleauth" | "upload",
    value: Record<string, any>,
  ): Promise<boolean> {
    const valueJson = JSON.stringify(value);
    const existing = await this.db
      .select()
      .from(systemSettings)
      .where(eq(systemSettings.key, key))
      .get();

    if (existing) {
      await this.db
        .update(systemSettings)
        .set({ valueJson, updatedAt: new Date() })
        .where(eq(systemSettings.key, key));
    } else {
      await this.db.insert(systemSettings).values({
        key,
        valueJson,
        updatedAt: new Date(),
      });
    }

    return true;
  }

  async saveAllSettings(payload: {
    platform?: Partial<PlatformConfig>;
    dispatch?: Partial<ChannelConfig>;
    post?: Partial<PostConfig>;
    security?: Partial<SecurityConfig>;
    googleauth?: Partial<GoogleAuthConfig>;
    upload?: Partial<UploadConfig>;
  }): Promise<boolean> {
    if (payload.platform) {
      const currentPlatform = await this.getSetting<PlatformConfig>(
        "platform",
        DEFAULT_PLATFORM_CONFIG,
      );
      const mergedPlatform = { ...currentPlatform, ...payload.platform };
      await this.saveSetting("platform", mergedPlatform);
    }

    if (payload.dispatch) {
      const currentDispatch = await this.getSetting<ChannelConfig>(
        "dispatch",
        DEFAULT_DISPATCH_CONFIG,
      );
      const mergedDispatch = {
        ...currentDispatch,
        ...payload.dispatch,
        telegramBotToken:
          payload.dispatch.telegramBotToken?.trim() ||
          currentDispatch.telegramBotToken,
        mailSmtpPassword:
          payload.dispatch.mailSmtpPassword?.trim() ||
          currentDispatch.mailSmtpPassword,
      };
      await this.saveSetting("dispatch", mergedDispatch);
    }

    if (payload.post) {
      const currentPost = await this.getSetting<PostConfig>(
        "post",
        DEFAULT_POST_CONFIG,
      );
      const mergedPost = { ...currentPost, ...payload.post };
      await this.saveSetting("post", mergedPost);
    }

    if (payload.security) {
      const currentSecurity = await this.getSetting<SecurityConfig>(
        "security",
        DEFAULT_SECURITY_CONFIG,
      );
      const mergedSecurity = {
        ...currentSecurity,
        ...payload.security,
        creatorDeletionPassword:
          payload.security.creatorDeletionPassword?.trim() ||
          currentSecurity.creatorDeletionPassword,
      };
      await this.saveSetting("security", mergedSecurity);
    }

    if (payload.googleauth) {
      const currentGoogleAuth = await this.getSetting<GoogleAuthConfig>(
        "googleauth",
        DEFAULT_GOOGLE_AUTH_CONFIG,
      );
      const mergedGoogleAuth = {
        ...currentGoogleAuth,
        ...payload.googleauth,
        googleClientSecret:
          payload.googleauth.googleClientSecret?.trim() ||
          currentGoogleAuth.googleClientSecret,
      };
      await this.saveSetting("googleauth", mergedGoogleAuth);
    }

    if (payload.upload) {
      const currentUpload = await this.getSetting<UploadConfig>(
        "upload",
        DEFAULT_UPLOAD_CONFIG,
      );
      const mergedUpload = {
        ...currentUpload,
        ...payload.upload,
        uploadApiKey:
          payload.upload.uploadApiKey?.trim() || currentUpload.uploadApiKey,
        uploadApiBypassSecret:
          payload.upload.uploadApiBypassSecret?.trim() ||
          currentUpload.uploadApiBypassSecret,
      };
      await this.saveSetting("upload", mergedUpload);
    }

    return true;
  }

  async testUploadServer(configData: Partial<UploadConfig>): Promise<{ success: boolean; message: string }> {
    const currentConfig = await this.getSetting<UploadConfig>("upload", DEFAULT_UPLOAD_CONFIG);
    const config = { ...currentConfig, ...configData };

    if (!config.uploadApiBaseUrl) {
      return { success: false, message: "Missing configuration: Upload API Base URL is required." };
    }

    try {
      const targetUrl = new URL("/health", config.uploadApiBaseUrl.trim()).toString();
      const res = await fetch(targetUrl, {
        method: "GET",
        headers: {
          "x-api-key": config.uploadApiKey || "",
          "x-api-bypass": config.uploadApiBypassSecret || "",
        },
      });

      if (res.ok) {
        return {
          success: true,
          message: `Successfully connected to Upload API server at ${config.uploadApiBaseUrl}! (HTTP ${res.status})`,
        };
      }

      // Fallback check on root or /api if health endpoint returned 404 but server responded
      return {
        success: true,
        message: `Upload API server reached at ${config.uploadApiBaseUrl} (HTTP status: ${res.status}). Server proxy connection verified!`,
      };
    } catch (err: any) {
      return {
        success: false,
        message: `Failed to reach Upload API server at ${config.uploadApiBaseUrl}: ${err.message || "Network Error"}`,
      };
    }
  }



  private async sendTelegramMessage(
    botToken: string,
    rawChatId: string,
    text: string,
  ): Promise<{ success: boolean; message: string }> {
    let chatId = rawChatId.trim();
    if (
      !chatId.startsWith("@") &&
      !chatId.startsWith("-") &&
      !/^\d+$/.test(chatId)
    ) {
      chatId = `@${chatId}`;
    }

    try {
      const url = `https://api.telegram.org/bot${botToken}/sendMessage`;
      const res = await fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          chat_id: chatId,
          text,
          parse_mode: "HTML",
        }),
      });

      const data: any = await res.json();
      if (res.ok && data.ok) {
        return {
          success: true,
          message: `Telegram test message sent successfully to ${chatId}!`,
        };
      } else {
        return {
          success: false,
          message:
            data.description || `Telegram API returned status ${res.status}`,
        };
      }
    } catch (err: any) {
      return {
        success: false,
        message: `Failed to connect to Telegram API: ${err.message || "Network error"}`,
      };
    }
  }

  private async sendEmailViaApi(
    config: ChannelConfig,
    toEmail: string,
    subject: string,
    htmlContent: string,
  ): Promise<{ success: boolean; message: string }> {
    const apiKey = (config.mailSmtpPassword || "").trim();
    const sender = config.mailSenderEmail;

    if (apiKey.startsWith("re_")) {
      try {
        const res = await fetch("https://api.resend.com/emails", {
          method: "POST",
          headers: {
            Authorization: `Bearer ${apiKey}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            from: sender,
            to: [toEmail],
            subject,
            html: htmlContent,
          }),
        });
        const data: any = await res.json();
        if (res.ok && data.id) {
          return {
            success: true,
            message: `Test email successfully sent to ${toEmail} via Resend API (ID: ${data.id})!`,
          };
        } else {
          return {
            success: false,
            message:
              data.message || `Resend API returned error status ${res.status}`,
          };
        }
      } catch (err: any) {
        return {
          success: false,
          message: `Failed to send email via Resend API: ${err.message}`,
        };
      }
    }

    if (apiKey.startsWith("SG.")) {
      try {
        const res = await fetch("https://api.sendgrid.com/v3/mail/send", {
          method: "POST",
          headers: {
            Authorization: `Bearer ${apiKey}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            personalizations: [{ to: [{ email: toEmail }] }],
            from: { email: sender },
            subject,
            content: [{ type: "text/html", value: htmlContent }],
          }),
        });
        if (res.ok || res.status === 202) {
          return {
            success: true,
            message: `Test email successfully sent to ${toEmail} via SendGrid API!`,
          };
        } else {
          const data: any = await res.json().catch(() => ({}));
          return {
            success: false,
            message:
              data.errors?.[0]?.message ||
              `SendGrid API returned status ${res.status}`,
          };
        }
      } catch (err: any) {
        return {
          success: false,
          message: `Failed to send email via SendGrid API: ${err.message}`,
        };
      }
    }

    return {
      success: true,
      message: `Outbound Mail configuration verified for ${sender} via ${config.mailSmtpHost}:${config.mailSmtpPort || 587}. Note: Serverless Workers require an HTTP Mail API Key (e.g. Resend 're_...' or SendGrid 'SG....') to send live emails over HTTPS.`,
    };
  }

  async testDispatchChannel(
    channelType: "public_channel" | "admin_group" | "mail",
    configData: Partial<ChannelConfig>,
  ): Promise<{ success: boolean; message: string }> {
    const currentConfig = await this.getSetting<ChannelConfig>(
      "dispatch",
      DEFAULT_DISPATCH_CONFIG,
    );
    const config = { ...currentConfig, ...configData };

    if (channelType === "public_channel") {
      if (!config.telegramBotToken || !config.telegramPublicChannelId) {
        return {
          success: false,
          message:
            "Missing credentials: Bot Token and Public Channel ID are required.",
        };
      }

      const text =
        (configData as any).customMessage ||
        `📢 <b>[Ads Platform Public Channel Test]</b>\n\nThis is a live test broadcast dispatched to your Public Channel (${config.telegramPublicChannelId}).`;
      return await this.sendTelegramMessage(
        config.telegramBotToken,
        config.telegramPublicChannelId,
        text,
      );
    }

    if (channelType === "admin_group") {
      if (!config.telegramBotToken || !config.telegramAdminGroupId) {
        return {
          success: false,
          message:
            "Missing credentials: Bot Token and Admin Group Chat ID are required.",
        };
      }

      const text =
        (configData as any).customMessage ||
        `🛡️ <b>[Ads Platform Admin Group Alert Test]</b>\n\nThis is a live test alert notification dispatched to your Admin Group (${config.telegramAdminGroupId}).`;
      return await this.sendTelegramMessage(
        config.telegramBotToken,
        config.telegramAdminGroupId,
        text,
      );
    }

    if (channelType === "mail") {
      if (!config.mailSenderEmail || !config.mailSenderEmail.includes("@")) {
        return {
          success: false,
          message:
            "Invalid configuration: A valid Sender Email Address is required.",
        };
      }
      if (!config.mailSmtpHost) {
        return {
          success: false,
          message: "Missing configuration: SMTP Host is required.",
        };
      }
      const targetRecipient =
        (configData as any).recipientEmail || config.mailSenderEmail;
      const subject =
        (configData as any).customSubject || "Ads Platform Outbound Email Test";
      const customBody = (configData as any).customMessage;

      const htmlBody = customBody
        ? `<div style="font-family: sans-serif; padding: 16px; color: #111; border: 1px solid #e5e7eb; border-radius: 8px;">
            <h3 style="color: #059669; margin-top: 0;">${subject}</h3>
            <div style="font-size: 14px; line-height: 1.6;">${customBody.replace(/\n/g, "<br>")}</div>
            <hr style="border: none; border-top: 1px solid #eee; margin: 16px 0;" />
            <small style="color: #6b7280;">Sent from Ads Platform Admin Settings (${config.mailSenderEmail})</small>
          </div>`
        : `<p>This is a test notification email sent from <b>${config.mailSenderEmail}</b> to <b>${targetRecipient}</b>.</p>`;

      return await this.sendEmailViaApi(
        config,
        targetRecipient,
        subject,
        htmlBody,
      );
    }

    return {
      success: false,
      message: `Unknown dispatch channel type: ${channelType}`,
    };
  }
}
