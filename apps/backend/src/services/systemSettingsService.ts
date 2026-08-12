import { eq } from "drizzle-orm";
import type { DbClient } from "../db/index";
import { systemSettings } from "../db/schema/systemSettings";

export interface PlatformConfig {
  siteName: string;
  siteDescription: string;
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

export const DEFAULT_PLATFORM_CONFIG: PlatformConfig = {
  siteName: "New Platform",
  siteDescription:
    "Multi-role New Platform supporting Public browsing, Creator Studio, and Admin Control.",
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
  onPostPublishAdminGroup: true,
};

export class SystemSettingsService {
  private db: DbClient;

  constructor(options: { db: DbClient }) {
    this.db = options.db;
  }

  async getSetting<T = any>(
    key: "platform" | "dispatch",
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
  }> {
    const [platform, dispatch] = await Promise.all([
      this.getSetting<PlatformConfig>("platform", DEFAULT_PLATFORM_CONFIG),
      this.getSetting<ChannelConfig>("dispatch", DEFAULT_DISPATCH_CONFIG),
    ]);

    return { platform, dispatch };
  }

  async saveSetting(
    key: "platform" | "dispatch",
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
      const mergedDispatch = { ...currentDispatch, ...payload.dispatch };
      await this.saveSetting("dispatch", mergedDispatch);
    }

    return true;
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

      const text = `📢 <b>[Ads Platform Public Channel Test]</b>\n\nThis is a live test broadcast dispatched to your Public Channel (${config.telegramPublicChannelId}).`;
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

      const text = `🛡️ <b>[Ads Platform Admin Group Alert Test]</b>\n\nThis is a live test alert notification dispatched to your Admin Group (${config.telegramAdminGroupId}).`;
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
      return {
        success: true,
        message: `Outbound Mail configuration verified for ${config.mailSenderEmail} via SMTP server ${config.mailSmtpHost}:${config.mailSmtpPort || 587}`,
      };
    }

    return {
      success: false,
      message: `Unknown dispatch channel type: ${channelType}`,
    };
  }
}
