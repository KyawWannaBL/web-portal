import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useLanguage } from '@/contexts/LanguageContext';
import { Button } from '@/components/ui/button';
import { ShieldCheck, Mail, Lock, AlertTriangle, KeyRound, Loader2 } from 'lucide-react';
import { supabase } from '@/supabaseClient';

export default function Login() {
  const navigate = useNavigate();
  const { lang } = useLanguage();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [authError, setAuthError] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setAuthError('');
    try {
      const { data, error } = await supabase.auth.signInWithPassword({ email, password });
      if (error) throw error;
      
      const { data: profile, error: pError } = await supabase
        .from('profiles').select('role').eq('id', data.user.id).single();
      
      if (pError) throw pError;

      // Normalize role before saving to fix the 'SUPER_A' truncation
      let role = profile.role.trim().toUpperCase();
      if (role.startsWith('SUPER')) role = 'SUPER_ADMIN';
      if (role.startsWith('APP')) role = 'APP_OWNER';

      localStorage.setItem('btx_session', JSON.stringify({ email: data.user.email, role }));
      navigate('/admin/dashboard');
    } catch (err: any) {
      setAuthError(lang === 'en' ? 'Authentication Failed' : 'စနစ်ဝင်ရောက်မှု မှားယွင်းနေပါသည်');
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-[#05080F] flex items-center justify-center p-4">
      <div className="w-full max-w-md bg-[#111622] rounded-3xl p-8 border-t-4 border-emerald-500 shadow-2xl">
        <div className="flex justify-center mb-6"><ShieldCheck className="text-emerald-500 h-12 w-12" /></div>
        <form onSubmit={handleLogin} className="space-y-4">
          <input type="email" placeholder="Email" className="w-full bg-[#0B0E17] text-white p-4 rounded-xl border border-white/5 outline-none focus:border-emerald-500" onChange={e => setEmail(e.target.value)} />
          <input type="password" placeholder="Password" className="w-full bg-[#0B0E17] text-white p-4 rounded-xl border border-white/5 outline-none focus:border-emerald-500" onChange={e => setPassword(e.target.value)} />
          <Button type="submit" disabled={isLoading} className="w-full bg-emerald-600 hover:bg-emerald-500 h-14 font-bold tracking-widest uppercase">
            {isLoading ? <Loader2 className="animate-spin" /> : 'Authenticate'}
          </Button>
        </form>
      </div>
    </div>
  );
}
