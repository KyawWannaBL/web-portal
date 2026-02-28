import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useLanguageContext } from '@/lib/LanguageContext';
import { Button } from '@/components/ui/button';
import { Smartphone, ShieldCheck, Truck } from 'lucide-react';

export default function LandingPage() {
  const navigate = useNavigate();
  const { t } = useLanguageContext();
  const apkUrl = import.meta.env.VITE_APK_URL || '#';

  return (
    <div className="min-h-screen bg-navy-950 text-white flex flex-col items-center justify-center p-6 text-center">
      <div className="space-y-6 max-w-2xl">
        <h1 className="text-5xl md:text-7xl font-bold tracking-tighter uppercase">
          Britium <span className="text-emerald-500">Express</span>
        </h1>
        <p className="text-lg text-white/60 uppercase tracking-widest">
          {t('Enterprise Logistics Intelligence', 'လုပ်ငန်းသုံး ပို့ဆောင်ရေးဆိုင်ရာ ဉာဏ်ရည်တုစနစ်')}
        </p>
        
        <div className="flex flex-col sm:flex-row gap-4 justify-center pt-8">
          <Button 
            size="lg" 
            className="bg-emerald-600 hover:bg-emerald-500 h-16 px-10 rounded-2xl font-bold text-lg"
            onClick={() => window.location.href = apkUrl}
          >
            <Smartphone className="mr-2 h-5 w-5" /> {t('Download Mobile App', 'မိုဘိုင်းလ်အက်ပ် ရယူရန်')}
          </Button>
          <Button 
            size="lg" 
            variant="outline" 
            className="border-white/10 hover:bg-white/5 h-16 px-10 rounded-2xl font-bold text-lg"
            onClick={() => navigate('/login')}
          >
            {t('Staff Portal', 'ဝန်ထမ်းများအတွက်')}
          </Button>
        </div>
      </div>
    </div>
  );
}
