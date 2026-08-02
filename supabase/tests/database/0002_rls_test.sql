begin;

create extension if not exists pgtap with schema extensions;

select plan(10);

insert into auth.users (
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
)
values
  (
    'a0000000-0000-4000-8000-000000000001',
    'authenticated',
    'authenticated',
    'owner@example.invalid',
    extensions.crypt('not-a-real-password', extensions.gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"full_name":"Demo Owner"}'::jsonb,
    now(),
    now()
  ),
  (
    'a0000000-0000-4000-8000-000000000002',
    'authenticated',
    'authenticated',
    'viewer@example.invalid',
    extensions.crypt('not-a-real-password', extensions.gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"full_name":"Demo Viewer"}'::jsonb,
    now(),
    now()
  ),
  (
    'a0000000-0000-4000-8000-000000000003',
    'authenticated',
    'authenticated',
    'outsider@example.invalid',
    extensions.crypt('not-a-real-password', extensions.gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"full_name":"Demo Outsider"}'::jsonb,
    now(),
    now()
  );

insert into public.organization_members (
  id,
  organization_id,
  user_id,
  role,
  default_business_unit_id
)
values
  (
    'b0000000-0000-4000-8000-000000000001',
    'd0000000-0000-4000-8000-000000000001',
    'a0000000-0000-4000-8000-000000000001',
    'OWNER',
    'd1000000-0000-4000-8000-000000000001'
  ),
  (
    'b0000000-0000-4000-8000-000000000002',
    'd0000000-0000-4000-8000-000000000001',
    'a0000000-0000-4000-8000-000000000002',
    'VIEWER',
    'd1000000-0000-4000-8000-000000000002'
  );

set local role anon;
select is(
  (select count(*) from public.organizations),
  0::bigint,
  'anon no puede leer organizaciones'
);
reset role;

set local role authenticated;
select set_config(
  'request.jwt.claims',
  '{"sub":"a0000000-0000-4000-8000-000000000003","role":"authenticated"}',
  true
);
select is(
  (select count(*) from public.organizations),
  0::bigint,
  'usuario sin membresía no puede leer organizaciones'
);
select is(
  (select count(*) from public.business_units),
  0::bigint,
  'usuario sin membresía no puede leer unidades'
);
reset role;

set local role authenticated;
select set_config(
  'request.jwt.claims',
  '{"sub":"a0000000-0000-4000-8000-000000000002","role":"authenticated"}',
  true
);
select is(
  (select count(*) from public.organizations),
  1::bigint,
  'VIEWER puede leer su organización'
);
select is(
  (select count(*) from public.business_units),
  2::bigint,
  'VIEWER puede leer unidades de su organización'
);
update public.organizations
set name = 'Cambio no permitido'
where id = 'd0000000-0000-4000-8000-000000000001';
select is(
  (select name from public.organizations limit 1),
  'Duo Trend'::text,
  'VIEWER no puede actualizar organización'
);
reset role;

set local role authenticated;
select set_config(
  'request.jwt.claims',
  '{"sub":"a0000000-0000-4000-8000-000000000001","role":"authenticated"}',
  true
);
select is(
  (select count(*) from public.organization_members),
  2::bigint,
  'OWNER puede listar membresías de su organización'
);
update public.organizations
set legal_name = 'Nombre legal de prueba'
where id = 'd0000000-0000-4000-8000-000000000001';
select is(
  (
    select legal_name
    from public.organizations
    where id = 'd0000000-0000-4000-8000-000000000001'
  ),
  'Nombre legal de prueba'::text,
  'OWNER puede actualizar organización'
);
select is(
  (select count(*) from public.profiles),
  2::bigint,
  'OWNER ve perfiles de compañeros, no del usuario ajeno'
);
select is(
  (select count(*) from public.business_units where active),
  2::bigint,
  'OWNER ve unidades activas de la organización'
);
reset role;

select * from finish();
rollback;
