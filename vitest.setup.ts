import { vi } from 'vitest';

vi.stubGlobal('defineEventHandler', vi.fn(handler => handler));
