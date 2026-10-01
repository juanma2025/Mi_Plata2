import type { ButtonHTMLAttributes } from 'react';
import { cn } from '../../utils/cn';
import { Loader2 } from 'lucide-react';

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost';
  isLoading?: boolean;
}

export function Button({ className, variant = 'primary', isLoading, children, disabled, ...props }: ButtonProps) {
  const base = 'inline-flex items-center justify-center rounded-xl font-semibold transition-all duration-200 active:scale-95 disabled:opacity-50 disabled:pointer-events-none';
  const variants = {
    primary: 'bg-[var(--green)] text-[#09120d] hover:brightness-110 shadow-[0_4px_14px_rgba(16,185,129,0.2)] hover:shadow-[0_6px_20px_rgba(16,185,129,0.3)]',
    secondary: 'bg-[var(--panel2)] text-[var(--text)] border border-[var(--border)] hover:bg-[var(--border)]',
    outline: 'border-2 border-[var(--border)] text-[var(--text)] hover:border-[var(--green)] hover:text-[var(--green)]',
    ghost: 'text-[var(--text)] hover:bg-[var(--panel2)]'
  };
  const sizes = 'px-5 py-2.5';

  return (
    <button className={cn(base, variants[variant], sizes, className)} disabled={disabled || isLoading} {...props}>
      {isLoading && <Loader2 className='mr-2 h-4 w-4 animate-spin' />} {children}
    </button>
  );
}
