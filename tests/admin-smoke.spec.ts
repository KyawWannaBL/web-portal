import { test, expect } from "@playwright/test";

test("admin smoke: login + portals + sidebar + header controls", async ({ page }) => {
  await page.goto("/login");

  await page.getByTestId("login-email").fill("demo@britium.test");
  await page.getByTestId("login-password").fill("demo");
  await page.getByTestId("login-submit").click();

  await expect(page).toHaveURL(/\/admin\/dashboard/);

  // Portal entrances
  await page.getByTestId("portal-approvals").click();
  await expect(page).toHaveURL(/\/admin\/approvals/);

  await page.getByTestId("btn-prev").click();
  await expect(page).toHaveURL(/\/admin\/dashboard/);

  await page.getByTestId("portal-shipments").click();
  await expect(page).toHaveURL(/\/admin\/shipments/);

  // Sidebar routing
  await page.getByTestId("nav-fleet").click();
  await expect(page).toHaveURL(/\/admin\/fleet/);

  await page.getByTestId("nav-finance").click();
  await expect(page).toHaveURL(/\/admin\/omni-finance/);

  await page.getByTestId("nav-live-map").click();
  await expect(page).toHaveURL(/\/admin\/live-map/);

  await page.getByTestId("nav-settings").click();
  await expect(page).toHaveURL(/\/admin\/settings/);

  // Header controls
  await page.getByTestId("btn-lang").click();
  await page.getByTestId("btn-account").click();
  await page.getByTestId("menu-signout").click();

  await expect(page).toHaveURL(/\/login/);
});
