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
  Store, 
  Plus, 
  Receipt, 
  DollarSign, 
  CreditCard, 
  Calendar, 
  Search,
  Filter,
  Download,
  Eye,
  Edit,
  MoreHorizontal,
  Phone,
  Mail,
  MapPin
} from 'lucide-react';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';

interface Merchant {
  id: string;
  merchantId: string;
  name: string;
  phone: string;
  email: string;
  address: string;
  activeWays: number;
  completedWays: number;
  toRefund: number;
  priceProfile: string;
  status: 'active' | 'inactive' | 'suspended';
  joinDate: string;
  totalRevenue: number;
}

const mockMerchants: Merchant[] = [
  {
    id: '1',
    merchantId: 'M001',
    name: 'Golden Shop',
    phone: '+95 9 123 456 789',
    email: 'golden@shop.com',
    address: 'Yangon, Kamayut Township',
    activeWays: 15,
    completedWays: 245,
    toRefund: 50000,
    priceProfile: 'Premium',
    status: 'active',
    joinDate: '2025-01-15',
    totalRevenue: 2500000
  },
  {
    id: '2',
    merchantId: 'M002',
    name: 'Tech Store Myanmar',
    phone: '+95 9 987 654 321',
    email: 'tech@store.mm',
    address: 'Mandalay, Chan Aye Thar Zan',
    activeWays: 8,
    completedWays: 156,
    toRefund: 25000,
    priceProfile: 'Standard',
    status: 'active',
    joinDate: '2025-03-20',
    totalRevenue: 1800000
  },
  {
    id: '3',
    merchantId: 'M003',
    name: 'Fashion Hub',
    phone: '+95 9 555 666 777',
    email: 'fashion@hub.com',
    address: 'Yangon, Bahan Township',
    activeWays: 3,
    completedWays: 89,
    toRefund: 15000,
    priceProfile: 'Basic',
    status: 'inactive',
    joinDate: '2025-06-10',
    totalRevenue: 950000
  }
];

export default function Merchants() {
  const { t, language } = useLanguageContext();
  const [searchTerm, setSearchTerm] = useState('');
  const [activeTab, setActiveTab] = useState('list');
  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false);

  const getStatusBadge = (status: string) => {
    const statusConfig = {
      active: { variant: 'default' as const, label: 'Active' },
      inactive: { variant: 'secondary' as const, label: 'Inactive' },
      suspended: { variant: 'destructive' as const, label: 'Suspended' }
    };
    
    const config = statusConfig[status as keyof typeof statusConfig];
    return <Badge variant={config.variant}>{config.label}</Badge>;
  };

  const filteredMerchants = mockMerchants.filter(merchant => 
    merchant.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    merchant.merchantId.toLowerCase().includes(searchTerm.toLowerCase()) ||
    merchant.phone.includes(searchTerm)
  );

  const AddMerchantDialog = () => (
    <Dialog open={isAddDialogOpen} onOpenChange={setIsAddDialogOpen}>
      <DialogTrigger asChild>
        <Button>
          <Plus className="w-4 h-4 mr-2" />
          {t('merchant.addNew')}
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[600px]">
        <DialogHeader>
          <DialogTitle>{t('merchant.addNew')}</DialogTitle>
          <DialogDescription>
            Add a new merchant to the system
          </DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 py-4">
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="name">{t('merchant.name')}</Label>
              <Input id="name" placeholder="Enter merchant name" />
            </div>
            <div className="space-y-2">
              <Label htmlFor="phone">{t('merchant.phone')}</Label>
              <Input id="phone" placeholder="+95 9 xxx xxx xxx" />
            </div>
          </div>
          <div className="space-y-2">
            <Label htmlFor="email">Email</Label>
            <Input id="email" type="email" placeholder="merchant@example.com" />
          </div>
          <div className="space-y-2">
            <Label htmlFor="address">Address</Label>
            <Textarea id="address" placeholder="Enter full address" />
          </div>
          <div className="space-y-2">
            <Label htmlFor="priceProfile">{t('merchant.priceProfile')}</Label>
            <Select>
              <SelectTrigger>
                <SelectValue placeholder="Select price profile" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="basic">Basic</SelectItem>
                <SelectItem value="standard">Standard</SelectItem>
                <SelectItem value="premium">Premium</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={() => setIsAddDialogOpen(false)}>
            {t('form.cancel')}
          </Button>
          <Button onClick={() => setIsAddDialogOpen(false)}>
            {t('form.save')}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">{t('nav.merchants')}</h1>
          <p className="text-muted-foreground">
            Manage merchants, receipts, and financial operations
          </p>
        </div>
        <AddMerchantDialog />
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Merchants</CardTitle>
            <Store className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{mockMerchants.length}</div>
            <p className="text-xs text-muted-foreground">
              +2 new this month
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Active Merchants</CardTitle>
            <Store className="h-4 w-4 text-green-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {mockMerchants.filter(m => m.status === 'active').length}
            </div>
            <p className="text-xs text-muted-foreground">
              {Math.round((mockMerchants.filter(m => m.status === 'active').length / mockMerchants.length) * 100)}% of total
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Revenue</CardTitle>
            <DollarSign className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {mockMerchants.reduce((sum, m) => sum + m.totalRevenue, 0).toLocaleString()} MMK
            </div>
            <p className="text-xs text-muted-foreground">
              +12% from last month
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">{t('merchant.toRefund')}</CardTitle>
            <CreditCard className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {mockMerchants.reduce((sum, m) => sum + m.toRefund, 0).toLocaleString()} MMK
            </div>
            <p className="text-xs text-muted-foreground">
              Pending refunds
            </p>
          </CardContent>
        </Card>
      </div>

      <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-4">
        <TabsList className="grid w-full grid-cols-5">
          <TabsTrigger value="list" className="flex items-center gap-2">
            <Store className="w-4 h-4" />
            <span className="hidden sm:inline">{t('merchant.list')}</span>
          </TabsTrigger>
          <TabsTrigger value="receipts" className="flex items-center gap-2">
            <Receipt className="w-4 h-4" />
            <span className="hidden sm:inline">{t('merchant.receipts')}</span>
          </TabsTrigger>
          <TabsTrigger value="financial" className="flex items-center gap-2">
            <DollarSign className="w-4 h-4" />
            <span className="hidden sm:inline">{t('merchant.financialCenter')}</span>
          </TabsTrigger>
          <TabsTrigger value="invoicing" className="flex items-center gap-2">
            <Calendar className="w-4 h-4" />
            <span className="hidden sm:inline">{t('merchant.invoiceScheduling')}</span>
          </TabsTrigger>
          <TabsTrigger value="accounts" className="flex items-center gap-2">
            <CreditCard className="w-4 h-4" />
            <span className="hidden sm:inline">{t('merchant.bankAccountList')}</span>
          </TabsTrigger>
        </TabsList>

        <TabsContent value="list" className="space-y-4">
          <div className="flex flex-col sm:flex-row gap-4 items-start sm:items-center justify-between">
            <div className="relative flex-1 max-w-sm">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground w-4 h-4" />
              <Input
                placeholder={t('form.search') + ' merchants...'}
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-9"
              />
            </div>
            <div className="flex gap-2">
              <Button variant="outline" size="sm">
                <Filter className="w-4 h-4 mr-2" />
                Filter
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
                    <TableHead>{t('merchant.merchantId')}</TableHead>
                    <TableHead>{t('merchant.name')}</TableHead>
                    <TableHead>{t('merchant.phone')}</TableHead>
                    <TableHead>Email</TableHead>
                    <TableHead>{t('merchant.activeWays')}</TableHead>
                    <TableHead>{t('merchant.completedWays')}</TableHead>
                    <TableHead>{t('merchant.toRefund')}</TableHead>
                    <TableHead>{t('merchant.priceProfile')}</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead className="text-right">Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filteredMerchants.map((merchant) => (
                    <TableRow key={merchant.id}>
                      <TableCell className="font-medium">{merchant.merchantId}</TableCell>
                      <TableCell>
                        <div>
                          <div className="font-medium">{merchant.name}</div>
                          <div className="text-sm text-muted-foreground flex items-center">
                            <MapPin className="w-3 h-3 mr-1" />
                            {merchant.address}
                          </div>
                        </div>
                      </TableCell>
                      <TableCell>
                        <div className="flex items-center">
                          <Phone className="w-3 h-3 mr-1" />
                          {merchant.phone}
                        </div>
                      </TableCell>
                      <TableCell>
                        <div className="flex items-center">
                          <Mail className="w-3 h-3 mr-1" />
                          {merchant.email}
                        </div>
                      </TableCell>
                      <TableCell>
                        <Badge variant="secondary">{merchant.activeWays}</Badge>
                      </TableCell>
                      <TableCell>{merchant.completedWays}</TableCell>
                      <TableCell className="text-red-600 font-medium">
                        {merchant.toRefund.toLocaleString()} MMK
                      </TableCell>
                      <TableCell>
                        <Badge variant="outline">{merchant.priceProfile}</Badge>
                      </TableCell>
                      <TableCell>{getStatusBadge(merchant.status)}</TableCell>
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
                              <Receipt className="w-4 h-4 mr-2" />
                              View Receipts
                            </DropdownMenuItem>
                            <DropdownMenuItem>
                              <DollarSign className="w-4 h-4 mr-2" />
                              Financial Details
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
        </TabsContent>

        <TabsContent value="receipts">
          <Card>
            <CardHeader>
              <CardTitle>{t('merchant.receipts')}</CardTitle>
              <CardDescription>
                View and manage merchant receipts and payment records
              </CardDescription>
            </CardHeader>
            <CardContent>
              <p className="text-muted-foreground">Receipts management interface will be implemented here.</p>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="financial">
          <Card>
            <CardHeader>
              <CardTitle>{t('merchant.financialCenter')}</CardTitle>
              <CardDescription>
                Merchant financial overview and management
              </CardDescription>
            </CardHeader>
            <CardContent>
              <p className="text-muted-foreground">Financial center interface will be implemented here.</p>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="invoicing">
          <Card>
            <CardHeader>
              <CardTitle>{t('merchant.invoiceScheduling')}</CardTitle>
              <CardDescription>
                Schedule and manage merchant invoices
              </CardDescription>
            </CardHeader>
            <CardContent>
              <p className="text-muted-foreground">Invoice scheduling interface will be implemented here.</p>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="accounts">
          <Card>
            <CardHeader>
              <CardTitle>{t('merchant.bankAccountList')}</CardTitle>
              <CardDescription>
                Manage merchant bank accounts and payment methods
              </CardDescription>
            </CardHeader>
            <CardContent>
              <p className="text-muted-foreground">Bank account management interface will be implemented here.</p>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}