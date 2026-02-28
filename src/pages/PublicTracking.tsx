import React, { useState } from 'react';
import { 
  Search, 
  Package, 
  MapPin, 
  Clock, 
  CheckCircle,
  Truck,
  Home
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';

export default function PublicTracking() {
  const [trackingId, setTrackingId] = useState('');
  const [trackingResult, setTrackingResult] = useState<any>(null);
  const [isLoading, setIsLoading] = useState(false);

  const handleTrack = async () => {
    if (!trackingId.trim()) return;
    
    setIsLoading(true);
    
    // Simulate API call
    setTimeout(() => {
      // Mock tracking data
      setTrackingResult({
        id: trackingId,
        status: 'In Transit',
        statusColor: 'bg-blue-100 text-blue-800',
        lastUpdated: 'Just now',
        from: 'Yangon',
        to: 'Mandalay',
        estimatedDelivery: 'Tomorrow, 2:00 PM',
        timeline: [
          {
            status: 'Order Placed',
            location: 'Yangon',
            time: 'Oct 24, 2026 - 9:00 AM',
            completed: true,
            icon: CheckCircle,
          },
          {
            status: 'Picked Up',
            location: 'East Dagon Hub',
            time: 'Oct 24, 2026 - 11:30 AM',
            completed: true,
            icon: Package,
          },
          {
            status: 'In Transit',
            location: 'Highway Express',
            time: 'Oct 24, 2026 - 2:15 PM',
            completed: true,
            icon: Truck,
          },
          {
            status: 'Out for Delivery',
            location: 'Mandalay Hub',
            time: 'Expected: Oct 25, 2026 - 1:00 PM',
            completed: false,
            icon: MapPin,
          },
          {
            status: 'Delivered',
            location: 'Destination',
            time: 'Expected: Oct 25, 2026 - 2:00 PM',
            completed: false,
            icon: Home,
          },
        ],
      });
      setIsLoading(false);
    }, 1000);
  };

  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">Track & Trace</h1>
          <p className="text-xl text-gray-600">Real-time status updates for your shipments.</p>
        </div>

        {/* Tracking Form */}
        <Card className="mb-8">
          <CardHeader>
            <CardTitle className="text-center">Track Your Shipment</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex flex-col sm:flex-row gap-4 max-w-md mx-auto">
              <div className="flex-1">
                <Input
                  placeholder="Enter tracking number (e.g., BE-89744)"
                  value={trackingId}
                  onChange={(e) => setTrackingId(e.target.value)}
                  onKeyPress={(e) => e.key === 'Enter' && handleTrack()}
                />
              </div>
              <Button 
                onClick={handleTrack} 
                disabled={isLoading || !trackingId.trim()}
                className="bg-primary hover:bg-primary/90"
              >
                {isLoading ? (
                  <>
                    <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                    Tracking...
                  </>
                ) : (
                  <>
                    <Search className="w-4 h-4 mr-2" />
                    TRACK
                  </>
                )}
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* Tracking Results */}
        {trackingResult && (
          <div className="space-y-6">
            {/* Status Overview */}
            <Card>
              <CardContent className="p-6">
                <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                  <div>
                    <div className="flex items-center gap-3 mb-2">
                      <Badge className={trackingResult.statusColor}>
                        {trackingResult.status}
                      </Badge>
                      <span className="text-sm text-gray-500">ID: {trackingResult.id}</span>
                    </div>
                    <p className="text-sm text-gray-600">
                      <Clock className="w-4 h-4 inline mr-1" />
                      Last Updated: {trackingResult.lastUpdated}
                    </p>
                  </div>
                  
                  <div className="flex items-center gap-8">
                    <div className="text-center">
                      <p className="text-sm text-gray-500">From</p>
                      <p className="font-semibold">{trackingResult.from}</p>
                    </div>
                    <div className="text-center">
                      <p className="text-sm text-gray-500">To</p>
                      <p className="font-semibold">{trackingResult.to}</p>
                    </div>
                  </div>
                </div>
                
                {trackingResult.estimatedDelivery && (
                  <div className="mt-4 p-3 bg-blue-50 rounded-lg">
                    <p className="text-sm text-blue-800">
                      <MapPin className="w-4 h-4 inline mr-1" />
                      Estimated Delivery: {trackingResult.estimatedDelivery}
                    </p>
                  </div>
                )}
              </CardContent>
            </Card>

            {/* Timeline */}
            <Card>
              <CardHeader>
                <CardTitle>Shipment Timeline</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-6">
                  {trackingResult.timeline.map((event: any, index: number) => (
                    <div key={index} className="flex items-start gap-4">
                      <div className={`flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center ${
                        event.completed 
                          ? 'bg-green-100 text-green-600' 
                          : 'bg-gray-100 text-gray-400'
                      }`}>
                        <event.icon className="w-5 h-5" />
                      </div>
                      
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center justify-between">
                          <h3 className={`text-sm font-medium ${
                            event.completed ? 'text-gray-900' : 'text-gray-500'
                          }`}>
                            {event.status}
                          </h3>
                          <span className={`text-xs ${
                            event.completed ? 'text-gray-600' : 'text-gray-400'
                          }`}>
                            {event.time}
                          </span>
                        </div>
                        <p className={`text-sm ${
                          event.completed ? 'text-gray-600' : 'text-gray-400'
                        }`}>
                          {event.location}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Additional Info */}
            <Card>
              <CardContent className="p-6">
                <div className="grid md:grid-cols-2 gap-6">
                  <div>
                    <h3 className="font-semibold text-gray-900 mb-2">Need Help?</h3>
                    <p className="text-sm text-gray-600 mb-3">
                      Contact our customer service for any questions about your shipment.
                    </p>
                    <div className="space-y-1 text-sm">
                      <p className="text-gray-600">📞 +95 9 897 4477 44</p>
                      <p className="text-gray-600">✉️ info@britiumexpress.com</p>
                    </div>
                  </div>
                  
                  <div>
                    <h3 className="font-semibold text-gray-900 mb-2">Business Hours</h3>
                    <div className="space-y-1 text-sm text-gray-600">
                      <p>Monday - Saturday: 9:00 AM - 5:30 PM</p>
                      <p>Sunday: Closed</p>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        )}

        {/* No Results */}
        {trackingId && !trackingResult && !isLoading && (
          <Card>
            <CardContent className="p-8 text-center">
              <Package className="w-16 h-16 text-gray-400 mx-auto mb-4" />
              <h3 className="text-lg font-semibold text-gray-900 mb-2">No Results Found</h3>
              <p className="text-gray-600">
                We couldn't find any shipment with tracking ID "{trackingId}". 
                Please check the number and try again.
              </p>
            </CardContent>
          </Card>
        )}
      </div>
    </div>
  );
}