import React from "react";
import { LanguageProvider as CoreProvider, useLanguage } from "@/contexts/LanguageContext";

export type Language = "en" | "my";

export const LanguageProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  return <CoreProvider>{children}</CoreProvider>;
};

export const useLanguageContext = () => {
  const { lang, toggleLang, t } = useLanguage();
  const setLanguage = (next: Language) => {
    if (next !== lang) toggleLang();
  };
  return { language: lang, setLanguage, t };
};
