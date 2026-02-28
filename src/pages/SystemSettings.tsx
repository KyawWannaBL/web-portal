import React, { useState } from 'react';
import { useLanguageContext } from '@/lib/LanguageContext';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { Separator } from '@/components/ui/separator';
import { 
  Settings as SettingsIcon, 
  Save, 
  RotateCcw, 
  Clock, 
  Percent, 
  Phone, 
  MapPin, 
  Users, 
  DollarSign,
  Package,
  Truck,
  Bell
} from 'lucide-react';
import { toast } from '@/hooks/use-toast';

interface SystemSettings {
  wayIdLength: number;
  promotionCodeLength: number;
  lastPickupHour: number;
  lastDeliverHour: number;
  returnCharges: number;
  contactPhone: string;
  maxStationDistance: number;
  sameDayPlanHour: number;
  autoAssignDeliveryman: boolean;
  autoCreateCustomer: boolean;
  autoAddRecipient: boolean;
  allowCashAdvance: boolean;
  allowDirectOrder: boolean;
  allowDirectOrderAutoAssign: boolean;
  allowDirectWayFill: boolean;
  allowDirectWayFillAutoAssign: boolean;
  remindRefund: boolean;
}

const defaultSettings: SystemSettings = {
  wayIdLength: 6,
  promotionCodeLength: 8,
  lastPickupHour: 18,
  lastDeliverHour: 20,
  returnCharges: 15,
  contactPhone: '+95 9 123 456 789',
  maxStationDistance: 5000,
  sameDayPlanHour: 14,
  autoAssignDeliveryman: true,
  autoCreateCustomer: true,
  autoAddRecipient: true,
  allowCashAdvance: false,
  allowDirectOrder: true,
  allowDirectOrderAutoAssign: false,
  allowDirectWayFill: true,
  allowDirectWayFillAutoAssign: false,
  remindRefund: true
};

export default function SystemSettings() {
  const { t } = useLanguageContext();
  const [settings, setSettings] = useState<SystemSettings>(defaultSettings);
  const [activeTab, setActiveTab] = useState('general');

  const handleSave = () => {
    // Here you would typically save to backend
    toast({
      title: "Settings Saved",
      description: "System settings have been updated successfully.",
    });
  };

  const handleReset = () => {
    setSettings(defaultSettings);
    toast({
      title: "Settings Reset",
      description: "All settings have been reset to default values.",
    });
  };

  const updateSetting = (key: keyof SystemSettings, value: any) => {
    setSettings(prev => ({ ...prev, [key]: value }));
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">{t('nav.settings')}</h1>
          <p className="text-muted-foreground">
            {t('settings.systemSettings')} - Configure system behavior and preferences
          </p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" onClick={handleReset}>
            <RotateCcw className="w-4 h-4 mr-2" />
            Reset to Default
          </Button>
          <Button onClick={handleSave}>
            <Save className="w-4 h-4 mr-2" />
            {t('form.save')}
          </Button>
        </div>
      </div>

      <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-4">
        <TabsList className="grid w-full grid-cols-4">
          <TabsTrigger value="general" className="flex items-center gap-2">
            <SettingsIcon className="w-4 h-4" />
            <span className="hidden sm:inline">General</span>
          </TabsTrigger>
          <TabsTrigger value="operations" className="flex items-center gap-2">
            <Truck className="w-4 h-4" />
            <span className="hidden sm:inline">Operations</span>
          </TabsTrigger>
          <TabsTrigger value="automation" className="flex items-center gap-2">
            <Users className="w-4 h-4" />
            <span className="hidden sm:inline">Automation</span>
          </TabsTrigger>
          <TabsTrigger value="merchant" className="flex items-center gap-2">
            <Package className="w-4 h-4" />
            <span className="hidden sm:inline">Merchant</span>
          </TabsTrigger>
        </TabsList>

        <TabsContent value="general" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>System Configuration</CardTitle>
              <CardDescription>
                Basic system settings and identifiers
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-2">
                  <Label htmlFor="wayIdLength" className="flex items-center gap-2">
                    <Package className="w-4 h-4" />
                    {t('settings.wayIdLength')}
                  </Label>
                  <Input
                    id="wayIdLength"
                    type="number"
                    min="4"
                    max="10"
                    value={settings.wayIdLength}
                    onChange={(e) => updateSetting('wayIdLength', parseInt(e.target.value))}
                  />
                  <p className="text-sm text-muted-foreground">
                    Number of digits for Way ID generation (4-10)
                  </p>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="promotionCodeLength" className="flex items-center gap-2">
                    <Percent className="w-4 h-4" />
                    {t('settings.promotionCodeLength')}
                  </Label>
                  <Input
                    id="promotionCodeLength"
                    type="number"
                    min="6"
                    max="12"
                    value={settings.promotionCodeLength}
                    onChange={(e) => updateSetting('promotionCodeLength', parseInt(e.target.value))}
                  />
                  <p className="text-sm text-muted-foreground">
                    Length of promotion codes (6-12 characters)
                  </p>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="contactPhone" className="flex items-center gap-2">
                    <Phone className="w-4 h-4" />
                    {t('settings.contactPhone')}
                  </Label>
                  <Input
                    id="contactPhone"
                    type="tel"
                    value={settings.contactPhone}
                    onChange={(e) => updateSetting('contactPhone', e.target.value)}
                  />
                  <p className="text-sm text-muted-foreground">
                    Customer support contact number
                  </p>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="maxStationDistance" className="flex items-center gap-2">
                    <MapPin className="w-4 h-4" />
                    {t('settings.maxStationDistance')}
                  </Label>
                  <Input
                    id="maxStationDistance"
                    type="number"
                    min="1000"
                    max="50000"
                    value={settings.maxStationDistance}
                    onChange={(e) => updateSetting('maxStationDistance', parseInt(e.target.value))}
                  />
                  <p className="text-sm text-muted-foreground">
                    Maximum distance between stations in meters
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="operations" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Operational Hours & Charges</CardTitle>
              <CardDescription>
                Configure pickup/delivery hours and charges
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-2">
                  <Label htmlFor="lastPickupHour" className="flex items-center gap-2">
                    <Clock className="w-4 h-4" />
                    {t('settings.lastPickupHour')}
                  </Label>
                  <Input
                    id="lastPickupHour"
                    type="number"
                    min="0"
                    max="23"
                    value={settings.lastPickupHour}
                    onChange={(e) => updateSetting('lastPickupHour', parseInt(e.target.value))}
                  />
                  <p className="text-sm text-muted-foreground">
                    Last hour for pickup (24-hour format)
                  </p>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="lastDeliverHour" className="flex items-center gap-2">
                    <Clock className="w-4 h-4" />
                    {t('settings.lastDeliverHour')}
                  </Label>
                  <Input
                    id="lastDeliverHour"
                    type="number"
                    min="0"
                    max="23"
                    value={settings.lastDeliverHour}
                    onChange={(e) => updateSetting('lastDeliverHour', parseInt(e.target.value))}
                  />
                  <p className="text-sm text-muted-foreground">
                    Last hour for delivery (24-hour format)
                  </p>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="sameDayPlanHour" className="flex items-center gap-2">
                    <Clock className="w-4 h-4" />
                    {t('settings.sameDayPlanHour')}
                  </Label>
                  <Input
                    id="sameDayPlanHour"
                    type="number"
                    min="0"
                    max="23"
                    value={settings.sameDayPlanHour}
                    onChange={(e) => updateSetting('sameDayPlanHour', parseInt(e.target.value))}
                  />
                  <p className="text-sm text-muted-foreground">
                    Cut-off hour for same-day delivery planning
                  </p>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="returnCharges" className="flex items-center gap-2">
                    <Percent className="w-4 h-4" />
                    {t('settings.returnCharges')}
                  </Label>
                  <Input
                    id="returnCharges"
                    type="number"
                    min="0"
                    max="100"
                    value={settings.returnCharges}
                    onChange={(e) => updateSetting('returnCharges', parseInt(e.target.value))}
                  />
                  <p className="text-sm text-muted-foreground">
                    Return charges as percentage of delivery fee
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="automation" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Automation Settings</CardTitle>
              <CardDescription>
                Configure automatic system behaviors
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <div className="space-y-0.5">
                    <Label className="text-base">{t('settings.autoAssignDeliveryman')}</Label>
                    <p className="text-sm text-muted-foreground">
                      Automatically assign deliverymen for pickup and delivery
                    </p>
                  </div>
                  <Switch
                    checked={settings.autoAssignDeliveryman}
                    onCheckedChange={(checked) => updateSetting('autoAssignDeliveryman', checked)}
                  />
                </div>

                <Separator />

                <div className="flex items-center justify-between">
                  <div className="space-y-0.5">
                    <Label className="text-base">{t('settings.autoCreateCustomer')}</Label>
                    <p className="text-sm text-muted-foreground">
                      Automatically create customer accounts for new recipients
                    </p>
                  </div>
                  <Switch
                    checked={settings.autoCreateCustomer}
                    onCheckedChange={(checked) => updateSetting('autoCreateCustomer', checked)}
                  />
                </div>

                <Separator />

                <div className="flex items-center justify-between">
                  <div className="space-y-0.5">
                    <Label className="text-base">{t('settings.autoAddRecipient')}</Label>
                    <p className="text-sm text-muted-foreground">
                      Automatically add recipient information to address book
                    </p>
                  </div>
                  <Switch
                    checked={settings.autoAddRecipient}
                    onCheckedChange={(checked) => updateSetting('autoAddRecipient', checked)}
                  />
                </div>

                <Separator />

                <div className="flex items-center justify-between">
                  <div className="space-y-0.5">
                    <Label className="text-base flex items-center gap-2">
                      <Bell className="w-4 h-4" />
                      {t('settings.remindRefund')}
                    </Label>
                    <p className="text-sm text-muted-foreground">
                      Remind about refund money on next pickup
                    </p>
                  </div>
                  <Switch
                    checked={settings.remindRefund}
                    onCheckedChange={(checked) => updateSetting('remindRefund', checked)}
                  />
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="merchant" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Merchant Permissions</CardTitle>
              <CardDescription>
                Configure merchant access and permissions
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <div className="space-y-0.5">
                    <Label className="text-base flex items-center gap-2">
                      <DollarSign className="w-4 h-4" />
                      {t('settings.allowCashAdvance')}
                    </Label>
                    <p className="text-sm text-muted-foreground">
                      Allow cash advance for all merchants
                    </p>
                  </div>
                  <Switch
                    checked={settings.allowCashAdvance}
                    onCheckedChange={(checked) => updateSetting('allowCashAdvance', checked)}
                  />
                </div>

                <Separator />

                <div className="flex items-center justify-between">
                  <div className="space-y-0.5">
                    <Label className="text-base">{t('settings.allowDirectOrder')}</Label>
                    <p className="text-sm text-muted-foreground">
                      Allow merchants to place direct orders
                    </p>
                  </div>
                  <Switch
                    checked={settings.allowDirectOrder}
                    onCheckedChange={(checked) => updateSetting('allowDirectOrder', checked)}
                  />
                </div>

                <Separator />

                <div className="flex items-center justify-between">
                  <div className="space-y-0.5">
                    <Label className="text-base">{t('settings.allowDirectOrderAutoAssign')}</Label>
                    <p className="text-sm text-muted-foreground">
                      Auto-assign deliverymen for merchant direct orders
                    </p>
                  </div>
                  <Switch
                    checked={settings.allowDirectOrderAutoAssign}
                    onCheckedChange={(checked) => updateSetting('allowDirectOrderAutoAssign', checked)}
                    disabled={!settings.allowDirectOrder}
                  />
                </div>

                <Separator />

                <div className="flex items-center justify-between">
                  <div className="space-y-0.5">
                    <Label className="text-base">{t('settings.allowDirectWayFill')}</Label>
                    <p className="text-sm text-muted-foreground">
                      Allow merchants to fill delivery ways directly
                    </p>
                  </div>
                  <Switch
                    checked={settings.allowDirectWayFill}
                    onCheckedChange={(checked) => updateSetting('allowDirectWayFill', checked)}
                  />
                </div>

                <Separator />

                <div className="flex items-center justify-between">
                  <div className="space-y-0.5">
                    <Label className="text-base">{t('settings.allowDirectWayFillAutoAssign')}</Label>
                    <p className="text-sm text-muted-foreground">
                      Auto-assign for merchant direct way fill
                    </p>
                  </div>
                  <Switch
                    checked={settings.allowDirectWayFillAutoAssign}
                    onCheckedChange={(checked) => updateSetting('allowDirectWayFillAutoAssign', checked)}
                    disabled={!settings.allowDirectWayFill}
                  />
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}