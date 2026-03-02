
import React, { Suspense } from 'react';

import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';

import { LanguageProvider } from './contexts/LanguageContext';

import AdminLayout from './components/AdminLayout';



// Direct Page Imports

import Login from './pages/Login';

import SignUp from "./pages/SignUp";

import ForgotPassword from './pages/ForgotPassword';

import SuperAdminDashboard from './pages/SuperAdminDashboard';

import AccountControl from './pages/AccountControl';

import HRPortal from './pages/HRPortal';



const Loading = () => (

  <div className="min-h-screen bg-[#05080F] flex items-center justify-center text-[10px] text-emerald-500 font-mono tracking-widest uppercase animate-pulse">

    INITIALIZING L5 SECURE GATEWAY...

  </div>

);



export default function App() {

  return (

    <LanguageProvider>

      <Suspense fallback={<Loading />}>

        <Router>

          <Routes>

            {/* Public Authentication Routes */}

            <Route path="/login" element={<Login />} />

            <Route path="/signup" element={<Signup />} />

            <Route path="/forgot-password" element={<ForgotPassword />} />

            

            {/* Authenticated L5 Command Center */}

            <Route path="/admin" element={<AdminLayout />}>

              <Route index element={<Navigate to="dashboard" replace />} />

              <Route path="dashboard" element={<SuperAdminDashboard />} />

              <Route path="accounts" element={<AccountControl />} />

              <Route path="hr" element={<HRPortal />} />

            </Route>



            {/* Default Fallback Redirects */}

            <Route path="/" element={<Navigate to="/login" replace />} />

            <Route path="*" element={<Navigate to="/login" replace />} />

          </Routes>

        </Router>

      </Suspense>

    </LanguageProvider>

  );

}

