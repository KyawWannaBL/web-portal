import React, { createContext, useContext, useEffect, useMemo, useState, ReactNode } from "react";

export type Language = "en" | "my";
type LanguageContextType = {
  lang: Language;
  toggleLang: () => void;
  t: (en: string, my?: string) => string;
};

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [lang, setLang] = useState<Language>("en");

  useEffect(() => {
    const saved = localStorage.getItem("btx_lang") as Language | null;
    if (saved === "en" || saved === "my") setLang(saved);
  }, []);

  const toggleLang = () => {
    const next: Language = lang === "en" ? "my" : "en";
    setLang(next);
    localStorage.setItem("btx_lang", next);
  };

  const t = useMemo(
    () => (en: string, my?: string) => (lang === "my" && my ? my : en),
    [lang]
  );

  return (
    <LanguageContext.Provider value={{ lang, toggleLang, t }}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (!context) throw new Error("useLanguage must be used within a LanguageProvider");
  return context;
}
