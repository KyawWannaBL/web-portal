import React from 'react';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { ShieldCheck, Truck, Smartphone, ArrowRight } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useLanguageContext } from '@/lib/LanguageContext';
import { fadeInUp, staggerContainer } from '@/lib/motion';

export default function LandingPage() {
  const navigate = useNavigate();
  const { t } = useLanguageContext();
  const apkUrl = import.meta.env.VITE_APK_URL || '#';

  return (
    <div className="min-h-screen bg-slate-950 text-white overflow-hidden">
      <nav className="p-6 flex justify-between items-center border-b border-white/10">
        <div className="flex items-center gap-2">
          <div className="h-10 w-10 bg-emerald-500 rounded-lg" />
          <span className="text-xl font-bold tracking-tighter">BRITIUM EXPRESS</span>
        </div>
        <Button variant="ghost" onClick={() => navigate('/login')} className="text-white hover:bg-white/10">
          {t('Enterprise Login', 'လုပ်ငန်းခွင်သို့ဝင်ရန်')}
        </Button>
      </nav>

      <motion.section 
        variants={staggerContainer} initial="hidden" animate="visible"
        className="max-w-7xl mx-auto px-6 py-20 text-center space-y-8"
      >
        <motion.h1 variants={fadeInUp} className="text-5xl md:text-7xl font-black leading-tight">
          {t('Logistics Intelligence', 'ပို့ဆောင်ရေးဆိုင်ရာ ဉာဏ်ရည်တုစနစ်')} <br/>
          <span className="text-emerald-500">{t('Redefined for 2026', '၂၀၂၆ အတွက် အသစ်တစ်ဖန်')}</span>
        </motion.h1>
        
        <motion.p variants={fadeInUp} className="text-white/60 text-xl max-w-2xl mx-auto">
          {t('Empowering Myanmar’s supply chain with non-repudiable tracking and real-time telemetry.', 'မြန်မာ့ထောက်ပံ့ရေးကွင်းဆက်ကို တိုက်ရိုက်ခြေရာခံစနစ်ဖြင့် အားဖြည့်ပေးနေပါသည်။')}
        </motion.p>

        <motion.div variants={fadeInUp} className="flex flex-col sm:flex-row justify-center gap-4">
          <Button size="lg" className="bg-emerald-600 hover:bg-emerald-500 px-10 h-16 text-lg rounded-2xl" onClick={() => window.location.href = apkUrl}>
            <Smartphone className="mr-2 h-5 w-5" /> {t('Download Mobile App', 'မိုဘိုင်းလ်အက်ပ် ရယူရန်')}
          </Button>
        </motion.div>
      </motion.section>
    </div>
  );
}
