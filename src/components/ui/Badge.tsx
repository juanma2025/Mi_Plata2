import { cn } from '../../utils/cn';

export function Badge({ children, variant = 'default', className }: { children: React.ReactNode, variant?: 'default' | 'success' | 'danger' | 'warning', className?: string }) {
  const variants = {
    default: 'bg-[var(--panel2)] text-[var(--text)]',
    success: 'bg-[var(--green)]/10 text-[var(--green)] border-[var(--green)]/20',
    danger: 'bg-[var(--red)]/10 text-[var(--red)] border-[var(--red)]/20',
    warning: 'bg-[var(--yellow)]/10 text-[var(--yellow)] border-[var(--yellow)]/20'
  };
  return <span className={cn('px-2.5 py-0.5 rounded-full text-xs font-medium border border-transparent', variants[variant], className)}>{children}</span>;
}
