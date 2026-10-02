import { z } from 'zod';

export const chatSchema = z.object({
  body: z.object({
    message: z
      .string()
      .min(1, 'El mensaje no puede estar vacío')
      .max(2000, 'El mensaje no debe superar 2000 caracteres')
      .trim(),
    history: z
      .array(
        z.object({
          role: z.enum(['user', 'assistant']),
          content: z.string().max(4000),
        })
      )
      .max(20, 'El historial no debe superar 20 mensajes')
      .optional()
      .default([]),
  }),
});

export type ChatInput = z.infer<typeof chatSchema>['body'];
