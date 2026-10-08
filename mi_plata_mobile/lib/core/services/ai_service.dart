import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/env.dart';

final aiServiceProvider = Provider<AiService>((ref) {
  return AiService();
});

class AiService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  AiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: Env.geminiApiKey,
      systemInstruction: Content.system(
        'Eres Plata IA, un asistente financiero experto, amigable y conciso integrado en la app "MiPlata". '
        'Tu objetivo es ayudar al usuario a entender sus finanzas, darle consejos de ahorro y responder sus dudas sobre dinero. '
        'Responde siempre en español, con un tono profesional pero cercano, estilo Apple. Usa emojis de forma sutil. '
        'Mantén tus respuestas breves, estructuradas y fáciles de leer en un dispositivo móvil. '
        'No uses formato markdown excesivo, prefiere viñetas simples o texto claro.'
      ),
    );
    
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));
      return response.text ?? 'Lo siento, no pude procesar tu solicitud.';
    } catch (e) {
      return 'Error de conexión con Plata IA. Revisa tu internet o la configuración de API Key.';
    }
  }
}
