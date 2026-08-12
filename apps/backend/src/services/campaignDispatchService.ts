import type { DbClient } from "../db/index";
import {
  SystemSettingsService,
  DEFAULT_DISPATCH_CONFIG,
  DEFAULT_PLATFORM_CONFIG,
  type PlatformConfig,
} from "./systemSettingsService";
import { SubscriberService } from "./subscriberService";

export class CampaignDispatchService {
  private db: DbClient;
  private settingsService: SystemSettingsService;
  private subscriberService: SubscriberService;

  constructor(db: DbClient) {
    this.db = db;
    this.settingsService = new SystemSettingsService({ db });
    this.subscriberService = new SubscriberService(db);
  }

  async dispatchNewCampaignNotifications(campaign: {
    id: string;
    title: string;
    description?: string | null;
    imageUrl?: string | null;
    category?: string | null;
  }): Promise<{
    telegramPublicChannelSent: boolean;
    telegramAdminGroupSent: boolean;
    emailsSentCount: number;
  }> {
    const [config, platformConfig] = await Promise.all([
      this.settingsService.getSetting("dispatch", DEFAULT_DISPATCH_CONFIG),
      this.settingsService.getSetting<PlatformConfig>(
        "platform",
        DEFAULT_PLATFORM_CONFIG,
      ),
    ]);

    let telegramPublicChannelSent = false;
    let telegramAdminGroupSent = false;
    let emailsSentCount = 0;

    const siteBaseUrl = (platformConfig.siteUrl || "http://localhost:3000")
      .trim()
      .replace(/\/$/, "");
    const campaignUrl = `${siteBaseUrl}/article/${campaign.id}`;
    const summary = campaign.description
      ? campaign.description.replace(/<[^>]*>/g, "").slice(0, 180) + "..."
      : "Check out this new campaign post!";

    // 1. Telegram Public Channel Broadcast
    if (
      config.enablePublicChannel &&
      config.onPostPublishPublicChannel &&
      config.telegramBotToken &&
      config.telegramPublicChannelId
    ) {
      const text = `📢 <b>NEW CAMPAIGN PUBLISHED</b>\n\n<b>${campaign.title}</b>\n\n${summary}\n\n👉 <a href="${campaignUrl}">View Article</a>\n🔗 ${campaignUrl}`;
      const res = await this.settingsService.testDispatchChannel(
        "public_channel",
        {
          telegramBotToken: config.telegramBotToken,
          telegramPublicChannelId: config.telegramPublicChannelId,
          customMessage: text,
        } as any,
      );
      telegramPublicChannelSent = res.success;
    }

    // 2. Email Broadcast to All Active Subscribers
    if (
      config.enableMail &&
      config.onPostPublishMail &&
      config.mailSenderEmail
    ) {
      const subscriberEmails =
        await this.subscriberService.getAllActiveSubscribers();

      for (const subscriberEmail of subscriberEmails) {
        const res = await this.settingsService.testDispatchChannel("mail", {
          ...config,
          recipientEmail: subscriberEmail,
          customSubject: `📢 New Campaign: ${campaign.title}`,
          customMessage: `An exciting new campaign post has just been published on our platform!<br><br><b>${campaign.title}</b><br><p>${summary}</p><br><a href="${campaignUrl}">${campaignUrl}</a>`,
        } as any);

        if (res.success) {
          emailsSentCount++;
        }
      }
    }

    const dispatchResult = {
      telegramPublicChannelSent,
      telegramAdminGroupSent,
      emailsSentCount,
    };

    console.log("[CampaignDispatch] Completed broadcast:", {
      campaignId: campaign.id,
      title: campaign.title,
      configCheck: {
        enablePublicChannel: config.enablePublicChannel,
        onPostPublishPublicChannel: config.onPostPublishPublicChannel,
        hasBotToken: Boolean(config.telegramBotToken),
        hasChannelId: Boolean(config.telegramPublicChannelId),
        enableMail: config.enableMail,
        onPostPublishMail: config.onPostPublishMail,
      },
      result: dispatchResult,
    });

    return dispatchResult;
  }

  async dispatchUserRegistrationNotifications(user: {
    id: string;
    username: string;
    email: string;
    role: string;
  }): Promise<{
    telegramAdminGroupSent: boolean;
    mailSent: boolean;
  }> {
    const config = await this.settingsService.getSetting(
      "dispatch",
      DEFAULT_DISPATCH_CONFIG,
    );

    let telegramAdminGroupSent = false;
    let mailSent = false;

    // 1. Alert to Admin Telegram Group (Option 2)
    if (
      config.enableAdminGroupAlerts &&
      config.onUserSubmitAdminGroup &&
      config.telegramBotToken &&
      config.telegramAdminGroupId
    ) {
      const text = `👤 <b>[NEW USER REGISTRATION]</b>\n\nUsername: <b>${user.username}</b>\nEmail: <code>${user.email}</code>\nRole: <code>${user.role}</code>\nID: <code>${user.id}</code>`;
      const res = await this.settingsService.testDispatchChannel(
        "admin_group",
        {
          telegramBotToken: config.telegramBotToken,
          telegramAdminGroupId: config.telegramAdminGroupId,
          customMessage: text,
        } as any,
      );
      telegramAdminGroupSent = res.success;
    }

    // 2. Alert via Mail (if onUserSubmitMail is enabled)
    if (
      config.enableMail &&
      config.onUserSubmitMail &&
      config.mailSenderEmail
    ) {
      const res = await this.settingsService.testDispatchChannel("mail", {
        ...config,
        recipientEmail: config.mailSenderEmail,
        customSubject: `👤 New User Registration: ${user.username}`,
        customMessage: `A new user has just registered on the platform!<br><br><b>Username:</b> ${user.username}<br><b>Email:</b> ${user.email}<br><b>Role:</b> ${user.role}<br><b>User ID:</b> ${user.id}`,
      } as any);
      mailSent = res.success;
    }

    console.log("[UserDispatch] Completed registration dispatch:", {
      userId: user.id,
      username: user.username,
      result: { telegramAdminGroupSent, mailSent },
    });

    return { telegramAdminGroupSent, mailSent };
  }
}
