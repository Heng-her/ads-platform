import CryptoJS from "crypto-js";

export const DEFAULT_CRYPTO_SECRET = "ads-platform-default-secure-key";

/**
 * Encrypts any JS object or primitive data into AES ciphertext string.
 */
export function encryptData<T>(
  data: T,
  secret: string = DEFAULT_CRYPTO_SECRET,
): string {
  try {
    const jsonString = JSON.stringify(data);
    return CryptoJS.AES.encrypt(jsonString, secret).toString();
  } catch (error) {
    console.error("Backend AES Encryption failed:", error);
    throw new Error("Failed to encrypt data");
  }
}

/**
 * Decrypts an AES ciphertext string back into typed data object.
 */
export function decryptData<T>(
  ciphertext: string,
  secret: string = DEFAULT_CRYPTO_SECRET,
): T | null {
  try {
    if (!ciphertext) return null;
    const bytes = CryptoJS.AES.decrypt(ciphertext, secret);
    const decryptedString = bytes.toString(CryptoJS.enc.Utf8);
    if (!decryptedString) return null;
    return JSON.parse(decryptedString) as T;
  } catch (error) {
    console.error("Backend AES Decryption failed:", error);
    return null;
  }
}
