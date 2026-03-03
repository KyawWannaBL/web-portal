export function I18nProvider(props: { children: React.ReactNode }) {
  const [lang, setLangState] = React.useState<Lang>(() => {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw === "my" ? "my" : "en";
  });

  const setLang = React.useCallback((next: Lang) => {
    setLangState(next);
    localStorage.setItem(STORAGE_KEY, next);
  }, []);

  // Fixed: Used state callback to prevent stale closures
  const toggleLang = React.useCallback(() => {
    setLangState((prev) => {
      const next = prev === "en" ? "my" : "en";
      localStorage.setItem(STORAGE_KEY, next);
      return next;
    });
  }, []);

  const t = React.useCallback(
    (key: string) => TRANSLATIONS[lang][key] ?? TRANSLATIONS.en[key] ?? key,
    [lang]
  );

  const value: I18nContextValue = { lang, setLang, toggleLang, t };

  return <I18nContext.Provider value={value}>{props.children}</I18nContext.Provider>;
}