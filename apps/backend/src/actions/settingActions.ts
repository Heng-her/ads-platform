import type { Context } from "hono";
import type { DbClient } from "../db/index";
import type { UserJwtPayload } from "../types/env";
import { SystemSettingsService } from "../services/systemSettingsService";
import { encryptData } from "../utils/crypto";

export interface SettingActionOptions {
  c?: Context<any>;
  db: DbClient;
  action: string;
  data: any;
  currentUser?: UserJwtPayload | null;
}

export async function handleSettingAction({
  action,
  data,
  currentUser,
  db,
}: SettingActionOptions): Promise<any> {
  const service = new SystemSettingsService({ db });

  if (action === "settings/get-all") {
    const settings = await service.getAllSettings();

    const responsePayload =
      !currentUser || currentUser.role !== "ADMIN"
        ? {
            platform: settings.platform,
            post: settings.post,
            googleauth: {
              googleClientId: settings.googleauth.googleClientId,
              enableGoogleAuth: settings.googleauth.enableGoogleAuth,
              googleClientSecret: "", // Omit secret key for non-admins
            },
            upload: {
              uploadApiBaseUrl: settings.upload.uploadApiBaseUrl,
              uploadApiKey: "", // Omit API key for non-admins
              uploadApiBypassSecret: "", // Omit bypass secret for non-admins
            },
            dispatch: {
              enablePublicChannel: settings.dispatch.enablePublicChannel,
              enableAdminGroupAlerts: settings.dispatch.enableAdminGroupAlerts,
              enableMail: settings.dispatch.enableMail,
              mailSenderEmail: settings.dispatch.mailSenderEmail,
              telegramBotToken: "",
              telegramPublicChannelId: "",
              telegramAdminGroupId: "",
              mailSmtpHost: "",
              mailSmtpPort: 0,
              mailSmtpUser: "",
              mailSmtpPassword: "",
              onUserSubmitMail: false,
              onUserSubmitAdminGroup: false,
              onPostPublishMail: false,
              onPostPublishPublicChannel: false,
              onPostPublishAdminGroup: false,
            },
            security: {
              creatorDeletionPassword: "",
            },
          }
        : settings;

    // Encrypt response data payload using AES encryption
    const encryptedString = encryptData(responsePayload);

    return {
      code: 1,
      msg: "System settings fetched successfully.",
      encrypted: true,
      data: encryptedString,
    };
  }

  if (action === "settings/save-platform") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    const platform = data?.platform || data;
    if (!platform || typeof platform !== "object") {
      return { code: 0, msg: "Invalid platform configuration payload." };
    }

    await service.saveSetting("platform", platform);
    return {
      code: 1,
      msg: "Platform settings saved successfully.",
    };
  }

  if (action === "settings/save-dispatch") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    const dispatch = data?.dispatch || data;
    if (!dispatch || typeof dispatch !== "object") {
      return { code: 0, msg: "Invalid dispatch configuration payload." };
    }

    await service.saveSetting("dispatch", dispatch);
    return {
      code: 1,
      msg: "Dispatch channel settings saved successfully.",
    };
  }

  if (action === "settings/save-post") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    const post = data?.post || data;
    if (!post || typeof post !== "object") {
      return { code: 0, msg: "Invalid post configuration payload." };
    }

    await service.saveSetting("post", post);
    return {
      code: 1,
      msg: "Post campaign settings saved successfully.",
    };
  }

  if (action === "settings/save-googleauth") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    const googleauth = data?.googleauth || data;
    if (!googleauth || typeof googleauth !== "object") {
      return { code: 0, msg: "Invalid Google auth configuration payload." };
    }

    await service.saveSetting("googleauth", googleauth);
    return {
      code: 1,
      msg: "Google auth settings saved successfully.",
    };
  }

  if (action === "settings/save-upload") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    const upload = data?.upload || data;
    if (!upload || typeof upload !== "object") {
      return { code: 0, msg: "Invalid Upload API configuration payload." };
    }

    await service.saveSetting("upload", upload);
    return {
      code: 1,
      msg: "Upload API settings saved successfully.",
    };
  }

  if (action === "settings/save-all") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    await service.saveAllSettings({
      platform: data?.platform,
      dispatch: data?.dispatch,
      post: data?.post,
      security: data?.security,
      googleauth: data?.googleauth,
      upload: data?.upload,
    });

    return {
      code: 1,
      msg: "All system settings saved successfully.",
    };
  }

  if (action === "settings/test-upload") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    const configPayload = data?.upload || data || {};
    const testResult = await service.testUploadServer(configPayload);
    return {
      code: testResult.success ? 1 : 0,
      msg: testResult.message,
      data: testResult,
    };
  }


  if (action === "settings/test-dispatch") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    const { channelType, config } = data || {};
    if (!channelType) {
      return { code: 0, msg: "Missing channelType parameter." };
    }

    const configPayload = {
      ...(config || {}),
      recipientEmail: data?.recipientEmail,
      customSubject: data?.customSubject,
      customMessage: data?.customMessage,
    };
    const testResult = await service.testDispatchChannel(channelType, configPayload);
    return {
      code: testResult.success ? 1 : 0,
      msg: testResult.message,
      data: testResult,
    };
  }

  return { code: 0, msg: `Unknown setting action: ${action}` };
}
