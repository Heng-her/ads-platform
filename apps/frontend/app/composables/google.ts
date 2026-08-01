export interface GoogleTokenInfo {
  aud: string;
  email: string;
  email_verified: string | boolean;
  iss: string;
  name?: string;
  picture?: string;
  sub: string;
}

function isVerifiedEmail(value: GoogleTokenInfo["email_verified"]) {
  return value === true || value === "true";
}

export async function verifyGoogleIdToken(
  idToken: string,
  expectedAudience?: string,
): Promise<GoogleTokenInfo> {
  const response = await fetch(
    `https://oauth2.googleapis.com/tokeninfo?id_token=${encodeURIComponent(idToken)}`,
  );

  if (!response.ok) {
    throw new Error("Invalid Google credential");
  }

  const tokenInfo = (await response.json()) as GoogleTokenInfo;

  if (!tokenInfo.email || !isVerifiedEmail(tokenInfo.email_verified)) {
    throw new Error("Google account email is not verified");
  }

  if (
    tokenInfo.iss !== "accounts.google.com" &&
    tokenInfo.iss !== "https://accounts.google.com"
  ) {
    throw new Error("Invalid Google token issuer");
  }

  if (expectedAudience && tokenInfo.aud !== expectedAudience) {
    throw new Error("Google credential audience mismatch");
  }

  return tokenInfo;
}
