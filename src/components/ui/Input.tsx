import { forwardRef } from 'react';
import type { InputHTMLAttributes } from 'react';
import { cn } from '../../utils/cn';

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
}

export const Input = forwardRef<HTMLInputElement, InputProps>(({ className, label, error, ...props }, ref) => {
  return (
    <div className='flex flex-col gap-1.5 w-full'>
      {label && <label className='text-sm font-medium text-[var(--muted)]'>{label}</label>}
      <input ref={ref} className={cn('bg-[var(--panel)] border border-[var(--border)] text-[var(--text)] rounded-xl px-4 py-2.5 outline-none transition-all duration-200 focus:border-[var(--green)] focus:ring-2 focus:ring-[var(--green)]/20 hover:border-[var(--muted)] placeholder:text-[var(--muted)]', error && 'border-[var(--red)] focus:border-[var(--red)] focus:ring-[var(--red)]/20', className)} {...props} />
      {error && <span className='text-xs text-[var(--red)]'>{error}</span>}
    </div>
  );
});
Input.displayName = 'Input';
