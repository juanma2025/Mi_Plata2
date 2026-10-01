import { Card, CardHeader, CardTitle } from '../components/ui/Card';

export function Analytics() {
  return (
    <div className="animate-in fade-in duration-500">
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
        <Card className="min-h-[145px]">
          <div className="text-[13px] text-[var(--muted)]">Promedio diario</div>
          <div className="text-[28px] font-[750] mt-3.5 tracking-[-0.7px]">$25.167</div>
          <div className="text-xs mt-3 text-[var(--muted)]">gasto promedio</div>
        </Card>
        <Card className="min-h-[145px]">
          <div className="text-[13px] text-[var(--muted)]">ProyecciÃ³n mensual</div>
          <div className="text-[28px] font-[750] mt-3.5 tracking-[-0.7px]">$830.500</div>
          <div className="text-xs mt-3 text-[var(--muted)]">estimaciÃ³n</div>
        </Card>
        <Card className="min-h-[145px]">
          <div className="text-[13px] text-[var(--muted)]">Gastos hormiga</div>
          <div className="text-[28px] font-[750] mt-3.5 tracking-[-0.7px]">$86.000</div>
          <div className="text-xs mt-3 text-[var(--muted)]">8 movimientos</div>
        </Card>
        <Card className="min-h-[145px]">
          <div className="text-[13px] text-[var(--muted)]">Salud del presupuesto</div>
          <div className="text-[28px] font-[750] mt-3.5 tracking-[-0.7px] text-[var(--green)]">82%</div>
          <div className="text-xs mt-3 text-[var(--muted)]">ritmo controlado</div>
        </Card>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-[1.6fr_1fr] gap-4">
        <Card>
          <CardHeader>
            <CardTitle>Gastos por categorÃ­a</CardTitle>
          </CardHeader>
          <div className="h-[245px] flex items-end gap-2.5 pt-[25px] px-[5px] pb-[5px] border-b border-[var(--border)]">
            {[70, 42, 35, 28, 20].map((height, i) => (
              <div 
                key={i} 
                className={`flex-1 rounded-t-[7px] rounded-b-[2px] min-h-[12px] relative transition-all duration-700 ease-out hover:opacity-80 animate-slide-up ${i === 0 ? 'bg-[var(--green)] hover:shadow-[0_0_15px_rgba(101,211,145,0.4)]' : 'bg-[var(--green2)]'}`} 
                style={{ height: `${height}%`, animationDelay: `${i * 100}ms` }}
              >
                <span className="absolute -bottom-6 w-full text-center text-[var(--muted)] text-[11px] transition-colors hover:text-white">
                  {['Alim.', 'Edu.', 'Trans.', 'Ocio', 'Otros'][i]}
                </span>
              </div>
            ))}
          </div>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>ComparaciÃ³n</CardTitle>
            <span className="text-xs text-[var(--muted)]">vs. agosto</span>
          </CardHeader>
          <div className="flex flex-col">
            <div className="py-3.5 border-b border-[var(--border)]">
              <div className="flex justify-between gap-2.5 text-sm">
                <span>Ingresos</span>
                <b className="font-semibold text-[var(--green)]">+5,2%</b>
              </div>
            </div>
            <div className="py-3.5 border-b border-[var(--border)]">
              <div className="flex justify-between gap-2.5 text-sm">
                <span>Gastos</span>
                <b className="font-semibold text-[var(--red)]">+3,1%</b>
              </div>
            </div>
            <div className="py-3.5 border-b border-[var(--border)] border-none pb-0">
              <div className="flex justify-between gap-2.5 text-sm">
                <span>Ahorro</span>
                <b className="font-semibold text-[var(--green)]">+8,4%</b>
              </div>
            </div>
          </div>
        </Card>
      </div>
    </div>
  );
}
