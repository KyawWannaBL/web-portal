import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useLanguage } from '@/contexts/LanguageContext';
import { Button } from '@/components/ui/button';
import { ShieldCheck, Lock, Mail, Globe } from 'lucide-react';

export default function Login() {
  const { toggleLang, lang } = useLanguage();
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-[#05080F] flex items-center justify-center p-6">
      <div className="absolute top-10 right-10">
        <Button onClick={toggleLang} variant="outline" className="border-white/10 text-slate-400">
          <Globe className="mr-2 h-4 w-4" /> {lang === 'en' ? "မြန်မာစာ" : "English"}
        </Button>
      </div>

      <div className="w-full max-w-md space-y-8 bg-[#0B101B] p-12 rounded-[3rem] border border-white/5 shadow-2xl">
        <div className="text-center space-y-4">
          <div className="w-20 h-20 bg-emerald-500/10 rounded-3xl flex items-center justify-center mx-auto border border-emerald-500/20">
            <ShieldCheck className="h-10 w-10 text-emerald-500" />
          </div>
          <h1 className="text-3xl font-black text-white uppercase italic tracking-tighter">Britium L5 Core</h1>
          <p className="text-[10px] text-slate-500 font-mono uppercase tracking-[0.3em]">Authorized Personnel Only</p>
        </div>

        <div className="space-y-6">
          <div className="space-y-2">
            <label className="text-[10px] font-black text-slate-500 uppercase tracking-widest">{lang === 'en' ? 'Enterprise Email' : 'လုပ်ငန်းသုံး အီးမေးလ်'}</label>
            <div className="relative">
              <Mail className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-600" />
              <input className="w-full bg-[#05080F] border border-white/5 rounded-2xl h-14 pl-12 pr-6 text-white outline-none focus:border-emerald-500 transition-all" placeholder="admin@britium.express" />
            </div>
          </div>
          <div className="space-y-2">
            <label className="text-[10px] font-black text-slate-500 uppercase tracking-widest">{lang === 'en' ? 'Access Key' : 'လျှို့ဝှက်နံပါတ်'}</label>
            <div className="relative">
              <Lock className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-600" />
              <input type="password" className="w-full bg-[#05080F] border border-white/5 rounded-2xl h-14 pl-12 pr-6 text-white outline-none focus:border-emerald-500 transition-all" placeholder="••••••••" />
            </div>
          </div>
          <Button onClick={() => navigate('/admin/dashboard')} className="w-full h-16 bg-emerald-600 hover:bg-emerald-500 text-white font-black rounded-2xl text-lg uppercase shadow-xl shadow-emerald-900/20">
            {lang === 'en' ? 'Establish Secure Session' : 'လုံခြုံစွာ အကောင့်ဝင်မည်'}
          </Button>
        </div>
      </div>
    </div>
  );
}
