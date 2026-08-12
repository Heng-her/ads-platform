import type { Context } from "hono";
import type { DbClient } from "../db/index";
import type { UserJwtPayload } from "../types/env";
import { SubscriberService } from "../services/subscriberService";

export interface SubscriberActionOptions {
  c?: Context<any>;
  db: DbClient;
  action: string;
  data: any;
  currentUser?: UserJwtPayload | null;
}

export async function handleSubscriberAction({
  action,
  data,
  currentUser,
  db,
}: SubscriberActionOptions): Promise<any> {
  const service = new SubscriberService(db);

  if (action === "subscribers/subscribe") {
    const { email, source } = data || {};
    const res = await service.subscribe(email || "", source || "PUBLIC_MODAL");
    return {
      code: res.success ? 1 : 0,
      msg: res.message,
      data: res,
    };
  }

  if (action === "subscribers/unsubscribe") {
    const { email } = data || {};
    const res = await service.unsubscribe(email || "");
    return {
      code: res.success ? 1 : 0,
      msg: res.message,
      data: res,
    };
  }

  if (action === "subscribers/list") {
    if (!currentUser || currentUser.role !== "ADMIN") {
      return { code: 0, msg: "Unauthorized: Admin privileges required." };
    }

    const page = Number(data?.page) || 1;
    const limit = Number(data?.limit) || 20;
    const result = await service.listSubscribers(page, limit);

    return {
      code: 1,
      msg: "Subscribers listed successfully.",
      data: result,
    };
  }

  return { code: 0, msg: `Unknown subscriber action: ${action}` };
}
