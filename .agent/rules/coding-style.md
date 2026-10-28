# Coding Style & Strict Typing Rules

1. **SINGLE UNIFIED API RESPONSE TYPE (NO `data: any`!)**:
   - ❌ **NEVER use `data: any`**: `any` destroys type-safety between backend and frontend.
   - ✅ **USE `ApiResponse<T>` from `@ads-platform/shared`**: Both backend and frontend must share ONE generic type envelope:
     ```ts
     import type { ApiResponse } from "@ads-platform/shared";

     // Success examples:
     ApiResponse<User>          // { code: 1, msg: string, time: number, data: User }
     ApiResponse<Campaign[]>    // { code: 1, msg: string, time: number, data: Campaign[] }

     // Failure example:
     ApiResponse<null>          // { code: 0, msg: string, time: number, data: null }
     ```
   - For Hono RPC calls, use `AppType` inference (`InferResponseType<typeof client.action.$post>`).

2. **NO MOCK DATA ON API ERROR OR EMPTY DATA**:
   - NEVER return or inject mock/dummy/fake data when an API fails, throws an error, or returns an empty list (`[]` or `null`).
   - If an error occurs: report the real error clearly (e.g. via toast or alert) and keep state as empty/null.
   - If data is empty: display a clean, genuine Empty State UI ("No items found").
   - Never mask real failures with hardcoded fallback items.

3. **CLEAN ARCHITECTURE FOR MAINTENANCE**:
   - In Frontend (Nuxt 4): Keep components small, extract reusable logic into Pinia stores or composables, strictly use types from `@ads-platform/shared`.
   - In Backend (Hono): Maintain 3 distinct layers (Action/Route -> Service -> DB). Keep handlers thin, validate with Zod.
