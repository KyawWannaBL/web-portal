import React, { useState } from 'react';
import { useLanguageContext } from '@/lib/LanguageContext';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { 
  Table, 
  TableBody, 
  TableCell, 
  TableHead, 
  TableHeader, 
  TableRow 
} from '@/components/ui/table';
import { 
  Package, 
  Truck, 
  AlertTriangle, 
  RotateCcw, 
  ArrowUpDown, 
  MapPin, 
  Search,
  Filter,
  Download,
  Eye,
  Edit,
  MoreHorizontal
} from 'lucide-react';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';

interface WayItem {
  id: string;
  wayId: string;
  senderName: string;
  receiverName: string;
  pickupAddress: string;
  deliveryAddress: string;
  status: 'pickup' | 'deliver' | 'failed' | 'returned' | 'transit';
  amount: number;
  date: string;
  deliveryman?: string;
  remark?: string;
}

const mockWayData: WayItem[] = [
  {
    id: '1',
    wayId: 'BE001234',
    senderName: 'Mg Aung Aung',
    receiverName: 'Ma Thida',
    pickupAddress: 'Yangon, Kamayut Township',
    deliveryAddress: 'Mandalay, Chan Aye Thar Zan',
    status: 'pickup',
    amount: 15000,
    date: '2026-02-03',
    deliveryman: 'Ko Zaw Min'
  },
  {
    id: '2',
    wayId: 'BE001235',
    senderName: 'Daw Khin Khin',
    receiverName: 'U Thant Zin',
    pickupAddress: 'Mandalay, Maha Aung Myay',
    deliveryAddress: 'Yangon, Bahan Township',
    status: 'deliver',
    amount: 12000,
    date: '2026-02-02',
    deliveryman: 'Ko Myint Swe'
  },
  {
    id: '3',
    wayId: 'BE001236',
    senderName: 'U Win Maung',
    receiverName: 'Ma Aye Aye',
    pickupAddress: 'Yangon, Sanchaung',
    deliveryAddress: 'Naypyidaw, Zabuthiri',
    status: 'failed',
    amount: 18000,
    date: '2026-02-01',
    deliveryman: 'Ko Thura',
    remark: 'Receiver not available'
  }
];

export default function WayManagement() {
  const { t, language } = useLanguageContext();
  const [searchTerm, setSearchTerm] = useState('');
  const [activeTab, setActiveTab] = useState('pickup');

  const getStatusBadge = (status: string) => {
    const statusConfig = {
      pickup: { variant: 'secondary' as const, label: t('way.pickupWays') },
      deliver: { variant: 'default' as const, label: t('way.deliverWays') },
      failed: { variant: 'destructive' as const, label: t('way.failedWays') },
      returned: { variant: 'outline' as const, label: t('way.returnWays') },
      transit: { variant: 'secondary' as const, label: t('way.transitRoute') }
    };
    
    const config = statusConfig[status as keyof typeof statusConfig];
    return <Badge variant={config.variant}>{config.label}</Badge>;
  };

  const filteredData = mockWayData.filter(item => 
    item.status === activeTab &&
    (item.wayId.toLowerCase().includes(searchTerm.toLowerCase()) ||
     item.senderName.toLowerCase().includes(searchTerm.toLowerCase()) ||
     item.receiverName.toLowerCase().includes(searchTerm.toLowerCase()))
  );

  const TabContent = ({ data }: { data: WayItem[] }) => (
    <div className="space-y-4">
      <div className="flex flex-col sm:flex-row gap-4 items-start sm:items-center justify-between">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground w-4 h-4" />
          <Input
            placeholder={t('form.search') + '...'}
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-9"
          />
        </div>
        <div className="flex gap-2">
          <Button variant="outline" size="sm">
            <Filter className="w-4 h-4 mr-2" />
            {t('form.search')}
          </Button>
          <Button variant="outline" size="sm">
            <Download className="w-4 h-4 mr-2" />
            Export
          </Button>
        </div>
      </div>

      <Card>
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>{t('common.wayId')}</TableHead>
                <TableHead>{t('form.senderName')}</TableHead>
                <TableHead>Receiver</TableHead>
                <TableHead>Pickup Location</TableHead>
                <TableHead>Delivery Location</TableHead>
                <TableHead>{t('common.amount')}</TableHead>
                <TableHead>{t('common.date')}</TableHead>
                <TableHead>Deliveryman</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {data.map((item) => (
                <TableRow key={item.id}>
                  <TableCell className="font-medium">{item.wayId}</TableCell>
                  <TableCell>{item.senderName}</TableCell>
                  <TableCell>{item.receiverName}</TableCell>
                  <TableCell className="max-w-[150px] truncate">{item.pickupAddress}</TableCell>
                  <TableCell className="max-w-[150px] truncate">{item.deliveryAddress}</TableCell>
                  <TableCell>{item.amount.toLocaleString()} MMK</TableCell>
                  <TableCell>{item.date}</TableCell>
                  <TableCell>{item.deliveryman || '-'}</TableCell>
                  <TableCell className="text-right">
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <Button variant="ghost" size="sm">
                          <MoreHorizontal className="w-4 h-4" />
                        </Button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuItem>
                          <Eye className="w-4 h-4 mr-2" />
                          View Details
                        </DropdownMenuItem>
                        <DropdownMenuItem>
                          <Edit className="w-4 h-4 mr-2" />
                          {t('form.edit')}
                        </DropdownMenuItem>
                        <DropdownMenuItem>
                          <MapPin className="w-4 h-4 mr-2" />
                          Track Location
                        </DropdownMenuItem>
                      </DropdownMenuContent>
                    </DropdownMenu>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">{t('nav.wayManagement')}</h1>
          <p className="text-muted-foreground">
            Manage pickup, delivery, failed and return ways
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">{t('way.pickupWays')}</CardTitle>
            <Package className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {mockWayData.filter(item => item.status === 'pickup').length}
            </div>
            <p className="text-xs text-muted-foreground">
              +2 from yesterday
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">{t('way.deliverWays')}</CardTitle>
            <Truck className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {mockWayData.filter(item => item.status === 'deliver').length}
            </div>
            <p className="text-xs text-muted-foreground">
              +5 from yesterday
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">{t('way.failedWays')}</CardTitle>
            <AlertTriangle className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {mockWayData.filter(item => item.status === 'failed').length}
            </div>
            <p className="text-xs text-muted-foreground">
              -1 from yesterday
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">{t('way.returnWays')}</CardTitle>
            <RotateCcw className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {mockWayData.filter(item => item.status === 'returned').length}
            </div>
            <p className="text-xs text-muted-foreground">
              No change
            </p>
          </CardContent>
        </Card>
      </div>

      <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-4">
        <TabsList className="grid w-full grid-cols-5">
          <TabsTrigger value="pickup" className="flex items-center gap-2">
            <Package className="w-4 h-4" />
            <span className="hidden sm:inline">{t('way.pickupWays')}</span>
          </TabsTrigger>
          <TabsTrigger value="deliver" className="flex items-center gap-2">
            <Truck className="w-4 h-4" />
            <span className="hidden sm:inline">{t('way.deliverWays')}</span>
          </TabsTrigger>
          <TabsTrigger value="failed" className="flex items-center gap-2">
            <AlertTriangle className="w-4 h-4" />
            <span className="hidden sm:inline">{t('way.failedWays')}</span>
          </TabsTrigger>
          <TabsTrigger value="returned" className="flex items-center gap-2">
            <RotateCcw className="w-4 h-4" />
            <span className="hidden sm:inline">{t('way.returnWays')}</span>
          </TabsTrigger>
          <TabsTrigger value="transit" className="flex items-center gap-2">
            <ArrowUpDown className="w-4 h-4" />
            <span className="hidden sm:inline">{t('way.transitRoute')}</span>
          </TabsTrigger>
        </TabsList>

        <TabsContent value="pickup">
          <TabContent data={filteredData} />
        </TabsContent>

        <TabsContent value="deliver">
          <TabContent data={filteredData} />
        </TabsContent>

        <TabsContent value="failed">
          <TabContent data={filteredData} />
        </TabsContent>

        <TabsContent value="returned">
          <TabContent data={filteredData} />
        </TabsContent>

        <TabsContent value="transit">
          <TabContent data={filteredData} />
        </TabsContent>
      </Tabs>
    </div>
  );
}