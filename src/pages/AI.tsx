import { useState, useRef, useEffect } from 'react';
import { Card, CardHeader, CardTitle } from '../components/ui/Card';

interface Message {
  id: string;
  text: string;
  sender: 'user' | 'bot';
}

export function AI() {
  const [messages, setMessages] = useState<Message[]>([
    { id: '1', text: 'Hola, Juan. Puedo ayudarte a analizar tus gastos, presupuesto y metas. ¿Qué quieres revisar?', sender: 'bot' }
  ]);
  const [input, setInput] = useState('');
  const chatRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (chatRef.current) {
      chatRef.current.scrollTop = chatRef.current.scrollHeight;
    }
  }, [messages]);

  const handleSend = (text: string) => {
    if (!text.trim()) return;
    
    // Add user message
    const userMsg: Message = { id: Date.now().toString(), text, sender: 'user' };
    setMessages(prev => [...prev, userMsg]);
    setInput('');
    
    // Simulate AI response
    setTimeout(() => {
      let answer = "Según tus datos actuales, tu presupuesto restante es de $945.000 y tu gasto diario se mantiene dentro del límite estimado.";
      
      const lowerText = text.toLowerCase();
      if (lowerText.includes("gasto")) {
        answer = "Tu categoría con mayor gasto actualmente es Alimentación. Tienes $280.000 registrados este mes.";
      } else if (lowerText.includes("ahorrar")) {
        answer = "Podrías mantener aportes periódicos a tus metas. Tu meta MacBook lleva un 72% de progreso.";
      }

      setMessages(prev => [...prev, { id: (Date.now() + 1).toString(), text: answer, sender: 'bot' }]);
    }, 600);
  };

  const suggestions = [
    '¿En qué gasto más?',
    '¿Cuánto puedo gastar hoy?',
    '¿Cómo puedo ahorrar?'
  ];

  return (
    <div className="max-w-[900px] mx-auto animate-in fade-in duration-500">
      <Card>
        <CardHeader className="mb-0">
          <div>
            <div className="text-[13px] text-[var(--muted)] mb-1 uppercase tracking-wider font-semibold">ASISTENTE FINANCIERO</div>
            <CardTitle className="text-2xl">✦ PLATA IA</CardTitle>
          </div>
          <span className="text-xs text-[var(--green)] flex items-center gap-1.5">
            <span className="w-2 h-2 rounded-full bg-[var(--green)] animate-pulse"></span>
            En línea
          </span>
        </CardHeader>
        
        <div 
          ref={chatRef}
          className="h-[450px] flex flex-col gap-3.5 overflow-y-auto p-2.5 mt-4"
        >
          {messages.map(msg => (
            <div 
              key={msg.id} 
              className={`max-w-[85%] md:max-w-[72%] p-4 rounded-2xl leading-relaxed text-sm animate-in fade-in slide-in-from-bottom-2 duration-300 ${
                msg.sender === 'bot' 
                  ? 'bg-[var(--panel2)] self-start rounded-tl-sm' 
                  : 'bg-[var(--green)] text-[#08100b] self-end rounded-tr-sm'
              }`}
            >
              {msg.text}
            </div>
          ))}
        </div>
        
        <div className="flex gap-2 flex-wrap my-3">
          {suggestions.map((s, i) => (
            <button 
              key={i} 
              className="bg-[var(--panel2)] text-[var(--muted)] border border-[var(--border)] px-3 py-2 rounded-full text-xs hover:bg-[#242927] hover:text-[var(--text)] transition-colors"
              onClick={() => handleSend(s)}
            >
              {s}
            </button>
          ))}
        </div>
        
        <form 
          className="flex gap-2.5 mt-3"
          onSubmit={e => { e.preventDefault(); handleSend(input); }}
        >
          <input 
            className="input-field flex-1" 
            placeholder="Escribe una pregunta..." 
            value={input}
            onChange={e => setInput(e.target.value)}
          />
          <button type="submit" className="btn-primary" disabled={!input.trim()}>Enviar</button>
        </form>
      </Card>
    </div>
  );
}
