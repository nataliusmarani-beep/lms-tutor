import { cookies } from "next/headers";
import type { Lang } from "@/lib/i18n";

/** Read language from cookie — Server Components only */
export function getLang(): Lang {
  try {
    const val = cookies().get("lang")?.value;
    return val === "id" ? "id" : "en";
  } catch {
    return "en";
  }
}
