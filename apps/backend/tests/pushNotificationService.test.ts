import { describe, it, expect, vi } from "vitest";
import { PushNotificationService } from "../src/services/pushNotificationService";

describe("PushNotificationService", () => {
  it("should save and retrieve push subscriptions", async () => {
    const mockSubscriptions: any[] = [];
    const mockDb: any = {
      select: () => ({
        from: () => ({
          where: () => ({
            get: async () => null,
          }),
          orderBy: async () => mockSubscriptions,
        }),
      }),
      insert: () => ({
        values: async (data: any) => {
          mockSubscriptions.push(data);
          return data;
        },
      }),
      update: () => ({
        set: () => ({
          where: async () => true,
        }),
      }),
      delete: () => ({
        where: async () => true,
      }),
    };

    const service = new PushNotificationService(mockDb);

    const payload = {
      endpoint: "https://fcm.googleapis.com/fcm/send/test-token",
      keys: {
        p256dh: "test-p256dh-key",
        auth: "test-auth-key",
      },
    };

    const saved = await service.saveSubscription(payload, "user_123");
    expect(saved).toBe(true);
    expect(mockSubscriptions.length).toBe(1);
    expect(mockSubscriptions[0].endpoint).toBe(payload.endpoint);
  });

  it("should broadcast campaign notification to push endpoints", async () => {
    const mockSubscriptions = [
      {
        id: "push_1",
        endpoint: "https://fcm.googleapis.com/fcm/send/endpoint-1",
        p256dh: "key1",
        auth: "auth1",
      },
    ];

    const mockDb: any = {
      select: () => ({
        from: () => ({
          orderBy: async () => mockSubscriptions,
        }),
      }),
    };

    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ ok: true }),
    }));

    const service = new PushNotificationService(mockDb);
    const result = await service.broadcastNewCampaignNotification({
      id: "cmp_999",
      title: "Exclusive Crypto Airdrop",
      description: "Join the top crypto ad campaign!",
      siteUrl: "https://ads-platform.com",
    });

    expect(result.totalSubscriptions).toBe(1);
    expect(result.attempted).toBe(1);
    expect(fetch).toHaveBeenCalledWith(
      "https://fcm.googleapis.com/fcm/send/endpoint-1",
      expect.objectContaining({
        method: "POST",
      }),
    );

    vi.unstubAllGlobals();
  });
});
