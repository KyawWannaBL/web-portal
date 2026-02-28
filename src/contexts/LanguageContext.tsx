import React, { createContext, useContext, useState, ReactNode } from 'react';

interface LanguageContextType {
  language: 'en' | 'my';
  setLanguage: (lang: 'en' | 'my') => void;
  t: (key: string) => string;
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

const translations = {
  en: {
    // Navigation
    dashboard: 'Dashboard',
    operations: 'Operations',
    shipments: 'Shipments',
    fleet: 'Fleet',
    warehouse: 'Warehouse',
    delivery: 'Delivery',
    analytics: 'Analytics',
    users: 'Users',
    finance: 'Finance',
    customerPortal: 'Customer Portal',
    merchantPortal: 'Merchant Portal',
    riderDashboard: 'Rider Dashboard',
    warehouseOperations: 'Warehouse Operations',
    supervisorDashboard: 'Supervisor Dashboard',
    adminDashboard: 'Admin Dashboard',
    shippingCalculator: 'Shipping Calculator',
    reports: 'Reports',
    settings: 'Settings',
    
    // Rider Specific
    riderPickup: 'Pickup',
    riderDelivery: 'Delivery',
    riderTags: 'Tag Management',
    riderLabel: 'Label Activation',
    riderWarehouse: 'Warehouse Drop',
    riderCalculator: 'Rate Calculator',
    
    // QR Code System
    qrCodeScanner: 'QR Code Scanner',
    scanQRCode: 'Scan QR Code',
    generateQRCode: 'Generate QR Code',
    qrCodeHistory: 'Scan History',
    qrCodeActive: 'Active',
    qrCodeScanned: 'Scanned',
    qrCodeExpired: 'Expired',
    
    // GPS & Tracking
    gpsTracking: 'GPS Tracking',
    currentLocation: 'Current Location',
    trackingHistory: 'Tracking History',
    batteryLevel: 'Battery Level',
    signalStrength: 'Signal Strength',
    
    // Electronic Signature
    electronicSignature: 'Electronic Signature',
    captureSignature: 'Capture Signature',
    clearSignature: 'Clear Signature',
    signatureRequired: 'Signature Required',
    
    // Route Optimization
    routeOptimization: 'Route Optimization',
    optimizeRoute: 'Optimize Route',
    routePlanning: 'Route Planning',
    estimatedTime: 'Estimated Time',
    totalDistance: 'Total Distance',

    // Common
    search: 'Search',
    filter: 'Filter',
    export: 'Export',
    print: 'Print',
    save: 'Save',
    cancel: 'Cancel',
    delete: 'Delete',
    edit: 'Edit',
    view: 'View',
    add: 'Add',
    create: 'Create',
    update: 'Update',
    submit: 'Submit',
    loading: 'Loading...',
    noData: 'No data available',
    error: 'Error',
    success: 'Success',
    warning: 'Warning',
    info: 'Information',

    // Dashboard
    totalShipments: 'Total Shipments',
    pendingShipments: 'Pending Shipments',
    deliveredShipments: 'Delivered Shipments',
    totalRevenue: 'Total Revenue',
    codCollected: 'COD Collected',
    activeVehicles: 'Active Vehicles',
    deliveryRate: 'Delivery Rate',
    recentActivities: 'Recent Activities',
    quickActions: 'Quick Actions',
    systemStatus: 'System Status',

    // Shipments
    awbNumber: 'AWB Number',
    trackingNumber: 'Tracking Number',
    senderInfo: 'Sender Information',
    receiverInfo: 'Receiver Information',
    packageDetails: 'Package Details',
    serviceType: 'Service Type',
    paymentMethod: 'Payment Method',
    shippingCost: 'Shipping Cost',
    codAmount: 'COD Amount',
    totalCost: 'Total Cost',
    status: 'Status',
    created: 'Created',
    pickedUp: 'Picked Up',
    inTransit: 'In Transit',
    outForDelivery: 'Out for Delivery',
    delivered: 'Delivered',
    failed: 'Failed',
    returned: 'Returned',

    // Users and Roles
    systemAdministrator: 'System Administrator',
    branchManager: 'Branch Manager',
    supervisor: 'Supervisor',
    rider: 'Rider',
    warehouseStaff: 'Warehouse Staff',
    financeStaff: 'Finance Staff',
    hrAdmin: 'HR Admin',
    merchant: 'Merchant',
    customer: 'Customer',

    // Locations
    yangon: 'Yangon',
    mandalay: 'Mandalay',
    naypyidaw: 'Naypyidaw',
    pathein: 'Pathein',
    mawlamyine: 'Mawlamyine',
    taunggyi: 'Taunggyi',

    // Company
    companyName: 'Britium Express',
    companyTagline: 'Myanmar\'s Premier Logistics Solution',
    welcomeMessage: 'Welcome to Britium Express Enterprise Logistics Platform',

    // Forms
    fullName: 'Full Name',
    email: 'Email',
    phone: 'Phone',
    address: 'Address',
    city: 'City',
    state: 'State',
    postalCode: 'Postal Code',
    weight: 'Weight',
    dimensions: 'Dimensions',
    description: 'Description',

    // Actions
    createShipment: 'Create Shipment',
    trackShipment: 'Track Shipment',
    updateStatus: 'Update Status',
    generateQR: 'Generate QR Code',
    scanQR: 'Scan QR Code',
    // Removed duplicates - these are already defined above

    // Status Messages
    shipmentCreated: 'Shipment created successfully',
    statusUpdated: 'Status updated successfully',
    dataLoaded: 'Data loaded successfully',
    operationFailed: 'Operation failed',
    connectionError: 'Connection error',
    invalidInput: 'Invalid input',
    accessDenied: 'Access denied',
    sessionExpired: 'Session expired'
  },
  my: {
    // Navigation
    dashboard: 'ဒက်ရှ်ဘုတ်',
    operations: 'လုပ်ငန်းများ',
    shipments: 'ကုန်ပို့ခြင်း',
    fleet: 'ယာဉ်စုံ',
    warehouse: 'ကုန်ရုံ',
    delivery: 'ပို့ဆောင်ခြင်း',
    analytics: 'ခွဲခြမ်းစိတ်ဖြာခြင်း',
    users: 'အသုံးပြုသူများ',
    finance: 'ဘဏ္ဍာရေး',
    customerPortal: 'ဖောက်သည်ပေါ်တယ်',
    merchantPortal: 'ကုန်သည်ပေါ်တယ်',
    riderDashboard: 'မောင်းသူဒက်ရှ်ဘုတ်',
    warehouseOperations: 'ကုန်ရုံလုပ်ငန်းများ',
    supervisorDashboard: 'ကြီးကြပ်သူဒက်ရှ်ဘုတ်',
    adminDashboard: 'စီမံခန့်ခွဲသူဒက်ရှ်ဘုတ်',
    shippingCalculator: 'ပို့ဆောင်ခ တွက်စက်',
    reports: 'အစီရင်ခံစာများ',
    settings: 'ဆက်တင်များ',
    
    // Rider Specific - Myanmar
    riderPickup: 'ကုန်ယူခြင်း',
    riderDelivery: 'ကုန်ပို့ခြင်း',
    riderTags: 'တံဆိပ်စီမံခြင်း',
    riderLabel: 'လေဘယ်အသက်ဝင်စေခြင်း',
    riderWarehouse: 'ကုန်ရုံသို့ပို့ခြင်း',
    riderCalculator: 'နှုန်းထားတွက်စက်',
    
    // QR Code System - Myanmar
    qrCodeScanner: 'QR ကုဒ်စကင်နာ',
    scanQRCode: 'QR ကုဒ်စကင်ဖတ်ပါ',
    generateQRCode: 'QR ကုဒ်ပြုလုပ်ပါ',
    qrCodeHistory: 'စကင်မှတ်တမ်း',
    qrCodeActive: 'အသုံးပြုနိုင်သော',
    qrCodeScanned: 'စကင်ဖတ်ပြီး',
    qrCodeExpired: 'သက်တမ်းကုန်ပြီး',
    
    // GPS & Tracking - Myanmar
    gpsTracking: 'GPS ခြေရာခံခြင်း',
    currentLocation: 'လက်ရှိတည်နေရာ',
    trackingHistory: 'ခြေရာခံမှတ်တမ်း',
    batteryLevel: 'ဘက်ထရီအဆင့်',
    signalStrength: 'အချက်ပြအင်အား',
    
    // Electronic Signature - Myanmar
    electronicSignature: 'အီလက်ထရွန်းလက်မှတ်',
    captureSignature: 'လက်မှတ်ရယူပါ',
    clearSignature: 'လက်မှတ်ရှင်းလင်းပါ',
    signatureRequired: 'လက်မှတ်လိုအပ်သည်',
    
    // Route Optimization - Myanmar
    routeOptimization: 'လမ်းကြောင်းအကောင်းဆုံးရွေးချယ်ခြင်း',
    optimizeRoute: 'လမ်းကြောင်းအကောင်းဆုံးရွေးချယ်ပါ',
    routePlanning: 'လမ်းကြောင်းစီစဉ်ခြင်း',
    estimatedTime: 'ခန့်မှန်းချိန်',
    totalDistance: 'စုစုပေါင်းအကွာအဝေး',
    
    // Pickup Flow - Myanmar
    pickupList: 'ကုန်ယူစာရင်း',
    startPickup: 'ကုန်ယူခြင်းစတင်ပါ',
    navigateToPickup: 'ကုန်ယူရာသို့သွားပါ',
    scanPackages: 'ပက်ကေ့ဂျ်များစကင်ဖတ်ပါ',
    confirmPickup: 'ကုန်ယူခြင်းအတည်ပြုပါ',
    pickupComplete: 'ကုန်ယူခြင်းပြီးစီး',
    
    // Delivery Flow - Myanmar
    deliveryList: 'ကုန်ပို့စာရင်း',
    startDelivery: 'ကုန်ပို့ခြင်းစတင်ပါ',
    navigateToDelivery: 'ကုန်ပို့ရာသို့သွားပါ',
    proofOfDelivery: 'ကုန်ပို့ခြင်းအထောက်အထား',
    collectCOD: 'COD ငွေကောက်ခံပါ',
    deliveryComplete: 'ကုန်ပို့ခြင်းပြီးစီး',
    
    // Tag Management - Myanmar
    tagBatch: 'တံဆိပ်အုပ်စု',
    scanTags: 'တံဆိပ်များစကင်ဖတ်ပါ',
    tagInventory: 'တံဆိပ်စာရင်း',
    assignTags: 'တံဆိပ်များခွဲဝေပါ',
    
    // Label Activation - Myanmar
    activateLabel: 'လေဘယ်အသက်ဝင်စေပါ',
    printLabel: 'လေဘယ်ပုံနှိပ်ပါ',
    labelStatus: 'လေဘယ်အခြေအနေ',
    
    // Warehouse Drop - Myanmar
    warehouseDrop: 'ကုန်ရုံသို့ပစ်ချခြင်း',
    dropOffConfirm: 'ပစ်ချခြင်းအတည်ပြုပါ',
    inventoryUpdate: 'စာရင်းအပ်ဒိတ်လုပ်ပါ',

    // Common
    search: 'ရှာဖွေရန်',
    filter: 'စစ်ထုတ်ရန်',
    export: 'ထုတ်ယူရန်',
    print: 'ပုံနှိပ်ရန်',
    save: 'သိမ်းဆည်းရန်',
    cancel: 'ပယ်ဖျက်ရန်',
    delete: 'ဖျက်ရန်',
    edit: 'တည်းဖြတ်ရန်',
    view: 'ကြည့်ရှုရန်',
    add: 'ထည့်ရန်',
    create: 'ဖန်တီးရန်',
    update: 'အပ်ဒိတ်လုပ်ရန်',
    submit: 'တင်သွင်းရန်',
    loading: 'လုပ်ဆောင်နေသည်...',
    noData: 'ဒေတာမရှိပါ',
    error: 'အမှား',
    success: 'အောင်မြင်ခြင်း',
    warning: 'သတိပေးချက်',
    info: 'အချက်အလက်',

    // Dashboard
    totalShipments: 'စုစုပေါင်းကုန်ပို့ခြင်း',
    pendingShipments: 'စောင့်ဆိုင်းနေသောကုန်ပို့ခြင်း',
    deliveredShipments: 'ပို့ဆောင်ပြီးသောကုန်ပို့ခြင်း',
    totalRevenue: 'စုစုပေါင်းဝင်ငွေ',
    codCollected: 'COD ကောက်ခံပြီး',
    activeVehicles: 'အသုံးပြုနေသောယာဉ်များ',
    deliveryRate: 'ပို့ဆောင်မှုနှုန်း',
    recentActivities: 'လတ်တလောလုပ်ဆောင်ချက်များ',
    quickActions: 'မြန်ဆန်သောလုပ်ဆောင်ချက်များ',
    systemStatus: 'စနစ်အခြေအနေ',

    // Shipments
    awbNumber: 'AWB နံပါတ်',
    trackingNumber: 'ခြေရာခံနံပါတ်',
    senderInfo: 'ပို့သူအချက်အလက်',
    receiverInfo: 'လက်ခံသူအချက်အလက်',
    packageDetails: 'ပက်ကေ့ဂျ်အသေးစိတ်',
    serviceType: 'ဝန်ဆောင်မှုအမျိုးအစား',
    paymentMethod: 'ငွေပေးချေမှုနည်းလမ်း',
    shippingCost: 'ပို့ဆောင်ခ',
    codAmount: 'COD ပမာណ',
    totalCost: 'စုစုပေါင်းကုန်ကျစရိတ်',
    status: 'အခြေအနေ',
    created: 'ဖန်တီးပြီး',
    pickedUp: 'ကောက်ယူပြီး',
    inTransit: 'သယ်ယူနေသည်',
    outForDelivery: 'ပို့ဆောင်ရန်ထွက်ပြီး',
    delivered: 'ပို့ဆောင်ပြီး',
    failed: 'မအောင်မြင်',
    returned: 'ပြန်ပို့ပြီး',

    // Users and Roles
    systemAdministrator: 'စနစ်စီမံခန့်ခွဲသူ',
    branchManager: 'ဌာနခွဲမန်နေဂျာ',
    supervisor: 'ကြီးကြပ်သူ',
    rider: 'မောင်းသူ',
    warehouseStaff: 'ကုန်ရုံဝန်ထမ်း',
    financeStaff: 'ဘဏ္ဍာရေးဝန်ထမ်း',
    hrAdmin: 'HR စီမံခန့်ခွဲသူ',
    merchant: 'ကုန်သည်',
    customer: 'ဖောက်သည်',

    // Locations
    yangon: 'ရန်ကုန်',
    mandalay: 'မန္တလေး',
    naypyidaw: 'နေပြည်တော်',
    pathein: 'ပုသိမ်',
    mawlamyine: 'မော်လမြိုင်',
    taunggyi: 'တောင်ကြီး',

    // Company
    companyName: 'ဘရီတီယမ် အိတ်စ်ပရက်စ်',
    companyTagline: 'မြန်မာနိုင်ငံ၏ ထိပ်တန်းလော်ဂျစ်တစ် ဖြေရှင်းချက်',
    welcomeMessage: 'ဘရီတီယမ် အိတ်စ်ပရက်စ် လုပ်ငန်းလော်ဂျစ်တစ် ပလပ်ဖောင်းသို့ ကြိုဆိုပါသည်',

    // Forms
    fullName: 'အမည်အပြည့်အစုံ',
    email: 'အီးမေးလ်',
    phone: 'ဖုန်းနံပါတ်',
    address: 'လိပ်စာ',
    city: 'မြို့',
    state: 'ပြည်နယ်/တိုင်း',
    postalCode: 'စာတိုက်နံပါတ်',
    weight: 'အလေးချိန်',
    dimensions: 'အရွယ်အစား',
    description: 'ဖော်ပြချက်',

    // Actions
    createShipment: 'ကုန်ပို့ခြင်းဖန်တီးရန်',
    trackShipment: 'ကုန်ပို့ခြင်းခြေရာခံရန်',
    updateStatus: 'အခြေအနေအပ်ဒိတ်လုပ်ရန်',
    generateQR: 'QR ကုဒ်ထုတ်လုပ်ရန်',
    scanQR: 'QR ကုဒ်စကင်န်ရန်',
    // Removed duplicates - these are already defined above

    // Status Messages
    shipmentCreated: 'ကုန်ပို့ခြင်းအောင်မြင်စွာဖန်တီးပြီးပါပြီ',
    statusUpdated: 'အခြေအနေအောင်မြင်စွာအပ်ဒိတ်လုပ်ပြီးပါပြီ',
    dataLoaded: 'ဒေတာအောင်မြင်စွာလုဒ်လုပ်ပြီးပါပြီ',
    operationFailed: 'လုပ်ဆောင်ချက်မအောင်မြင်ပါ',
    connectionError: 'ချိတ်ဆက်မှုအမှား',
    invalidInput: 'မမှန်ကန်သောထည့်သွင်းမှု',
    accessDenied: 'ဝင်ရောက်ခွင့်မရှိပါ',
    sessionExpired: 'အသုံးပြုချိန်ကုန်ဆုံးပါပြီ'
  }
};

export const LanguageProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [language, setLanguage] = useState<'en' | 'my'>('en');

  const t = (key: string): string => {
    return translations[language][key as keyof typeof translations['en']] || key;
  };

  return (
    <LanguageContext.Provider value={{ language, setLanguage, t }}>
      {children}
    </LanguageContext.Provider>
  );
};

export const useLanguage = (): LanguageContextType => {
  const context = useContext(LanguageContext);
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
};