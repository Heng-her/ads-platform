import { describe, it, expect, vi } from "vitest";
import {
  SystemSettingsService,
  DEFAULT_PLATFORM_CONFIG,
  DEFAULT_DISPATCH_CONFIG,
  DEFAULT_POST_CONFIG,
} from "../src/services/systemSettingsService";

describe("SystemSettingsService", () => {
  it("should return default platform, dispatch, and post settings when DB is empty", async () => {
    const mockDb: any = {
      select: () => ({
        from: () => ({
          where: () => ({
            get: async () => null,
          }),
        }),
      }),
    };

    const service = new SystemSettingsService({ db: mockDb });
    const settings = await service.getAllSettings();

    expect(settings.platform).toEqual(DEFAULT_PLATFORM_CONFIG);
    expect(settings.dispatch).toEqual(DEFAULT_DISPATCH_CONFIG);
    expect(settings.post).toEqual(DEFAULT_POST_CONFIG);
  });

  it("should validate and simulate public channel dispatch test", async () => {
    const mockDb: any = {
      select: () => ({
        from: () => ({
          where: () => ({
            get: async () => null,
          }),
        }),
      }),
    };

    const service = new SystemSettingsService({ db: mockDb });

    // Missing token
    const failedResult = await service.testDispatchChannel("public_channel", {
      telegramBotToken: "",
      telegramPublicChannelId: "@my_channel",
    });
    expect(failedResult.success).toBe(false);

    // Mock fetch for Telegram API
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ ok: true }),
    }));

    // Valid credentials
    const successResult = await service.testDispatchChannel("public_channel", {
      telegramBotToken: "123:ABC",
      telegramPublicChannelId: "@my_channel",
    });
    expect(successResult.success).toBe(true);
    expect(successResult.message).toContain("@my_channel");
    vi.unstubAllGlobals();
  });

  it("should validate and simulate admin group alert test", async () => {
    const mockDb: any = {
      select: () => ({
        from: () => ({
          where: () => ({
            get: async () => null,
          }),
        }),
      }),
    };

    const service = new SystemSettingsService({ db: mockDb });

    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ ok: true }),
    }));

    const successResult = await service.testDispatchChannel("admin_group", {
      telegramBotToken: "123:ABC",
      telegramAdminGroupId: "-100987654",
    });
    expect(successResult.success).toBe(true);
    expect(successResult.message).toContain("-100987654");
    vi.unstubAllGlobals();
  });

  it("should validate and simulate mail send test", async () => {
    const mockDb: any = {
      select: () => ({
        from: () => ({
          where: () => ({
            get: async () => null,
          }),
        }),
      }),
    };

    const service = new SystemSettingsService({ db: mockDb });

    const successResult = await service.testDispatchChannel("mail", {
      mailSenderEmail: "admin@test.com",
    });
    expect(successResult.success).toBe(true);
    expect(successResult.message).toContain("admin@test.com");
  });

  it("should resolve siteUrl with environment variable fallback when default localhost", async () => {
    const mockDb: any = {
      select: () => ({
        from: () => ({
          where: () => ({
            get: async () => null,
          }),
        }),
      }),
    };

    // Default without env
    const serviceDefault = new SystemSettingsService({ db: mockDb });
    const defaultUrl = await serviceDefault.getSiteUrl();
    expect(defaultUrl).toBe("http://localhost:3000");

    // With env option
    const serviceWithEnv = new SystemSettingsService({
      db: mockDb,
      env: { SITE_URL: "https://my-ads-platform.com/" },
    });
    const envUrl = await serviceWithEnv.getSiteUrl();
    expect(envUrl).toBe("https://my-ads-platform.com");
  });
});
