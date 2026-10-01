import { Card, CardHeader, CardTitle } from '../components/ui/Card';
import { useStore } from '../store/useStore';
import { formatMoney } from '../utils/formatters';

export function Budget() {
  const { budgets } = useStore();

  return (
    <div className="animate-in fade-in duration-500">
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card>
          <div className="text-xs text-[var(--muted)]">Presupuesto mensual</div>
          <div className="text-[38px] font-[800] tracking-[-1px] mt-2">{formatMoney(1700000)}</div>
        </Card>
        <Card>
          <div className="text-xs text-[var(--muted)]">Gastado</div>
          <div className="text-[38px] font-[800] tracking-[-1px] mt-2">{formatMoney(755000)}</div>
        </Card>
        <Card>
          <div className="text-xs text-[var(--muted)]">Disponible</div>
          <div className="text-[38px] font-[800] tracking-[-1px] mt-2 text-[var(--green)]">{formatMoney(945000)}</div>
        </Card>
      </div>

      <Card className="mt-4">
        <CardHeader>
          <CardTitle>Presupuesto por categorÃ­a</CardTitle>
          <span className="text-xs text-[var(--muted)]">Septiembre</span>
        </CardHeader>
        
        <div className="flex flex-col">
          {budgets.map((budget, i) => {
            const percentage = (budget.spent / budget.total) * 100;
            return (
              <div key={i} className="py-3.5 border-b border-[var(--border)] last:border-0 hover:bg-[var(--panel2)] transition-colors px-2 -mx-2 rounded-lg cursor-pointer">
                <div className="flex justify-between gap-2.5 mb-2.5 text-sm">
                  <span>{budget.category}</span>
                  <b className="font-semibold">{formatMoney(budget.spent)} / {formatMoney(budget.total)}</b>
                </div>
                <div className="h-2 bg-[var(--track)] rounded-full overflow-hidden">
                  <div 
                    className="h-full bg-[var(--green)] rounded-full transition-all duration-1000 ease-out" 
                    style={{ width: `${Math.min(percentage, 100)}%` }}
                  />
                </div>
              </div>
            );
          })}
        </div>
      </Card>
    </div>
  );
}
