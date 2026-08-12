import type { DbClient } from "../db/index";
import { SystemSettingsService, DEFAULT_DISPATCH_CONFIG } from "./systemSettingsService";
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
    const config = await this.settingsService.getSetting(
      "dispatch",
      DEFAULT_DISPATCH_CONFIG
    );

    let telegramPublicChannelSent = false;
    let telegramAdminGroupSent = false;
    let emailsSentCount = 0;

    const campaignUrl = `http://localhost:3000/campaigns/${campaign.id}`;
    const summary = campaign.description
      ? campaign.description.slice(0, 180) + "..."
      : "Check out this new campaign post!";

    // 1. Telegram Public Channel Broadcast
    if (
      config.enablePublicChannel &&
      config.onPostPublishPublicChannel &&
      config.telegramBotToken &&
      config.telegramPublicChannelId
    ) {
      const text = `📢 <b>NEW CAMPAIGN PUBLISHED</b>\n\n<b>${campaign.title}</b>\n\n${summary}\n\n👉 <a href="${campaignUrl}">View Full Campaign</a>`;
      const res = await this.settingsService.testDispatchChannel("public_channel", {
        telegramBotToken: config.telegramBotToken,
        telegramPublicChannelId: config.telegramPublicChannelId,
        customMessage: text,
      } as any);
      telegramPublicChannelSent = res.success;
    }

    // 2. Telegram Admin Group Alert
    if (
      config.enableAdminGroupAlerts &&
      config.onPostPublishAdminGroup &&
      config.telegramBotToken &&
      config.telegramAdminGroupId
    ) {
      const text = `🛡️ <b>[ADMIN ALERT] New Post Created</b>\n\nTitle: <b>${campaign.title}</b>\nID: <code>${campaign.id}</code>`;
      const res = await this.settingsService.testDispatchChannel("admin_group", {
        telegramBotToken: config.telegramBotToken,
        telegramAdminGroupId: config.telegramAdminGroupId,
        customMessage: text,
      } as any);
      telegramAdminGroupSent = res.success;
    }

    // 3. Email Broadcast to All Active Subscribers
    if (config.enableMail && config.onPostPublishMail && config.mailSenderEmail) {
      const subscriberEmails = await this.subscriberService.getAllActiveSubscribers();

      for (const subscriberEmail of subscriberEmails) {
        const res = await this.settingsService.testDispatchChannel("mail", {
          ...config,
          recipientEmail: subscriberEmail,
          customSubject: `📢 New Campaign: ${campaign.title}`,
          customMessage: `An exciting new campaign post has just been published on our platform!<br><br><b>${campaign.title}</b><br><p>${summary}</p><br><a href="${campaignUrl}">Read More on Platform</a>`,
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
}
