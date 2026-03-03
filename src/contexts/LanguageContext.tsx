import React, { createContext, useContext, useState } from 'react';

export const LanguageContext = createContext<any>({
  language: 'en',
  lang: 'en',
  setLanguage: () => {},
  toggleLang: () => {},
  t: (key: string) => key,
});

export function useLanguage() { return useContext(LanguageContext); }

export const LanguageProvider = ({ children }: { children: React.ReactNode }) => {
  const [lang, setLang] = useState('en');
  return (
    <LanguageContext.Provider value={{ 
      language: lang, lang, setLanguage: setLang, 
      toggleLang: () => setLang(l => l==='en'?'my':'en'), 
      t: (k: string) => k 
    }}>
      {children}
    </LanguageContext.Provider>
  );
};
