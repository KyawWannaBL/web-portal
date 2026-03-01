import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/lib/supabase';
import { ShieldCheck, Loader2, ArrowLeft } from 'lucide-react';

export default function Login() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    const { data, error: authError } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (authError) {
      setError(authError.message);
      setLoading(false);
    } else {
      // Success! Send them to the Smart Redirector which will push them to /admin/dashboard
      navigate('/dashboard');
    }
  };

  return (
    <div className="min-h-screen bg-[#0B101B] flex flex-col items-center justify-center p-6 relative selection:bg-emerald-500/30 font-sans">
      {/* Background Ambient Glow */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-emerald-500/10 rounded-full blur-[120px] pointer-events-none"></div>

      <button onClick={() => navigate('/')} className="absolute top-10 left-10 text-slate-500 hover:text-white flex items-center gap-2 font-bold transition-colors z-10">
        <ArrowLeft className="h-4 w-4" /> Back to Network
      </button>

      <div className="w-full max-w-md bg-[#05080F]/80 backdrop-blur-xl border border-white/10 rounded-[2rem] p-10 shadow-2xl relative z-10">
        <div className="flex flex-col items-center mb-10">
          <div className="h-16 w-16 bg-emerald-500 rounded-2xl flex items-center justify-center shadow-lg shadow-emerald-500/20 mb-6">
            <ShieldCheck className="text-white h-8 w-8" />
          </div>
          <h1 className="text-3xl font-black text-white tracking-tighter uppercase">Britium Portal</h1>
          <p className="text-slate-500 font-bold text-sm mt-2">Authenticate to Command Center</p>
        </div>

        {error && (
          <div className="mb-6 p-4 bg-rose-500/10 border border-rose-500/20 rounded-xl text-rose-400 text-sm font-bold text-center">
            {error}
          </div>
        )}

        <form onSubmit={handleLogin} className="space-y-6">
          <div>
            <label className="block text-xs font-black uppercase tracking-widest text-slate-400 mb-2">Secure Email</label>
            <input
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full bg-[#0B101B] border border-white/5 rounded-xl px-4 py-3 text-white font-medium focus:border-emerald-500/50 outline-none transition-colors placeholder:text-slate-700"
              placeholder="admin@britiumexpress.com"
            />
          </div>

          <div>
            <label className="block text-xs font-black uppercase tracking-widest text-slate-400 mb-2">Access Key</label>
            <input
              type="password"
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full bg-[#0B101B] border border-white/5 rounded-xl px-4 py-3 text-white font-medium focus:border-emerald-500/50 outline-none transition-colors placeholder:text-slate-700"
              placeholder="••••••••"
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-emerald-600 hover:bg-emerald-500 disabled:opacity-50 text-white font-black uppercase tracking-widest py-4 rounded-xl transition-all shadow-lg shadow-emerald-900/20 flex items-center justify-center gap-2 mt-4"
          >
            {loading ? <Loader2 className="h-5 w-5 animate-spin" /> : 'Enter Portal'}
          </button>
        </form>
      </div>
    </div>
  );
}
