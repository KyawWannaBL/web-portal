import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/lib/supabase';
import { useLanguageContext } from '@/lib/LanguageContext';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Lock, Mail, ShieldCheck } from 'lucide-react';

export default function LoginPage() {
  const { t } = useLanguageContext();
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    if (loading) return;
    
    setLoading(true);
    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) throw error;
      
      // Clear loading and move to dashboard
      setLoading(false);
      navigate('/dashboard');
    } catch (error: any) {
      alert(t('Auth Error: ', 'အမှားအယွင်း: ') + error.message);
      setLoading(false); // Critical: Re-enable buttons on failure
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-slate-950 p-6">
      <div className="w-full max-w-md space-y-8">
        <div className="text-center">
          <ShieldCheck className="h-16 w-16 text-emerald-500 mx-auto" />
          <h2 className="mt-6 text-3xl font-extrabold text-white uppercase tracking-tighter">
            Britium Express
          </h2>
          <p className="text-emerald-500/60 font-mono text-xs uppercase mt-2">v2026.02.25 Build</p>
        </div>
        <form className="mt-8 space-y-4" onSubmit={handleLogin}>
          <Input 
            type="email" 
            placeholder={t('Email', 'အီးမေးလ်')} 
            className="bg-white/5 border-white/10 text-white h-14"
            onChange={(e) => setEmail(e.target.value)}
            required 
          />
          <Input 
            type="password" 
            placeholder={t('Password', 'လျှို့ဝှက်နံပါတ်')} 
            className="bg-white/5 border-white/10 text-white h-14"
            onChange={(e) => setPassword(e.target.value)}
            required 
          />
          <Button 
            disabled={loading} 
            className="w-full h-14 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-lg rounded-2xl transition-all active:scale-95"
          >
            {loading ? t('Verifying...', 'စစ်ဆေးနေသည်...') : t('Login', 'ဝင်ရောက်မည်')}
          </Button>
        </form>
      </div>
    </div>
  );
}
