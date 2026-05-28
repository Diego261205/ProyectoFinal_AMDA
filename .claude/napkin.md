# Napkin Runbook — AMDA Control de Servicios

## Curation Rules
- Re-prioritize on every read.
- Keep recurring, high-value notes only.
- Max 10 items per category.
- Each item includes date + "Do instead".

## Execution & Validation (Highest Priority)

1. **[2026-05-27] CSS versión desincronizada entre JSPs**
   Do instead: al modificar style.css, buscar `style.css?v=` en todos los JSP y actualizar todos a la misma versión.

2. **[2026-05-27] Labels sin `for` en formularios**
   Do instead: cada `<label>` necesita `for="id"` y cada input correspondiente necesita `id="id"`. Aplicar en agregar_registro.jsp y editar_registro.jsp.

3. **[2026-05-27] Sin `lang` en `<html>`**
   Do instead: todos los JSP deben tener `<html lang="es-MX">`.

## Domain Behavior Guardrails

1. **[2026-05-27] editar_registro.jsp inhabilitado por requerimiento**
   Do instead: el archivo redirige a dashboard.jsp en la línea 10. No modificar la lógica de edición sin confirmar con el usuario.

2. **[2026-05-27] Columnas JS-indexadas en dashboard.jsp**
   Do instead: el JavaScript usa `row.cells[N]` por índice de columna. Si se agregan/quitan columnas al `<table>`, actualizar todos los índices en `filterTable()` y `sortTable()`. Ocultar con CSS es seguro; eliminar del DOM rompe el JS.

3. **[2026-05-27] Agencia "Chevrolet Herrera Motors" con doble nombre en BD**
   Do instead: hay registros con `cliente_nombre = "Chevrolet"` o `"Herrera Motors"`. El código ya normaliza esto en el display; mantener la condición especial en consultas SQL que filtren por esa agencia.

## User Directives

1. **[2026-05-27] Usuarios no-técnicos, objetivo claridad y confianza**
   Do instead: priorizar etiquetas en texto claro, botones con icono + texto, touch targets ≥44px, mensajes de error amigables (nunca exponer errores de BD). Registro: product. Tono: moderno pero sencillo.
