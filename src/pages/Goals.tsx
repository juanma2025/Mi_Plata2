import { Card } from '../components/ui/Card';
import { useStore } from '../store/useStore';
import { formatMoney } from '../utils/formatters';
import { Plus } from 'lucide-react';

export function Goals() {
  const { goals } = useStore();

  return (
    <div className="animate-in fade-in duration-500">
      <div className="flex justify-end mb-4">
        <button className="btn-primary flex items-center gap-2">
          <Plus size={18} /> Nueva meta
        </button>
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {goals.map((goal, i) => {
          const percentage = (goal.currentAmount / goal.targetAmount) * 100;
          return (
            <Card key={goal.id} className="animate-slide-up" style={{ animationDelay: `${i * 100}ms` }}>
              <h3 className="text-xl font-bold">{goal.name}</h3>
              <p className="text-xs text-[var(--muted)] my-2 mb-4">{goal.description}</p>
              
              <div className="text-[38px] font-[800] tracking-[-1px]">{formatMoney(goal.currentAmount)}</div>
              <p className="text-xs text-[var(--muted)]">de {formatMoney(goal.targetAmount)}</p>
              
              <div className="h-2 bg-[var(--track)] rounded-full overflow-hidden mt-4 group">
                <div 
                  className="h-full bg-[var(--green)] rounded-full transition-all duration-1000 ease-out group-hover:brightness-110" 
                  style={{ width: `${Math.min(percentage, 100)}%` }}
                />
              </div>
            </Card>
          );
        })}
      </div>
    </div>
  );
}
