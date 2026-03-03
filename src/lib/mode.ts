export const MOCK_SESSION_KEY = "btx_mock_session_v1";

export function isMockMode(): boolean {
  const raw = String(import.meta.env.VITE_MOCK_MODE ?? "").trim().toLowerCase();
  return raw === "1" || raw === "true" || raw === "yes" || raw === "on";
}
