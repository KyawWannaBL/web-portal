import React from 'react';
import { Badge } from '@/components/ui/badge';
import { cn } from '@/lib/utils';

export interface StatusBadgeProps {
  status?: any;
  type?: string;
  size?: string;
  className?: string;
}

export const StatusBadge: React.FC<StatusBadgeProps> = ({ status, type, size, className }) => {
  return <Badge className={cn(className)}>{String(status || 'PENDING')}</Badge>;
};
export default StatusBadge;
