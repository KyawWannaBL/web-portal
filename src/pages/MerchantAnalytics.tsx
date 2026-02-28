import React, { useState, useEffect } from 'react';
import { supabase } from '@/lib/supabase';
import { useAuth } from '@/hooks/useAuth';
import { useLanguageContext } from '@/lib/LanguageContext';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Package, DollarSign } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer } from 'recharts';

export default function MerchantAnalytics() {
  const { user } = useAuth();
  const { t } = useLanguageContext();
  const [data, setData] = useState<any[]>([]);
  const [stats, setStats] = useState({ total: 0, revenue: 0 });

  useEffect(() => {
    const fetchAnalytics = async () => {
      const { data: shipments } = await supabase
        .from('shipments')
        .select('created_at, cod_amount')
        .eq('merchant_id', user?.id);
      
      if (shipments) {
        setStats({
          total: shipments.length,
          revenue: shipments.reduce((sum, s) => sum + (Number(s.cod_amount) || 0), 0)
        });
        setData([{ name: 'Total', value: shipments.length }]);
      }
    };
    if (user) fetchAnalytics();
  }, [user]);

  return (
    <div className="p-8 space-y-8 bg-slate-50 min-h-screen">
      <h1 className="text-4xl font-bold text-navy-900">
        {t('Business Intelligence', 'စီးပွားရေး ဆန်းစစ်ချက်')}
      </h1>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <Card className="luxury-card">
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">{t('Gross Volume', 'စုစုပေါင်း ပမာဏ')}</CardTitle>
            <Package className="h-4 w-4 text-primary" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.total}</div>
          </CardContent>
        </Card>
        
        <Card className="luxury-card">
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">{t('Total Revenue', 'စုစုပေါင်း ဝင်ငွေ')}</CardTitle>
            <DollarSign className="h-4 w-4 text-emerald-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.revenue.toLocaleString()} K</div>
          </CardContent>
        </Card>
      </div>

      <Card className="p-6">
        <h3 className="font-bold mb-6">{t('Shipment Distribution', 'ပို့ဆောင်မှု ဖြန့်ကြက်မှု')}</h3>
        <div className="h-[300px]">
          <ResponsiveContainer width=\"100%\" height=\"100%\">
            <BarChart data={data}>
              <XAxis dataKey=\"name\" />
              <YAxis />
              <Tooltip />
              <Bar dataKey=\"value\" fill=\"#0d2c54\" radius={[4, 4, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </Card>
    </div>
  );
}
