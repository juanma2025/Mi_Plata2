import { z } from 'zod';

export const updateProfileSchema = z.object({
  body: z.object({
    full_name: z.string().min(2).max(100).trim().optional(),
    avatar_url: z.string().url().max(500).optional(),
  }),
});

export const onboardingSchema = z.object({
  body: z.object({
    monthly_income: z.number().min(0, 'El ingreso no puede ser negativo'),
    main_income_source: z.string().min(1, 'Selecciona una fuente de ingresos'),
    approximate_monthly_expenses: z.number().min(0),
    monthly_budget: z.number().min(0),
    savings_goal: z.number().min(0),
    main_expense_categories: z.array(z.string()).min(1, 'Selecciona al menos una categoría'),
  }),
});

export type UpdateProfileInput = z.infer<typeof updateProfileSchema>['body'];
export type OnboardingInput = z.infer<typeof onboardingSchema>['body'];
