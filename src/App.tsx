import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';

// Public & Layout Routes
import LandingPage from './pages/LandingPage';
import Login from './pages/Login'; 
import AdminLayout from './components/AdminLayout';

// Core Admins & L5 Command
import SuperAdminDashboard from './pages/SuperAdminDashboard';
import UserControlCenter from './pages/UserControlCenter';
import UserAccessDirectory from './pages/UserAccessDirectory';
import IdentityControl from './pages/IdentityControl';
import ShipmentControl from './pages/ShipmentControl';
import WarehouseDrop from './pages/WarehouseDrop';
import FleetCommand from './pages/FleetCommand';
import SystemSettings from './pages/SystemSettings';

// Finance & Provisioning
import OmniFinancialDashboard from './pages/OmniFinancialDashboard';
import MerchantProvisioning from './pages/MerchantProvisioning';

// Departmental Portals
import HQSurveillanceMap from './pages/HQSurveillanceMap';
import CustomerDirectory from './pages/CustomerDirectory';
import HQSurveillanceMap from './pages/HQSurveillanceMap';
import CustomerDirectory from './pages/CustomerDirectory';
import HQSurveillanceMap from './pages/HQSurveillanceMap';
import CustomerDirectory from './pages/CustomerDirectory';
import CustomerServicePortal from './pages/CustomerServicePortal';
import FinanceOperations from './pages/FinanceOperations';
import MarketingDashboard from './pages/MarketingDashboard';
import DataEntryHub from './pages/DataEntryHub';
import SupervisorDesk from './pages/SupervisorDesk';
import BranchOfficePortal from './pages/BranchOfficePortal'; // NEW IMPORT

// L3 Merchant & Universal Profile
import MerchantDashboard from './pages/MerchantDashboard';
import MerchantPortal from './pages/MerchantPortal';
import MerchantRegistration from './pages/MerchantRegistration';
import PickupRequest from './pages/PickupRequest';
import Profile from './pages/Profile';

export default function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<LandingPage />} />
        <Route path="/login" element={<Login />} />
        <Route path="/profile" element={<Profile />} />
        <Route path="/dashboard" element={<Navigate to="/admin/dashboard" replace />} />

        <Route path="/admin" element={<AdminLayout />}>
          <Route index element={<Navigate to="dashboard" replace />} />
          <Route path="dashboard" element={<SuperAdminDashboard />} />
          <Route path="live-map" element={<SuperAdminDashboard />} />
          
          <Route path="approvals" element={<UserControlCenter />} />
          <Route path="identity" element={<IdentityControl />} />
          <Route path="directory" element={<UserAccessDirectory />} />
          <Route path="shipments" element={<ShipmentControl />} />
          <Route path="warehouse-drop" element={<WarehouseDrop />} />
          <Route path="fleet" element={<FleetCommand />} />
          <Route path="settings" element={<SystemSettings />} />
          
          <Route path="omni-finance" element={<OmniFinancialDashboard />} />
          <Route path="provisioning" element={<MerchantProvisioning />} />

          {/* Departmental Routes */}
          <Route path="surveillance" element={<HQSurveillanceMap />} />
          <Route path="customers" element={<CustomerDirectory />} />
          <Route path="surveillance" element={<HQSurveillanceMap />} />
          <Route path="customers" element={<CustomerDirectory />} />
          <Route path="surveillance" element={<HQSurveillanceMap />} />
          <Route path="customers" element={<CustomerDirectory />} />
          <Route path="cs" element={<CustomerServicePortal />} />
          <Route path="finance-ops" element={<FinanceOperations />} />
          <Route path="marketing" element={<MarketingDashboard />} />
          <Route path="data-entry" element={<DataEntryHub />} />
          <Route path="supervisor" element={<SupervisorDesk />} />
          <Route path="branch" element={<BranchOfficePortal />} /> {/* NEW ROUTE */}
        </Route>

        {/* L3 Merchant Routes */}
        <Route path="/merchant/dashboard" element={<MerchantDashboard />} />
        <Route path="/merchant/portal" element={<MerchantPortal />} />
        <Route path="/merchant/register" element={<MerchantRegistration />} />
        <Route path="/merchant/pickup" element={<PickupRequest />} />

        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Router>
  );
}
