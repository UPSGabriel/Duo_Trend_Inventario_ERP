begin;

create schema if not exists private;
revoke all on schema private from public;

create type public.app_role as enum (
  'OWNER',
  'MANAGER',
  'SELLER',
  'VIEWER'
);

create table public.organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null check (length(btrim(name)) between 1 and 120),
  legal_name text check (legal_name is null or length(btrim(legal_name)) between 1 and 160),
  currency_code text not null default 'USD'
    check (currency_code ~ '^[A-Z]{3}$'),
  locale text not null default 'es_EC'
    check (locale ~ '^[a-z]{2}_[A-Z]{2}$'),
  timezone text not null default 'America/Guayaquil'
    check (length(btrim(timezone)) between 1 and 80),
  tax_enabled boolean not null default false,
  default_tax_rate numeric(7, 4) not null default 0
    check (default_tax_rate >= 0 and default_tax_rate <= 100),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint organizations_tax_consistency check (
    tax_enabled or default_tax_rate = 0
  )
);

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null check (length(btrim(display_name)) between 1 and 120),
  email text check (email is null or length(btrim(email)) between 3 and 320),
  avatar_url text check (avatar_url is null or length(avatar_url) <= 2048),
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index profiles_email_unique_idx
  on public.profiles (lower(email))
  where email is not null;

create table public.business_units (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  code text not null check (code ~ '^[A-Z][A-Z0-9_]{1,63}$'),
  name text not null check (length(btrim(name)) between 1 and 120),
  description text check (description is null or length(description) <= 500),
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint business_units_org_code_unique unique (organization_id, code),
  constraint business_units_org_id_unique unique (organization_id, id)
);

create index business_units_organization_idx
  on public.business_units (organization_id)
  where active;

create table public.organization_members (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role public.app_role not null,
  default_business_unit_id uuid,
  active boolean not null default true,
  joined_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint organization_members_user_unique unique (organization_id, user_id),
  constraint organization_members_default_unit_fk
    foreign key (organization_id, default_business_unit_id)
    references public.business_units (organization_id, id)
    on delete restrict
);

create index organization_members_user_active_idx
  on public.organization_members (user_id, organization_id)
  where active;

create index organization_members_org_role_active_idx
  on public.organization_members (organization_id, role)
  where active;

create or replace function private.touch_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

create trigger organizations_touch_updated_at
before update on public.organizations
for each row execute function private.touch_updated_at();

create trigger profiles_touch_updated_at
before update on public.profiles
for each row execute function private.touch_updated_at();

create trigger business_units_touch_updated_at
before update on public.business_units
for each row execute function private.touch_updated_at();

create trigger organization_members_touch_updated_at
before update on public.organization_members
for each row execute function private.touch_updated_at();

create or replace function private.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  safe_display_name text;
begin
  safe_display_name := coalesce(
    nullif(btrim(new.raw_user_meta_data ->> 'full_name'), ''),
    nullif(btrim(new.raw_user_meta_data ->> 'name'), ''),
    nullif(split_part(coalesce(new.email, ''), '@', 1), ''),
    'Usuario'
  );

  insert into public.profiles (id, display_name, email, avatar_url)
  values (
    new.id,
    left(safe_display_name, 120),
    lower(new.email),
    nullif(left(coalesce(new.raw_user_meta_data ->> 'avatar_url', ''), 2048), '')
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function private.handle_new_auth_user();

create or replace function private.is_active_member(target_organization_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.organization_members as membership
    where membership.organization_id = target_organization_id
      and membership.user_id = auth.uid()
      and membership.active
  );
$$;

create or replace function private.has_org_role(
  target_organization_id uuid,
  allowed_roles public.app_role[]
)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.organization_members as membership
    where membership.organization_id = target_organization_id
      and membership.user_id = auth.uid()
      and membership.active
      and membership.role = any(allowed_roles)
  );
$$;

create or replace function private.shares_organization(target_user_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.organization_members as mine
    join public.organization_members as theirs
      on theirs.organization_id = mine.organization_id
    where mine.user_id = auth.uid()
      and mine.active
      and theirs.user_id = target_user_id
      and theirs.active
  );
$$;

revoke all on function private.touch_updated_at() from public;
revoke all on function private.handle_new_auth_user() from public;
revoke all on function private.is_active_member(uuid) from public;
revoke all on function private.has_org_role(uuid, public.app_role[]) from public;
revoke all on function private.shares_organization(uuid) from public;

grant usage on schema private to authenticated;
grant execute on function private.is_active_member(uuid) to authenticated;
grant execute on function private.has_org_role(uuid, public.app_role[]) to authenticated;
grant execute on function private.shares_organization(uuid) to authenticated;

alter table public.organizations enable row level security;
alter table public.organizations force row level security;
alter table public.profiles enable row level security;
alter table public.profiles force row level security;
alter table public.business_units enable row level security;
alter table public.business_units force row level security;
alter table public.organization_members enable row level security;
alter table public.organization_members force row level security;

revoke all on public.organizations from anon, authenticated;
revoke all on public.profiles from anon, authenticated;
revoke all on public.business_units from anon, authenticated;
revoke all on public.organization_members from anon, authenticated;

grant select on public.organizations to authenticated;
grant update (
  name,
  legal_name,
  currency_code,
  locale,
  timezone,
  tax_enabled,
  default_tax_rate
) on public.organizations to authenticated;

grant select on public.profiles to authenticated;
grant update (display_name, avatar_url) on public.profiles to authenticated;

grant select on public.business_units to authenticated;
grant insert (id, organization_id, code, name, description, active)
  on public.business_units to authenticated;
grant update (code, name, description, active)
  on public.business_units to authenticated;

grant select on public.organization_members to authenticated;
grant insert (
  id,
  organization_id,
  user_id,
  role,
  default_business_unit_id,
  active,
  joined_at
) on public.organization_members to authenticated;
grant update (role, default_business_unit_id, active)
  on public.organization_members to authenticated;

create policy organizations_select_member
on public.organizations
for select
to authenticated
using (private.is_active_member(id));

create policy organizations_update_owner
on public.organizations
for update
to authenticated
using (private.has_org_role(id, array['OWNER']::public.app_role[]))
with check (private.has_org_role(id, array['OWNER']::public.app_role[]));

create policy profiles_select_related
on public.profiles
for select
to authenticated
using (id = auth.uid() or private.shares_organization(id));

create policy profiles_update_self
on public.profiles
for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid());

create policy business_units_select_member
on public.business_units
for select
to authenticated
using (private.is_active_member(organization_id));

create policy business_units_insert_manager
on public.business_units
for insert
to authenticated
with check (
  private.has_org_role(
    organization_id,
    array['OWNER', 'MANAGER']::public.app_role[]
  )
);

create policy business_units_update_manager
on public.business_units
for update
to authenticated
using (
  private.has_org_role(
    organization_id,
    array['OWNER', 'MANAGER']::public.app_role[]
  )
)
with check (
  private.has_org_role(
    organization_id,
    array['OWNER', 'MANAGER']::public.app_role[]
  )
);

create policy organization_members_select_self_or_owner
on public.organization_members
for select
to authenticated
using (
  user_id = auth.uid()
  or private.has_org_role(
    organization_id,
    array['OWNER']::public.app_role[]
  )
);

create policy organization_members_insert_owner
on public.organization_members
for insert
to authenticated
with check (
  private.has_org_role(
    organization_id,
    array['OWNER']::public.app_role[]
  )
);

create policy organization_members_update_owner
on public.organization_members
for update
to authenticated
using (
  private.has_org_role(
    organization_id,
    array['OWNER']::public.app_role[]
  )
)
with check (
  private.has_org_role(
    organization_id,
    array['OWNER']::public.app_role[]
  )
);

insert into public.organizations (
  id,
  name,
  currency_code,
  locale,
  timezone,
  tax_enabled,
  default_tax_rate
)
values (
  'd0000000-0000-4000-8000-000000000001',
  'Duo Trend',
  'USD',
  'es_EC',
  'America/Guayaquil',
  false,
  0
)
on conflict (id) do nothing;

insert into public.business_units (
  id,
  organization_id,
  code,
  name,
  description
)
values
  (
    'd1000000-0000-4000-8000-000000000001',
    'd0000000-0000-4000-8000-000000000001',
    'TECNOLOGIA_ACCESORIOS',
    'Tecnología y accesorios',
    'Accesorios para celulares y productos tecnológicos.'
  ),
  (
    'd1000000-0000-4000-8000-000000000002',
    'd0000000-0000-4000-8000-000000000001',
    'BELLEZA_MODA',
    'Belleza, moda y cosmética',
    'Maquillaje, cosméticos, ropa y accesorios de moda.'
  )
on conflict (id) do nothing;

comment on table public.organizations is
  'Organizaciones aisladas por RLS. Duo Trend es la organización inicial.';
comment on table public.profiles is
  'Perfil mínimo asociado uno a uno con auth.users; no concede membresía.';
comment on table public.business_units is
  'Unidades operativas dentro de una organización.';
comment on table public.organization_members is
  'Membresías y roles efectivos por organización.';

commit;
