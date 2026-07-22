import CryptoJS from 'crypto-js'

/**
 * Secret key used for symmetric AES encryption.
 * Reads runtime secret or falls back to standard key.
 */
const DEFAULT_SECRET
  = (typeof import.meta !== 'undefined' && import.meta.env?.NUXT_PUBLIC_CRYPTO_SECRET)
    || 'ads-platform-default-secure-key'

/**
 * Encrypts any JS object or primitive data using AES encryption.
 * @param data Data object, array, or string to encrypt
 * @param secret Secret key (optional)
 * @returns Encrypted ciphertext string
 */
export function encryptData<T>(
  data: T,
  secret: string = DEFAULT_SECRET
): string {
  try {
    const jsonString = JSON.stringify(data)
    return CryptoJS.AES.encrypt(jsonString, secret).toString()
  } catch (error) {
    console.error('Encryption failed:', error)
    throw new Error('Failed to encrypt data')
  }
}

/**
 * Decrypts an AES ciphertext string back into typed data.
 * @param ciphertext Encrypted AES string
 * @param secret Secret key (optional)
 * @returns Decrypted object or null if failed
 */
export function decryptData<T>(
  ciphertext: string,
  secret: string = DEFAULT_SECRET
): T | null {
  try {
    if (!ciphertext) return null
    const bytes = CryptoJS.AES.decrypt(ciphertext, secret)
    const decryptedString = bytes.toString(CryptoJS.enc.Utf8)
    if (!decryptedString) return null
    return JSON.parse(decryptedString) as T
  } catch (error) {
    console.error('Decryption failed:', error)
    return null
  }
}
