import { ArrowUpRight, ArrowDownRight } from 'lucide-react';
import { Card, CardHeader, CardTitle } from '../components/ui/Card';
import { formatMoney } from '../utils/formatters';
import { useStore } from '../store/useStore';
import { useAuthStore } from '../store/useAuthStore';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';

export function Dashboard() {
  const { transactions } = useStore();
  const { user } = useAuthStore();
  const navigate = useNavigate();

  const containerVariants = {
    hidden: { opacity: 0 },
    show: {
      opacity: 1,
      transition: { staggerChildren: 0.1 }
    }
  };

  const itemVariants = {
    hidden: { opacity: 0, y: 20 },
    show: { opacity: 1, y: 0, transition: { type: 'spring' as const, stiffness: 400, damping: 14 } }
  };

  // Use user data or fallback to defaults
  const income = user?.monthly_income || 2600000;
  const expenses = user?.approximate_monthly_expenses || 755000;
  const budget = user?.monthly_budget || 1500000;
  const savingsGoal = user?.savings_goal || 500000;
  
  const balance = income - expenses;
  const budgetRemaining = budget - expenses;
  const budgetPercent = budget > 0 ? Math.round((budgetRemaining / budget) * 100) : 0;

  return (
    <motion.div variants={containerVariants} initial="hidden" animate="show">
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
        <motion.div variants={itemVariants}>
          <Card className="relative overflow-hidden min-h-[145px]">
            <div className="absolute w-[110px] h-[110px] rounded-full -right-[45px] -top-[45px] bg-[rgba(101,211,145,0.06)]" />
            <div className="text-[13px] text-[var(--muted)]">Saldo estimado</div>
            <div className="text-[28px] font-[750] mt-3.5 tracking-[-0.7px]">{formatMoney(balance)}</div>
            <div className="text-xs mt-3 text-[var(--green)] flex items-center gap-1"><ArrowUpRight size={14}/> 8,4% este mes</div>
          </Card>
        </motion.div>
        <motion.div variants={itemVariants}>
          <Card className="relative overflow-hidden min-h-[145px] h-full">
            <div className="text-[13px] text-[var(--muted)]">Ingresos mensuales</div>
            <div className="text-[28px] font-[750] mt-3.5 tracking-[-0.7px]">{formatMoney(income)}</div>
            <div className="text-xs mt-3 text-[var(--green)] flex items-center gap-1"><ArrowUpRight size={14}/> 5,2%</div>
          </Card>
        </motion.div>
        <motion.div variants={itemVariants}>
          <Card className="relative overflow-hidden min-h-[145px] h-full">
            <div className="text-[13px] text-[var(--muted)]">Gastos estimados</div>
            <div className="text-[28px] font-[750] mt-3.5 tracking-[-0.7px]">{formatMoney(expenses)}</div>
            <div className="text-xs mt-3 text-[var(--red)] flex items-center gap-1"><ArrowDownRight size={14}/> 3,1%</div>
          </Card>
        </motion.div>
        <motion.div variants={itemVariants}>
          <Card className="relative overflow-hidden min-h-[145px] h-full">
            <div className="text-[13px] text-[var(--muted)]">Presupuesto restante</div>
            <div className="text-[28px] font-[750] mt-3.5 tracking-[-0.7px]">{formatMoney(budgetRemaining > 0 ? budgetRemaining : 0)}</div>
            <div className="text-xs mt-3 text-[var(--muted)]">{budgetPercent > 0 ? budgetPercent : 0}% disponible</div>
          </Card>
        </motion.div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-[1.6fr_1fr] gap-4 mb-4">
        <motion.div variants={itemVariants}>
          <Card className="h-full">
          <CardHeader>
            <CardTitle>EvoluciÃ³n financiera</CardTitle>
            <span className="text-xs text-[var(--muted)]">Ãšltimos 6 meses</span>
          </CardHeader>
          <div className="h-[245px] flex items-end gap-2.5 pt-[25px] px-[5px] pb-[5px] border-b border-[var(--border)]">
            {[45, 58, 51, 68, 77, 88].map((height, i) => (
              <motion.div 
                key={i}
                initial={{ height: 0 }}
                animate={{ height: `${height}%` }}
                transition={{ duration: 0.8, delay: 0.3 + (i * 0.1), ease: "easeOut" }}
                className={`flex-1 rounded-t-[7px] rounded-b-[2px] min-h-[12px] relative transition-colors duration-300 hover:opacity-80 ${i === 5 ? 'bg-[var(--green)] hover:shadow-[0_0_15px_rgba(101,211,145,0.4)]' : 'bg-[var(--green2)]'}`} 
              >
                <span className="absolute -bottom-6 w-full text-center text-[var(--muted)] text-[11px] font-medium transition-colors hover:text-white">
                  {['Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep'][i]}
                </span>
              </motion.div>
            ))}
          </div>
          </Card>
        </motion.div>
        
        <motion.div variants={itemVariants}>
          <Card className="h-full">
          <CardHeader>
            <CardTitle>Metas de ahorro</CardTitle>
            <button className="text-xs text-[var(--muted)] hover:text-[var(--text)] transition-colors" onClick={() => navigate('/app/metas')}>Ver todas</button>
          </CardHeader>
          <div className="flex flex-col">
            {[
              { name: 'Fondo de Ahorro', progress: savingsGoal > 0 ? Math.min(100, Math.round((balance * 0.2 / savingsGoal) * 100)) : 0, saved: balance > 0 ? balance * 0.2 : 0, total: savingsGoal },
              { name: 'MacBook', progress: 72, saved: 3600000, total: 5000000 },
              { name: 'Viaje', progress: 44, saved: 880000, total: 2000000 },
            ].map((goal, i) => (
              <div key={i} className="py-3.5 border-b border-[var(--border)] last:border-0 hover:bg-[var(--panel2)] transition-colors px-3 -mx-3 rounded-lg cursor-pointer group">
                <div className="flex justify-between gap-2.5 mb-2.5">
                  <span className="font-semibold text-sm transition-colors group-hover:text-[var(--green)]">{goal.name}</span>
                  <b className="text-sm">{goal.progress}%</b>
                </div>
                <div className="h-2 bg-[var(--track)] rounded-full overflow-hidden mb-2.5">
                  <div className="h-full bg-[var(--green)] rounded-full transition-all duration-1000 group-hover:brightness-110" style={{ width: `${goal.progress}%` }}></div>
                </div>
                <div className="flex justify-between text-xs text-[var(--muted)]">
                  <span>{formatMoney(goal.saved)} ahorrados</span>
                  <span>{formatMoney(goal.total)}</span>
                </div>
              </div>
            ))}
          </div>
          </Card>
        </motion.div>
      </div>

      <motion.div variants={itemVariants}>
        <Card>
          <CardHeader>
            <CardTitle>Movimientos recientes</CardTitle>
          <button className="btn-secondary text-sm" onClick={() => navigate('/app/movimientos')}>Ver movimientos</button>
        </CardHeader>
        <div className="flex flex-col">
          {transactions.slice(0, 5).map((tx, i) => (
            <motion.div 
              key={tx.id} 
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.5 + (i * 0.1) }}
              className="grid grid-cols-[42px_1fr_auto] gap-3.5 items-center py-3.5 border-b border-[var(--border)] last:border-0 hover:bg-[var(--panel2)] -mx-5 px-5 transition-all duration-200 cursor-pointer rounded-lg hover:scale-[1.01]"
            >
              <div className="w-[42px] h-[42px] rounded-xl bg-[var(--panel2)] grid place-items-center shadow-sm">
                {tx.type === 'income' ? <ArrowUpRight className="text-[var(--green)]" size={20} /> : <ArrowDownRight className="text-[var(--red)]" size={20} />}
              </div>
              <div>
                <div className="text-sm font-semibold">{tx.name}</div>
                <div className="text-[11px] text-[var(--muted)] mt-1">{tx.category} Â· {tx.date}</div>
              </div>
              <strong className={tx.type === 'income' ? 'text-[var(--green)]' : 'text-[var(--red)]'}>
                {tx.type === 'income' ? '+' : '-'}{formatMoney(tx.amount)}
              </strong>
            </motion.div>
          ))}
        </div>
        </Card>
      </motion.div>
    </motion.div>
  );
}
