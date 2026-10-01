import { motion } from 'framer-motion';
import { cn } from '../../utils/cn';

interface LogoProps {
  className?: string;
  size?: 'sm' | 'md' | 'lg' | 'xl';
  withText?: boolean;
}

export function Logo({ className, size = 'md', withText = true }: LogoProps) {
  const iconSizes = {
    sm: 32,
    md: 48,
    lg: 64,
    xl: 128,
  };

  const s = iconSizes[size];

  return (
    <div className={cn('flex items-center gap-4', className)}>
      <motion.div
        initial={{ scale: 0.8, opacity: 0 }}
        animate={{ 
          scale: 1, 
          opacity: 1,
          y: [0, -8, 0]
        }}
        transition={{
          scale: { type: "spring", stiffness: 300, damping: 20 },
          opacity: { duration: 0.5 },
          y: {
            duration: 4,
            repeat: Infinity,
            ease: "easeInOut",
            delay: 0.5
          }
        }}
        whileHover={{ scale: 1.05, rotate: [0, -5, 5, 0] }}
        whileTap={{ scale: 0.95 }}
        className="relative cursor-pointer filter drop-shadow-[0_0_15px_rgba(16,185,129,0.3)]"
      >
        <svg width={s} height={s} viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
          {/* Background Square with Green Border */}
          <rect x="3" y="3" width="94" height="94" rx="24" fill="#09090b" stroke="#10b981" strokeWidth="6"/>
          {/* Cyan Chevron */}
          <path d="M 28 58 L 50 32 L 72 58" stroke="#06b6d4" strokeWidth="10" strokeLinecap="round" strokeLinejoin="round"/>
          {/* Green Dot */}
          <circle cx="50" cy="74" r="7" fill="#10b981"/>
        </svg>
      </motion.div>
      {withText && (
        <motion.span 
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ delay: 0.2, type: "spring" }}
          className={cn('font-extrabold tracking-tight text-[var(--green)]', 
            size === 'sm' && 'text-2xl',
            size === 'md' && 'text-4xl',
            size === 'lg' && 'text-5xl',
            size === 'xl' && 'text-7xl',
          )}
        >
          Plata
        </motion.span>
      )}
    </div>
  );
}
