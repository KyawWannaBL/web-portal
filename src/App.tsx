import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { LanguageProvider } from '@/lib/LanguageContext';
import { AuthProvider } from '@/hooks/useAuth'; // Ensure this exists or use useEnhancedAuth
import LandingPage from '@/pages/LandingPage';
import LoginPage from '@/pages/LoginPage';
import EnhancedDashboard from '@/pages/EnhancedDashboard';
import Ways from '@/pages/Ways';

export default function App() {
  return (
    <LanguageProvider>
      <Router>
        <Routes>
          <Route path="/" element={<LandingPage />} />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/dashboard" element={<EnhancedDashboard />} />
          <Route path="/ways" element={<Ways />} />
        </Routes>
      </Router>
    </LanguageProvider>
  );
}
