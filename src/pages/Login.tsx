import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useLanguage } from '@/contexts/LanguageContext';
import { Button } from '@/components/ui/button';
import { ShieldCheck, Mail, Lock, Download, Globe, AlertTriangle } from 'lucide-react';
import { supabase } from '@/supabaseClient';

export default function Login() {
  const navigate = useNavigate();
  const { toggleLang, lang } = useLanguage();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [authError, setAuthError] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setAuthError(''); // Clear old errors
    
    try {
      // 📡 REAL SUPABASE AUTHENTICATION CALL
      const { data, error } = await supabase.auth.signInWithPassword({
        email: email,
        password: password,
      });

      if (error) throw error;

      if (data.session) {
        // Success! Save session and route to dashboard
        localStorage.setItem('btx_session', JSON.stringify({ 
          email: data.user.email, 
          role: 'AUTHENTICATED_USER' 
        }));
        navigate('/admin/dashboard');
      }
    } catch (error: any) {
      console.error('L5 Auth Error:', error.message);
      setAuthError(lang === 'en' ? 'Invalid clearance credentials.' : 'လျှို့ဝှက်ကုဒ် သို့မဟုတ် အီးမေးလ် မှားယွင်းနေပါသည်။');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="relative min-h-screen flex flex-col items-center justify-center overflow-hidden bg-[#05080F] p-4">
      <video autoPlay muted loop playsInline className="absolute z-0 min-w-full min-h-full object-cover opacity-20 grayscale-[0.3]">
        <source src="/background.mp4" type="video/mp4" />
      </video>

      <div className="relative z-10 w-full max-w-md flex flex-col items-center">
        <div className="w-16 h-16 bg-[#0B101B]/80 backdrop-blur-md border border-white/5 rounded-2xl flex items-center justify-center mb-6 shadow-2xl">
          <ShieldCheck className="text-emerald-500 h-8 w-8" strokeWidth={2} />
        </div>

        <h1 className="text-4xl font-black text-white tracking-widest uppercase mb-3">
          BRITIUM <span className="text-emerald-500">EXPRESS</span>
        </h1>
        <p className="text-[10px] text-slate-400 font-mono tracking-[0.2em] uppercase mb-8 text-center">
          SECURE GATEWAY • AUTHORIZED PERSONNEL ONLY
        </p>

        <div className="w-full bg-[#111622]/95 backdrop-blur-2xl rounded-3xl p-8 shadow-2xl border border-white/5 border-t-[6px] border-t-emerald-500 relative overflow-hidden">
          
          <form onSubmit={handleLogin} className="space-y-6">
            
            {/* 🔴 Error Message Display */}
            {authError && (
              <div className="bg-rose-500/10 border border-rose-500/50 text-rose-500 text-xs font-mono p-3 rounded-lg flex items-center gap-2">
                <AlertTriangle size={14} /> {authError}
              </div>
            )}

            <div>
              <label className="text-[10px] font-black font-mono text-slate-400 tracking-widest uppercase mb-2 block">
                {lang === 'en' ? 'Corporate Email' : 'အီးမေးလ်လိပ်စာ'}
              </label>
              <div className="relative group">
                <Mail className="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-500 group-focus-within:text-emerald-500 transition-colors" />
                <input type="email" required className="w-full bg-[#0B0E17] border border-white/5 rounded-xl h-14 pl-12 pr-4 text-white font-mono text-sm outline-none focus:border-emerald-500/50 focus:ring-1 focus:ring-emerald-500/50 transition-all" placeholder="admin@britium.com" onChange={e => setEmail(e.target.value)} />
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-[10px] font-black font-mono text-slate-400 tracking-widest uppercase mb-2 block">
                {lang === 'en' ? 'Security Clearance (Password)' : 'လျှို့ဝှက်ကုဒ်'}
              </label>
              <div className="relative group">
                <Lock className="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-500 group-focus-within:text-emerald-500 transition-colors" />
                <input type="password" required className="w-full bg-[#0B0E17] border border-white/5 rounded-xl h-14 pl-12 pr-4 text-white font-mono text-lg tracking-widest outline-none focus:border-emerald-500/50 focus:ring-1 focus:ring-emerald-500/50 transition-all" placeholder="••••••••••••" onChange={e => setPassword(e.target.value)} />
              </div>
              
              <div className="flex justify-end pt-1">
                <button type="button" onClick={() => navigate('/forgot-password')} className="text-[10px] font-mono tracking-wider text-slate-500 hover:text-emerald-400 transition-colors">
                  {lang === 'en' ? 'Forgot Clearance Key?' : 'စကားဝှက်မေ့နေပါသလား?'}
                </button>
              </div>
            </div>

            <Button type="submit" disabled={isLoading} className="w-full h-14 bg-emerald-600 hover:bg-emerald-500 text-white font-black rounded-xl text-lg tracking-widest uppercase transition-all shadow-lg shadow-emerald-900/20 mt-2">
              {isLoading ? (lang === 'en' ? "VALIDATING..." : "စစ်ဆေးနေပါသည်...") : (lang === 'en' ? 'AUTHENTICATE' : 'စနစ်သို့ဝင်မည်')}
            </Button>
          </form>

          <div className="mt-8 pt-6 border-t border-white/5 space-y-4">
            <div className="text-center text-[11px] font-mono text-slate-400">
              {lang === 'en' ? "NO AUTHORIZATION?" : "အကောင့်မရှိသေးဘူးလား?"}
              <button type="button" onClick={() => navigate('/signup')} className="ml-2 text-emerald-500 hover:text-emerald-400 font-bold uppercase tracking-widest transition-colors">
                {lang === 'en' ? 'REQUEST ACCESS' : 'အကောင့်ဖွင့်မည်'}
              </button>
            </div>

            <Button variant="outline" type="button" className="w-full h-12 bg-transparent border-emerald-500/20 text-emerald-500 hover:bg-emerald-500/10 hover:border-emerald-500 font-mono tracking-widest transition-all rounded-lg text-xs" onClick={() => window.open('/britium-express.apk', '_blank')}>
              <Download className="mr-2 h-4 w-4" />
              {lang === 'en' ? 'DOWNLOAD MOBILE APK' : 'Britium Express APK ဒေါင်းလုဒ်လုပ်ရန်'}
            </Button>
            
            <Button onClick={toggleLang} variant="ghost" className="w-full text-slate-500 hover:text-white flex items-center justify-center gap-2 text-[10px] font-bold font-mono uppercase tracking-widest h-8">
              <Globe size={14} /> {lang === 'en' ? "မြန်မာစာ" : "English"}
            </Button>
          </div>
        </div>

        <div className="mt-8 text-[10px] font-mono text-slate-600 tracking-[0.2em] uppercase text-center flex items-center justify-center gap-2">
          IP LOGGED • ENCRYPTED SESSION • L5_SYS_READY
        </div>
      </div>
    </div>
  );
}
