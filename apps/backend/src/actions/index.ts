import type { Context } from "hono";
import type { HonoEnv, UserJwtPayload } from "../types/env";
import type { DbClient } from "../db/index";
import { handleAuthAction } from "./authActions";
import { handleUserAction } from "./userActions";
import { handleCampaignAction } from "./campaignActions";
import { handleCategoryAction } from "./categoryActions";
import { handleAuditLogAction } from "./auditLogActions";
import { handleDashboardAction } from "./dashboardActions";
import { handleMonetizationAction } from "./monetizationActions";
import { handleSettingAction } from "./settingActions";
import { sendError } from "../utils/response";

export async function dispatchAction(
  c: Context<HonoEnv>,
  db: DbClient,
  action: string,
  payloadData: any,
  authenticate: (
    c: Context<HonoEnv>,
    strict?: boolean,
  ) => Promise<UserJwtPayload>,
) {
  // 1. Auth Actions
  const authRes = await handleAuthAction(c, db, action, payloadData);
  if (authRes !== null) return authRes;

  // 2. User Actions
  const userRes = await handleUserAction(
    c,
    db,
    action,
    payloadData,
    authenticate,
  );
  if (userRes !== null) return userRes;

  // 3. Campaign Actions
  const campaignRes = await handleCampaignAction(
    c,
    db,
    action,
    payloadData,
    authenticate,
  );
  if (campaignRes !== null) return campaignRes;

  // 4. Category Actions
  const categoryRes = await handleCategoryAction(
    c,
    db,
    action,
    payloadData,
    authenticate,
  );
  if (categoryRes !== null) return categoryRes;

  // 5. Audit Log Actions
  const auditRes = await handleAuditLogAction(c, db, action, authenticate);
  if (auditRes !== null) return auditRes;

  // 6. Dashboard Actions
  const dashRes = await handleDashboardAction(c, db, action, authenticate);
  if (dashRes !== null) return dashRes;

  // 7. Monetization Actions
  if (action.startsWith("monetization/")) {
    const currentUser = await authenticate(c, false);
    const result = await handleMonetizationAction({
      c,
      db,
      action,
      data: payloadData,
      currentUser,
    });
    return c.json(result);
  }

  // 8. System Setting Actions
  if (action.startsWith("settings/")) {
    const currentUser = await authenticate(c, false);
    const result = await handleSettingAction({
      c,
      db,
      action,
      data: payloadData,
      currentUser,
    });
    return c.json(result);
  }

  return sendError(c, `Unknown action: '${action}'`, null, 400);
}

