-- ════════════════════════════════════════
-- DK SCHEDULE — SUPABASE SETUP
-- Запустить в SQL Editor → New Query
-- ════════════════════════════════════════

-- 1. Таблица слотов (занятость + записи)
CREATE TABLE public.calendar_slots (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  slot_date   DATE NOT NULL,
  slot_time   TIME NOT NULL,
  status      TEXT NOT NULL CHECK (status IN ('busy', 'booked')),
  booked_by   TEXT,
  label       TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(slot_date, slot_time)
);

-- 2. Таблица PIN-кодов (добавлять специалистов сюда)
CREATE TABLE public.access_pins (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  pin         TEXT NOT NULL UNIQUE,
  role        TEXT NOT NULL DEFAULT 'specialist',
  name        TEXT NOT NULL,
  active      BOOLEAN DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Убираем RLS (внутренний инструмент, всё норм)
ALTER TABLE public.calendar_slots DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.access_pins    DISABLE ROW LEVEL SECURITY;

-- 4. Включить Realtime для слотов
ALTER PUBLICATION supabase_realtime ADD TABLE public.calendar_slots;

-- 5. Добавить первый PIN для специалиста
--    ПОМЕНЯЙ '1234' на что хочешь перед запуском
INSERT INTO public.access_pins (pin, role, name)
VALUES ('1234', 'specialist', 'Специалист');

-- Добавить ещё одного специалиста/менеджера:
-- INSERT INTO public.access_pins (pin, role, name) VALUES ('5678', 'specialist', 'Имя');
