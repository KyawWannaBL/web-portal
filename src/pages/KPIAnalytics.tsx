import React, { useState, useEffect } from 'react';
import { supabase } from '@/lib/supabase';
import { useLanguageContext } from '@/lib/LanguageContext';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid } from 'recharts';
import { Activity, TrendingUp } from 'lucide-react';

export default function KPIAnalytics() {
  const { t } = useLanguageContext();
  const [data, setData] = useState<any[]>([]);

  useEffect(() => {
    const fetchKPIs = async () => {
      const { data: shipments } = await supabase
        .from('shipments')
        .select('status');
      
      if (shipments) {
        const counts = shipments.reduce((acc: any, s: any) => {
          acc[s.status] = (acc[s.status] || 0) + 1;
          return acc;
        }, {});
        
        setData(Object.keys(counts).map(status => ({
          status: status.toUpperCase(),
          count: counts[status]
        })));
      }
    };
    fetchKPIs();
  }, []);

  return (
    <div className="p-8 space-y-8 bg-white min-h-screen">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold text-slate-900 tracking-tight">
          {t('Efficiency Protocol Analysis', 'လုပ်ဆောင်ချက် စွမ်းရည် ဆန်းစစ်မှု')}
        </h1>
        <Activity className="text-gold-500 h-6 w-6" />
      </div>

      <Card className="rounded-[2rem] shadow-sm border border-slate-100 overflow-hidden">
        <CardContent className="p-8">
          <div className="h-[400px] w-full">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={data}>
                <defs>
                  <linearGradient id="barGradient" x1="0" y2="1">
                    <stop offset="0%" stopColor="#D4AF37" stopOpacity={1} />
                    <stop offset="100%" stopColor="#D4AF37" stopOpacity={0.6} />
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="0" vertical={false} stroke="#f8fafc" />
                <XAxis dataKey="status" axisLine={false} tickLine={false} />
                <YAxis axisLine={false} tickLine={false} />
                <Tooltip cursor={{ fill: '#f8fafc' }} />
                <Bar dataKey="count" fill="url(#barGradient)" radius={[6, 6, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
