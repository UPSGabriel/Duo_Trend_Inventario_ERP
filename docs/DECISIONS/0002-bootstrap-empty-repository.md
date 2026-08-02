# ADR 0002: Bootstrap del repositorio vacío

- Estado: aceptada por el propietario.
- Fecha: 2026-08-02.

## Contexto

El repositorio remoto no contenía commits ni una referencia real `main`. GitHub no permite derivar una rama ni abrir un pull request contra una base inexistente.

## Decisión

Crear un único commit raíz mínimo en `main` con un README de inicialización. Crear inmediatamente `feat/fase-0-foundation` y realizar allí toda la Fase 0.

## Consecuencias

- La excepción a “no escribir en main” queda limitada y auditable.
- Todo cambio funcional/documental posterior se revisa por PR.
- `main` no recibe más cambios directos.
