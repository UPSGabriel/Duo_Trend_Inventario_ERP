begin;

create extension if not exists pgtap with schema extensions;

select plan(15);

select has_table('public', 'organizations', 'organizations existe');
select has_table('public', 'profiles', 'profiles existe');
select has_table('public', 'business_units', 'business_units existe');
select has_table(
  'public',
  'organization_members',
  'organization_members existe'
);

select col_type_is(
  'public',
  'organizations',
  'default_tax_rate',
  'numeric(7,4)',
  'impuestos usa numeric'
);
select col_type_is(
  'public',
  'organizations',
  'created_at',
  'timestamp with time zone',
  'instantes usan timestamptz'
);
select col_is_pk('public', 'profiles', 'id', 'profiles.id es PK');
select col_is_fk('public', 'profiles', 'id', 'profiles.id referencia auth.users');

select results_eq(
  $$
    select enumlabel::text collate "C"
    from pg_enum
    join pg_type on pg_type.oid = pg_enum.enumtypid
    join pg_namespace on pg_namespace.oid = pg_type.typnamespace
    where pg_namespace.nspname = 'public'
      and pg_type.typname = 'app_role'
    order by enumsortorder
  $$,
  array['OWNER', 'MANAGER', 'SELLER', 'VIEWER']::text[] collate "C",
  'roles previstos y ordenados'
);

select results_eq(
  $$select code collate "C" from public.business_units order by code collate "C"$$,
  array['BELLEZA_MODA', 'TECNOLOGIA_ACCESORIOS']::text[] collate "C",
  'unidades iniciales reproducibles'
);

select throws_ok(
  $$
    insert into public.organizations (
      name,
      tax_enabled,
      default_tax_rate
    ) values ('Impuesto inválido', true, 101)
  $$,
  '23514',
  null,
  'rechaza impuesto mayor a 100'
);

select throws_ok(
  $$
    insert into public.business_units (
      organization_id,
      code,
      name
    ) values (
      'd0000000-0000-4000-8000-000000000001',
      'código_incorrecto',
      'No válida'
    )
  $$,
  '23514',
  null,
  'rechaza código fuera de convención'
);

select ok(
  (
    select relrowsecurity
    from pg_class
    where oid = 'public.organizations'::regclass
  ),
  'RLS activo en organizations'
);
select ok(
  (
    select relrowsecurity
    from pg_class
    where oid = 'public.profiles'::regclass
  ),
  'RLS activo en profiles'
);
select ok(
  (
    select relrowsecurity
    from pg_class
    where oid = 'public.business_units'::regclass
  ),
  'RLS activo en business_units'
);

select * from finish();
rollback;

