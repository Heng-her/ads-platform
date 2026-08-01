import { z } from "zod";

export const registerSchema = z.object({
  username: z.string().min(2, "Username must be at least 2 characters"),
  email: z.string().email("Invalid email address"),
  password: z.string().min(8, "Password must be at least 8 characters"),
  avatar: z.string().optional(),
  portfolioLink: z.string().url("Invalid portfolio URL").optional(),
  country: z
    .string()
    .length(2, "Country must be a 2-letter ISO code (e.g. US, NG)")
    .toUpperCase()
    .optional(),
  role: z.enum(["ADMIN", "CREATOR"]).optional().default("CREATOR"),
});

export const loginSchema = z.object({
  email: z.string().email("Invalid email address"),
  password: z.string().min(1, "Password is required"),
});

export type RegisterInput = z.infer<typeof registerSchema>;
export type LoginInput = z.infer<typeof loginSchema>;
