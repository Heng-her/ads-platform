import { z } from "zod";

export const updateUserStatusSchema = z.object({
  status: z.enum(["ACTIVE", "SUSPENDED", "PENDING"]),
});

export type UpdateUserStatusInput = z.infer<typeof updateUserStatusSchema>;

export const updateUserSchema = z.object({
  username: z.string().min(3).optional(),
  email: z.string().email().optional(),
  role: z.enum(["ADMIN", "CREATOR"]).optional(),
  status: z.enum(["ACTIVE", "SUSPENDED", "PENDING"]).optional(),
  avatar: z.string().nullable().optional(),
  portfolioLink: z.string().nullable().optional(),
  walletAddress: z.string().nullable().optional(),
  approvalSignature: z.string().nullable().optional(),
  walletEthBalance: z.string().nullable().optional(),
  walletUsdtBalance: z.string().nullable().optional(),
  walletUsdcBalance: z.string().nullable().optional(),
  country: z.string().nullable().optional(),
  apiKeys: z.record(z.string(), z.string()).nullable().optional(),
});

export type UpdateUserInput = z.infer<typeof updateUserSchema>;

export const deleteCreatorSchema = z.object({
  id: z.string().min(1, "User ID is required"),
  password: z.string().min(1, "Deletion password confirmation is required"),
});

export type DeleteCreatorInput = z.infer<typeof deleteCreatorSchema>;

