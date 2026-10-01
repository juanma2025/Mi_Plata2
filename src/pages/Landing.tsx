import { Link } from 'react-router-dom';
import { Button } from '../components/ui/Button';
import { ArrowRight, BarChart2, PieChart, Target, Zap } from 'lucide-react';
import { useAuthStore } from '../store/useAuthStore';
import { motion } from 'framer-motion';

export function Landing() {
  const { isAuthenticated } = useAuthStore();

  return (
    <div className="flex flex-col min-h-[calc(100vh-4rem)]">
      {/* Hero Section */}
      <section className="flex-1 flex flex-col items-center justify-center text-center px-4 py-20 bg-gradient-to-b from-[var(--bg)] to-[var(--panel2)]">
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[var(--green)]/10 text-[var(--green)] text-sm font-medium mb-8 animate-fade-in">
          <Zap size={16} />
          <span>El futuro de tus finanzas personales</span>
        </div>
        <motion.h1 
          initial={{ opacity: 0, scale: 0.5, y: 50 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          transition={{ type: "spring", stiffness: 400, damping: 15 }}
          className="text-5xl md:text-7xl font-extrabold tracking-tight mb-6 max-w-4xl"
        >
          Controla tu dinero. Entiende tus hábitos. <span className="text-[var(--green)]">Construye tus metas.</span>
        </motion.h1>
        <motion.p 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ type: "spring", stiffness: 300, damping: 20, delay: 0.2 }}
          className="text-lg md:text-xl text-[var(--muted)] mb-10 max-w-2xl"
        >
          MiPlata es la plataforma financiera definitiva para gestionar tu presupuesto, rastrear gastos y planificar tu futuro con el poder de la Inteligencia Artificial.
        </motion.p>
        <motion.div 
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ type: "spring", stiffness: 400, damping: 12, delay: 0.3 }}
          className="flex flex-col sm:flex-row gap-4"
        >
          {isAuthenticated ? (
            <Link to="/app">
              <Button className="h-14 px-8 text-lg w-full sm:w-auto">Ir a mi panel <ArrowRight className="ml-2" /></Button>
            </Link>
          ) : (
            <>
              <Link to="/register">
                <Button className="h-14 px-8 text-lg w-full sm:w-auto">Comenzar ahora <ArrowRight className="ml-2" /></Button>
              </Link>
              <Link to="/login">
                <Button variant="outline" className="h-14 px-8 text-lg w-full sm:w-auto">Iniciar sesión</Button>
              </Link>
            </>
          )}
        </motion.div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-24 bg-[var(--bg)] px-4">
        <div className="container mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold mb-4">Todo lo que necesitas en un solo lugar</h2>
            <p className="text-[var(--muted)] text-lg">Herramientas profesionales diseñadas para potenciar tu salud financiera.</p>
          </div>
          
          <motion.div 
            initial="hidden"
            whileInView="show"
            viewport={{ once: true, margin: "-100px" }}
            variants={{
              hidden: { opacity: 0 },
              show: { opacity: 1, transition: { staggerChildren: 0.15 } }
            }}
            className="grid md:grid-cols-3 gap-8 max-w-5xl mx-auto"
          >
            <motion.div 
              variants={{
                hidden: { opacity: 0, scale: 0.5, y: 50 },
                show: { opacity: 1, scale: 1, y: 0, transition: { type: 'spring', stiffness: 350, damping: 14 } }
              }}
              whileHover={{ scale: 1.05, rotate: 1, y: -10 }}
              whileTap={{ scale: 0.95, rotate: -1 }}
              className="bg-[var(--panel)] p-8 rounded-3xl border border-[var(--border)] transition-colors hover:border-[var(--green)] hover:shadow-[0_20px_40px_rgba(16,185,129,0.15)] cursor-pointer"
            >
              <div className="w-14 h-14 rounded-2xl bg-[var(--green)]/10 text-[var(--green)] flex items-center justify-center mb-6">
                <PieChart size={28} />
              </div>
              <h3 className="text-xl font-bold mb-3">Control de Presupuestos</h3>
              <p className="text-[var(--muted)] leading-relaxed">Establece límites mensuales por categoría y recibe alertas cuando estés cerca de excederlos.</p>
            </motion.div>
            
            <motion.div 
              variants={{
                hidden: { opacity: 0, scale: 0.5, y: 50 },
                show: { opacity: 1, scale: 1, y: 0, transition: { type: 'spring', stiffness: 350, damping: 14 } }
              }}
              whileHover={{ scale: 1.05, rotate: -1, y: -10 }}
              whileTap={{ scale: 0.95, rotate: 1 }}
              className="bg-[var(--panel)] p-8 rounded-3xl border border-[var(--border)] transition-colors hover:border-[var(--green)] hover:shadow-[0_20px_40px_rgba(16,185,129,0.15)] cursor-pointer"
            >
              <div className="w-14 h-14 rounded-2xl bg-[var(--green)]/10 text-[var(--green)] flex items-center justify-center mb-6">
                <Target size={28} />
              </div>
              <h3 className="text-xl font-bold mb-3">Metas de Ahorro</h3>
              <p className="text-[var(--muted)] leading-relaxed">Define objetivos claros, separa el dinero virtualmente y observa cómo crece tu progreso mes a mes.</p>
            </motion.div>

            <motion.div 
              variants={{
                hidden: { opacity: 0, scale: 0.5, y: 50 },
                show: { opacity: 1, scale: 1, y: 0, transition: { type: 'spring', stiffness: 350, damping: 14 } }
              }}
              whileHover={{ scale: 1.05, rotate: 1, y: -10 }}
              whileTap={{ scale: 0.95, rotate: -1 }}
              className="bg-[var(--panel)] p-8 rounded-3xl border border-[var(--border)] transition-colors hover:border-[var(--green)] hover:shadow-[0_20px_40px_rgba(16,185,129,0.15)] cursor-pointer"
            >
              <div className="w-14 h-14 rounded-2xl bg-[var(--green)]/10 text-[var(--green)] flex items-center justify-center mb-6">
                <BarChart2 size={28} />
              </div>
              <h3 className="text-xl font-bold mb-3">Análisis Profundo</h3>
              <p className="text-[var(--muted)] leading-relaxed">Visualiza tus hábitos con gráficos detallados, identifica gastos hormiga y proyecta tu futuro financiero.</p>
            </motion.div>
          </motion.div>
        </div>
      </section>
    </div>
  );
}
