import React from 'react';
import { ShieldAlert, Home, ArrowLeft } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useNavigate } from 'react-router-dom';

export default function Unauthorized() {
  const navigate = useNavigate();

  return (
    <div className="flex flex-col items-center justify-center min-h-[80vh] text-center px-4">
      <div className="bg-destructive/10 p-6 rounded-full mb-6 text-destructive">
        <ShieldAlert className="w-16 h-16" />
      </div>
      <h1 className="text-3xl font-bold mb-2 tracking-tight">Access Denied</h1>
      <p className="text-muted-foreground max-w-md mb-8">
        Your account level does not have the required permissions to access this administrative module.
      </p>
      <div className="flex gap-4">
        <Button variant="outline" onClick={() => navigate(-1)}>
          <ArrowLeft className="w-4 h-4 mr-2" /> Go Back
        </Button>
        <Button onClick={() => navigate('/')}>
          <Home className="w-4 h-4 mr-2" /> Home
        </Button>
      </div>
    </div>
  );
}
