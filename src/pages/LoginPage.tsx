import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/lib/supabase';
import { useLanguageContext } from '@/lib/LanguageContext';
import { Card, CardContent } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { ShieldCheck, Loader2, Lock, Mail, AlertCircle } from 'lucide-react';

export default function LoginPage() {
  const { t } = useLanguageContext();
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setErrorMsg('');

    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) {
      setErrorMsg(error.message);
      setLoading(false);
    } else if (data.session) {
      // Secure redirect to the L5 Command Center
      navigate('/dashboard');
    }
  };

  return (
    <div className="min-h-screen bg-[#05080F] flex items-center justify-center p-4 font-sans selection:bg-emerald-500/30">
      <div className="w-full max-w-md space-y-8">
        
        {/* Branding Header */}
        <div className="text-center space-y-2">
          <div className="mx-auto h-16 w-16 bg-white/5 border border-white/10 rounded-2xl flex items-center justify-center mb-6 shadow-2xl">
            <ShieldCheck className="h-8 w-8 text-emerald-500" />
          </div>
          <h1 className="text-3xl font-black text-white tracking-tighter uppercase">
            Britium <span className="text-emerald-500">Express</span>
          </h1>
          <p className="text-[10px] font-mono text-slate-500 tracking-widest uppercase">
            {t('Secure Gateway • Authorized Personnel Only', 'လုံခြုံရေးဂိတ် • ခွင့်ပြုချက်ရသူများသာ')}
          </p>
        </div>

        {/* Security Card */}
        <Card className="bg-[#0B101B] border-white/5 shadow-2xl rounded-3xl overflow-hidden relative">
          <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-emerald-600 to-emerald-400" />
          <CardContent className="p-8">
            <form onSubmit={handleLogin} className="space-y-6">
              
              {errorMsg && (
                <div className="p-4 bg-rose-500/10 border border-rose-500/20 rounded-xl flex items-center gap-3 text-rose-400">
                  <AlertCircle className="h-5 w-5 shrink-0" />
                  <p className="text-xs font-bold uppercase tracking-wide">{errorMsg}</p>
                </div>
              )}

              <div className="space-y-4">
                <div className="space-y-2">
                  <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest">{t('Corporate Email', 'အီးမေးလ်')}</label>
                  <div className="relative">
                    <Mail className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-500" />
                    <Input 
                      type="email" 
                      required
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      className="bg-white/5 border-white/10 text-white pl-12 h-14 rounded-xl focus-visible:ring-emerald-500/50 font-mono text-sm"
                      placeholder="admin@britium.com"
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest">{t('Security Clearance (Password)', 'စကားဝှက်')}</label>
                  <div className="relative">
                    <Lock className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-500" />
                    <Input 
                      type="password" 
                      required
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      className="bg-white/5 border-white/10 text-white pl-12 h-14 rounded-xl focus-visible:ring-emerald-500/50 font-mono text-sm"
                      placeholder="••••••••••••"
                    />
                  </div>
                </div>
              </div>

              <Button 
                type="submit" 
                disabled={loading}
                className="w-full h-14 bg-emerald-600 hover:bg-emerald-500 text-white font-black text-sm uppercase tracking-widest rounded-xl transition-all disabled:opacity-50"
              >
                {loading ? <Loader2 className="h-5 w-5 animate-spin" /> : t('Authenticate', 'အကောင့်ဝင်မည်')}
              </Button>
            </form>
          </CardContent>
        </Card>
        
        {/* Footer Meta */}
        <p className="text-center text-[10px] font-mono text-slate-600 uppercase">
          IP LOGGED • ENCRYPTED SESSION • L5_SYS_READY
        </p>
      </div>
    </div>
  );
}
