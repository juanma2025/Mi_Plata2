import type { ReactNode, CSSProperties } from 'react';
import { cn } from '../../utils/cn';

interface CardProps {
  children: ReactNode;
  className?: string;
  style?: CSSProperties;
}

export function Card({ children, className, style }: CardProps) {
  return (
    <div className={cn("bg-[var(--panel)] border border-[var(--border)] rounded-[var(--radius)] p-5", className)} style={style}>
      {children}
    </div>
  );
}

export function CardHeader({ children, className }: CardProps) {
  return (
    <div className={cn("flex justify-between items-center mb-5", className)}>
      {children}
    </div>
  );
}

export function CardTitle({ children, className }: CardProps) {
  return (
    <span className={cn("font-bold text-base", className)}>
      {children}
    </span>
  );
}
