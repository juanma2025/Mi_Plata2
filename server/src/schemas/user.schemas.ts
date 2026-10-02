import { z } from 'zod';

export const updateProfileSchema = z.object({
  body: z.object({
    name: z
      .string()
      .min(2, 'El nombre debe tener al menos 2 caracteres')
      .max(100, 'El nombre no debe superar 100 caracteres')
      .trim()
      .optional(),
    avatar_url: z.string().url('URL de avatar inválida').max(500).optional(),
  }),
});

export type UpdateProfileInput = z.infer<typeof updateProfileSchema>['body'];
