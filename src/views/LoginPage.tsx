import * as React from "react";
import { useNavigate, useLocation } from "react-router-dom";
import { useAuth } from "../state/auth";
import { useI18n } from "../state/i18n";
import { PATHS } from "../routes/paths";

export default function LoginPage() {
  const { login } = useAuth();
  const { t } = useI18n();
  const navigate = useNavigate();
  const location = useLocation() as unknown as { state?: { from?: string } };
  
  const [email, setEmail] = React.useState("");
  const [password, setPassword] = React.useState("");
  const [isLoading, setIsLoading] = React.useState(false);
  const [error, setError] = React.useState("");

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    setIsLoading(true);
    setError("");
    
    try {
      await login(email, password);
      navigate(location.state?.from ?? PATHS.commandCenter, { replace: true });
    } catch (err) {
      setError("Authentication failed. Please verify your credentials.");
      setIsLoading(false);
    }
  }

  return (
    <div className="loginWrap">
      <div className="loginCard">
        <div className="loginTitle">{t("loginTitle")}</div>
        <div className="muted">{t("loginDesc")}</div>
        
        {error && <div style={{ color: '#ff7878', marginTop: '10px', fontSize: '14px' }}>{error}</div>}
        
        <form onSubmit={onSubmit} className="loginForm">
          <label className="label">
            <span className="labelText">{t("email")}</span>
            <input required type="email" placeholder="admin@britium.com" className="input" value={email} onChange={(e) => setEmail(e.target.value)} disabled={isLoading} />
          </label>
          <label className="label">
            <span className="labelText">{t("password")}</span>
            <input required type="password" placeholder="••••••••" className="input" value={password} onChange={(e) => setPassword(e.target.value)} disabled={isLoading} />
          </label>
          <button type="submit" className="btn btnPrimary" disabled={isLoading}>
            {isLoading ? t("loggingIn") : t("signIn")}
          </button>
        </form>
      </div>
    </div>
  );
}
