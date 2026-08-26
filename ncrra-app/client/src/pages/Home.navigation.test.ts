import { describe, expect, it } from "vitest";
import {
  HOME_DRAWER_TRIGGER_MIN_SIZE,
  shouldShowDrawerTrigger,
  type Screen,
} from "./Home";

describe("NCRRA Home drawer trigger contract", () => {
  it("shows the drawer trigger only on the Home root", () => {
    expect(shouldShowDrawerTrigger("home")).toBe(true);

    const nonHomeScreens: Screen[] = [
      "services",
      "community",
      "benefits",
      "account",
      "memberRecord",
      "receipts",
      "privacy",
      "security",
      "helpCentre",
      "contact",
      "ticket",
      "membership",
    ];

    for (const screen of nonHomeScreens) {
      expect(shouldShowDrawerTrigger(screen)).toBe(false);
    }
  });

  it("keeps the header trigger at or above the minimum touch target", () => {
    expect(HOME_DRAWER_TRIGGER_MIN_SIZE).toBeGreaterThanOrEqual(44);
  });
});
