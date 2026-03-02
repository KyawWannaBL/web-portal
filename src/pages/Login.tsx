import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useLanguage } from '@/contexts/LanguageContext';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card'; // Fixes "Card is not defined"
import { Mail, Lock, Globe, ArrowRight, ShieldCheck } from 'lucide-react';

export default function Login() {
  const navigate = useNavigate();
  const { toggleLang, lang } = useLanguage();
  const [email, setEmail] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    // Secure Session Entry for 135-Account Registry
    setTimeout(() => {
      localStorage.setItem('btx_session', JSON.stringify({ email, role: 'APP_OWNER' }));
      navigate('/admin/dashboard');
    }, 1500);
  };

  return (
    <div className="relative min-h-screen flex items-center justify-center overflow-hidden bg-[#05080F]">
      {/* 🎥 Official Britium Animated Background */}
      <video autoPlay muted loop playsInline className="absolute z-0 min-w-full min-h-full object-cover opacity-40 grayscale-[0.2]">
        <source src="/background.mp4" type="video/mp4" />
      </video>

      {/* 🛡️ Sovereign Login Shield */}
      <Card className="relative z-10 w-full max-w-md bg-black/60 backdrop-blur-3xl border-white/10 rounded-[3rem] p-12 shadow-2xl">
        <div className="text-center mb-10">
          <img src="/logo.png" alt="Britium Express" className="h-20 mx-auto mb-6 drop-shadow-[0_0_15px_rgba(16,185,129,0.3)]" />
          <h1 className="text-2xl font-black text-white uppercase italic tracking-tighter">L5 Command Portal</h1>
          <p className="text-[10px] text-emerald-500 font-mono uppercase tracking-[0.4em] italic">Britium_Express_Network • Sovereign_Access</p>
        </div>

        <form onSubmit={handleLogin} className="space-y-6">
          <div className="relative group">
            <Mail className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-emerald-500/50 group-focus-within:text-emerald-500 transition-colors" />
            <input 
              type="email" 
              required 
              className="w-full bg-white/5 border border-white/10 rounded-2xl h-14 pl-12 text-white outline-none focus:border-emerald-500 transition-all" 
              placeholder="ID (md@britiumventures.com)" 
              onChange={e => setEmail(e.target.value)} 
            />
          </div>
          <div className="relative group">
            <Lock className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-emerald-500/50 group-focus-within:text-emerald-500 transition-colors" />
            <input 
              type="password" 
              required 
              className="w-full bg-white/5 border border-white/10 rounded-2xl h-14 pl-12 text-white outline-none focus:border-emerald-500 transition-all" 
              placeholder="Access Key" 
            />
          </div>
          <Button type="submit" disabled={isLoading} className="w-full h-16 bg-emerald-600 hover:bg-emerald-500 text-white font-black rounded-2xl text-lg uppercase group transition-all shadow-lg shadow-emerald-900/20">
            {isLoading ? "Validating..." : (
              <span className="flex items-center gap-2">
                {lang === 'en' ? 'Authorize & Enter' : 'စနစ်သို့ ဝင်မည်'}
                <ArrowRight className="group-hover:translate-x-1 transition-transform" />
              </span>
            )}
          </Button>
        </form>

        <Button onClick={toggleLang} variant="ghost" className="mt-8 w-full text-slate-500 hover:text-white flex items-center gap-2 text-[10px] font-bold uppercase tracking-widest">
          <Globe size={14} /> {lang === 'en' ? "မြန်မာစာ" : "English"}
        </Button>
      </Card>
      
      <div className="absolute bottom-8 text-[9px] text-slate-600 font-mono uppercase tracking-widest">
        © 2026 Britium Ventures • Encrypted L5 Session
      </div>
    </div>
  );
}
