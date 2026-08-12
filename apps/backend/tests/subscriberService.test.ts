import { describe, it, expect } from "vitest";
import { SubscriberService } from "../src/services/subscriberService";

describe("SubscriberService", () => {
  it("should validate invalid email during subscription", async () => {
    const mockDb: any = {};
    const service = new SubscriberService(mockDb);

    const res = await service.subscribe("invalid-email");
    expect(res.success).toBe(false);
    expect(res.message).toContain("valid email");
  });

  it("should insert a new subscriber when email is new", async () => {
    let insertedData: any = null;
    const mockDb: any = {
      select: () => ({
        from: () => ({
          where: () => ({
            get: async () => null,
          }),
        }),
      }),
      insert: () => ({
        values: (data: any) => {
          insertedData = data;
          return Promise.resolve();
        },
      }),
    };

    const service = new SubscriberService(mockDb);
    const res = await service.subscribe("visitor@example.com");

    expect(res.success).toBe(true);
    expect(insertedData.email).toBe("visitor@example.com");
    expect(insertedData.status).toBe("SUBSCRIBED");
  });

  it("should reactivate an unsubscribed user", async () => {
    let updatedData: any = null;
    const mockDb: any = {
      select: () => ({
        from: () => ({
          where: () => ({
            get: async () => ({
              id: "sub-1",
              email: "visitor@example.com",
              status: "UNSUBSCRIBED",
            }),
          }),
        }),
      }),
      update: () => ({
        set: (data: any) => ({
          where: () => {
            updatedData = data;
            return Promise.resolve();
          },
        }),
      }),
    };

    const service = new SubscriberService(mockDb);
    const res = await service.subscribe("visitor@example.com");

    expect(res.success).toBe(true);
    expect(updatedData.status).toBe("SUBSCRIBED");
  });
});
