# Base de datos

## Principios

- PostgreSQL es la fuente oficial de verdad.
- UUID para entidades distribuidas.
- `numeric` para dinero/cantidades y `timestamptz` para instantes.
- Todas las referencias importantes usan FK y las reglas invariantes usan `CHECK`.
- Las tablas expuestas tienen RLS desde su creación.
- Las migraciones aplicadas no se editan.
- El historial operativo y financiero no se elimina desde el cliente.

## Esquema físico de Fase 0

```mermaid
erDiagram
    AUTH_USERS ||--|| PROFILES : "id"
    ORGANIZATIONS ||--o{ BUSINESS_UNITS : contains
    ORGANIZATIONS ||--o{ ORGANIZATION_MEMBERS : has
    PROFILES ||--o{ ORGANIZATION_MEMBERS : joins
    BUSINESS_UNITS o|--o{ ORGANIZATION_MEMBERS : defaults

    ORGANIZATIONS {
      uuid id PK
      text name
      text legal_name
      char3 currency_code
      text locale
      text timezone
      boolean tax_enabled
      numeric default_tax_rate
      timestamptz created_at
      timestamptz updated_at
    }
    PROFILES {
      uuid id PK_FK
      text display_name
      text email
      text avatar_url
      boolean active
      timestamptz created_at
      timestamptz updated_at
    }
    BUSINESS_UNITS {
      uuid id PK
      uuid organization_id FK
      text code
      text name
      text description
      boolean active
      timestamptz created_at
      timestamptz updated_at
    }
    ORGANIZATION_MEMBERS {
      uuid id PK
      uuid organization_id FK
      uuid user_id FK
      app_role role
      uuid default_business_unit_id FK
      boolean active
      timestamptz joined_at
      timestamptz created_at
      timestamptz updated_at
    }
```

### Restricciones destacadas

- Moneda ISO de tres letras y valores iniciales `USD`, `es_EC`, `America/Guayaquil`.
- Impuesto entre 0 y 100; queda en 0 cuando está desactivado.
- Código de unidad no vacío y único por organización.
- Una sola membresía por usuario/organización.
- FK compuesta `(organization_id, default_business_unit_id)` para impedir referencias cruzadas.
- Roles como enum: `OWNER`, `MANAGER`, `SELLER`, `VIEWER`.
- Trigger genérico y seguro para mantener `updated_at`.

## Datos iniciales

La migración crea la organización Duo Trend y las dos unidades con UUID determinísticos. No inserta usuarios, membresías ni correos. `seed.sql` incluye únicamente una segunda organización y usuarios simulados para pruebas locales cuando Supabase dispone de sus fixtures; no se enlaza a identidades reales.

La asignación de propietarios se hará en Fase 1 mediante un proceso administrativo del lado servidor que verifique la identidad, valide una invitación vigente y relacione `auth.uid()` con la organización. Los correos permanecerán exclusivamente en Supabase y no se enviarán a Flutter como configuración.

## RLS de Fase 0

Helpers del esquema `private`:

- `is_active_member(organization_id)`: membresía activa del usuario actual.
- `has_org_role(organization_id, roles[])`: membresía activa con rol permitido.
- `shares_organization(user_id)`: visibilidad limitada de perfiles.

El esquema `private` no se concede a `anon` ni `authenticated`. Las funciones necesarias para políticas se ejecutan como definidor, usan nombres calificados y `search_path` vacío.

Políticas:

| Tabla | SELECT | INSERT/UPDATE/DELETE desde cliente |
|---|---|---|
| `organizations` | Miembro activo | OWNER puede actualizar; no crear/eliminar |
| `profiles` | Propio o compañero de organización | Usuario actualiza solo su nombre/avatar; alta por trigger |
| `business_units` | Miembro activo | OWNER/MANAGER puede crear/actualizar; no eliminar |
| `organization_members` | Propia membresía u OWNER de la organización | OWNER administra, sin poder degradar/eliminar al último OWNER en una fase futura |

La Fase 0 no expone una RPC administrativa de bootstrap para evitar incorporar un flujo de invitaciones incompleto.

## Modelo lógico futuro

1. Identidad: `organizations`, `profiles`, `organization_members`, `business_units`.
2. Catálogo: `categories`, `brands`, `products`, `product_variants`, `product_images`.
3. Inventario: `stock_locations`, `stock_levels`, `inventory_movements`, `inventory_movement_items`.
4. Terceros: `customers`, `suppliers`.
5. Ventas: `sales`, `sale_items`, `sale_payments`.
6. Compras: `purchases`, `purchase_items`, `purchase_payments`.
7. Gastos: `expenses`, `expense_categories`.
8. Deudas: `accounts_receivable`, `accounts_payable`, `debt_payments`.
9. Control: `notifications`, `monthly_reports`, `audit_logs`.

## Reglas para las próximas migraciones

- SKU y barcode serán únicos por organización, con índices parciales para registros activos/no nulos.
- `stock_levels` tendrá una fila por ubicación/variante y checks de disponibilidad/reserva no negativos.
- `inventory_movements` será el libro inmutable; `stock_levels` será una proyección actualizada en la misma transacción.
- Ventas y compras guardarán snapshots de nombre, SKU, precio y costo.
- Las RPC críticas usarán una `idempotency_key` única por organización.
- Pagos no podrán ser negativos ni superar el saldo pendiente.
- Anulaciones crearán eventos compensatorios; no eliminarán la operación original.
- `audit_logs` será append-only desde funciones del servidor.

## Estrategia de pruebas

Las pruebas pgTAP verifican inicialmente:

- RLS habilitado.
- Acceso anónimo bloqueado.
- Usuario sin membresía bloqueado.
- Miembro activo puede leer únicamente su organización.
- OWNER puede actualizar su organización.
- Un rol sin permisos no puede actualizarla.
- FK compuesta impide usar una unidad de otra organización.
- Impuesto inválido y códigos vacíos son rechazados.

Las fases transaccionales añadirán pruebas de concurrencia, idempotencia, atomicidad, stock y saldos.
