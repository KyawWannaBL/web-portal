import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { useLanguageContext } from '@/lib/LanguageContext';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Lock, Mail, ShieldCheck } from 'lucide-react';

export default function LoginPage() {
  const { login } = useAuth();
  const { t } = useLanguageContext();
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      await login(email, password);
      navigate('/');
    } catch (err) {
      alert(t('Login Failed', 'ဝင်ရောက်မှု မအောင်မြင်ပါ'));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className=\"min-h-screen flex items-center justify-center bg-navy-950 p-4\">
      <Card className=\"w-full max-w-md bg-white/5 border-white/10 backdrop-blur-xl\">
        <CardContent className=\"pt-10 pb-10 space-y-8\">
          <div className=\"text-center\">
            <ShieldCheck className=\"h-16 w-16 text-gold-500 mx-auto mb-4\" />
            <h1 className=\"text-2xl font-black text-white tracking-widest uppercase\">
              {t('Identity Verification', 'အထောက်အထား အတည်ပြုခြင်း')}
            </h1>
          </div>
          <form onSubmit={handleLogin} className=\"space-y-4\">
            <div className=\"relative\">
              <Mail className=\"absolute left-3 top-3 h-4 w-4 text-white/40\" />
              <Input 
                type=\"email\" 
                placeholder={t('Identity (Email)', 'အီးမေးလ်')} 
                className=\"bg-black/20 border-white/10 text-white pl-10 h-12\"
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>
            <div className=\"relative\">
              <Lock className=\"absolute left-3 top-3 h-4 w-4 text-white/40\" />
              <Input 
                type=\"password\" 
                placeholder={t('Security Key', 'လျှို့ဝှက်နံပါတ်')} 
                className=\"bg-black/20 border-white/10 text-white pl-10 h-12\"
                onChange={(e) => setPassword(e.target.value)}
              />
            </div>
            <Button type=\"submit\" disabled={loading} className=\"w-full h-12 bg-gold-500 hover:bg-gold-600 text-navy-950 font-bold\">
              {loading ? t('Verifying...', 'စစ်ဆေးနေသည်...') : t('Initiate Session', 'စတင်ဝင်ရောက်မည်')}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
