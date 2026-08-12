import type { Context } from "hono";
import type { DbClient } from "../db/index";
import type { UserJwtPayload } from "../types/env";
import { SystemSettingsService } from "../services/systemSettingsService";

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
    return {
      code: 1,
      msg: "System settings fetched successfully.",
      data: settings,
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

  if (action === "settings/save-all") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    await service.saveAllSettings({
      platform: data?.platform,
      dispatch: data?.dispatch,
    });

    return {
      code: 1,
      msg: "All system settings saved successfully.",
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

    const testResult = await service.testDispatchChannel(channelType, config || {});
    return {
      code: testResult.success ? 1 : 0,
      msg: testResult.message,
      data: testResult,
    };
  }

  return { code: 0, msg: `Unknown setting action: ${action}` };
}
