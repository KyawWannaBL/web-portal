import React from 'react';
import { User, Mail, Shield, MapPin, Calendar, Camera, Key } from 'lucide-react';
import { useAuth } from '@/hooks/useAuth';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';

export default function Profile() {
  const { user, role } = useAuth();

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold tracking-tight">Account Settings</h1>
        <Badge className="bg-emerald-100 text-emerald-700 hover:bg-emerald-100 border-none px-3 py-1">
          {role} Account
        </Badge>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {/* Left Column: Avatar & Quick Info */}
        <Card className="md:col-span-1">
          <CardContent className="pt-6 flex flex-col items-center text-center">
            <div className="relative group cursor-pointer">
              <div className="h-24 w-24 rounded-full bg-slate-100 flex items-center justify-center text-slate-400 border-2 border-dashed border-slate-200 group-hover:border-primary transition-colors">
                <User size={40} />
              </div>
              <div className="absolute bottom-0 right-0 p-1.5 bg-primary text-white rounded-full border-2 border-white">
                <Camera size={14} />
              </div>
            </div>
            <h2 className="mt-4 font-bold text-lg">{user?.full_name || 'System User'}</h2>
            <p className="text-sm text-slate-500">{user?.email}</p>
          </CardContent>
        </Card>

        {/* Right Column: Details Form */}
        <Card className="md:col-span-2">
          <CardHeader>
            <CardTitle>Personal Information</CardTitle>
            <CardDescription>Update your profile details and contact information.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-2">
                <label className="text-sm font-medium flex items-center gap-2">
                  <User size={14} /> Full Name
                </label>
                <Input defaultValue={user?.full_name || ''} />
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium flex items-center gap-2">
                  <Mail size={14} /> Email
                </label>
                <Input defaultValue={user?.email || ''} disabled />
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium flex items-center gap-2">
                <MapPin size={14} /> Assigned Branch ID
              </label>
              <Input defaultValue={user?.branch_id || 'Global / Not Assigned'} disabled />
            </div>

            <div className="pt-4 flex gap-3">
              <Button className="bg-blue-600 hover:bg-blue-500">Save Changes</Button>
              <Button variant="outline"><Key className="mr-2 h-4 w-4" /> Change Password</Button>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Security Section */}
      <Card className="border-rose-100 bg-rose-50/30">
        <CardHeader>
          <CardTitle className="text-rose-900 flex items-center gap-2">
            <Shield className="h-5 w-5" /> Account Security
          </CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-rose-700 mb-4">
            Manage your session and account authentication methods.
          </p>
          <Button variant="destructive">Sign Out All Devices</Button>
        </CardContent>
      </Card>
    </div>
  );
}