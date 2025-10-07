# 🤖 Guía Rápida: Claude Code en Neovim

## 📋 Tabla de Contenidos
- [Inicio Rápido](#inicio-rápido)
- [Enviar Código a Claude](#enviar-código-a-claude)
- [Keymaps Completos](#keymaps-completos)
- [Ejemplos Prácticos](#ejemplos-prácticos)
- [Persistencia de Conversaciones](#persistencia-de-conversaciones)
- [Workflows Automatizados](#workflows-automatizados)
- [Tips y Trucos](#tips-y-trucos)

---

## 🚀 Inicio Rápido

### Iniciar Claude Code
```vim
<leader>ai    " Abre Claude en panel lateral
<leader>ar    " Resume última conversación (PERSISTENCIA)
<leader>aC    " Continúa conversación actual
```

### Primera vez
1. Abre Neovim en tu proyecto
2. Presiona `<leader>ai`
3. Claude se abre en panel derecho (45% de ancho)
4. ¡Listo para chatear!

---

## 📤 Enviar Código a Claude

### 1️⃣ **Enviar Selección Visual** (Más común)
```vim
" Pasos:
1. Modo visual: V (línea) o v (caracteres)
2. Selecciona el código
3. <leader>as

" Claude recibe:
" - Archivo: src/utils/auth.ts
" - Líneas: 15-23
" - Código seleccionado
```

**Ejemplo:**
```typescript
// Archivo: src/auth.ts
function login(user, pass) {  // ← Línea 15
  return auth.verify(user, pass)
}                              // ← Línea 17

// Selecciona líneas 15-17 (modo visual)
// Presiona: <leader>as
```

### 2️⃣ **Enviar Línea Actual** (NUEVO - Custom)
```vim
<leader>al    " Envía línea donde está el cursor

" Claude recibe:
" 📄 Archivo: src/components/Button.tsx
" 📍 Línea: 42 de 150
" 🔤 Tipo: typescriptreact
"
" ```tsx
" const handleClick = () => setCount(count + 1)
" ```
```

### 3️⃣ **Enviar Función Completa** (NUEVO - Treesitter)
```vim
<leader>af    " Detecta automáticamente la función

" Detecta usando Treesitter:
" - Funciones normales
" - Arrow functions
" - Métodos de clase
" - Hooks de React
```

**Ejemplo:**
```typescript
// Cursor en cualquier parte de la función
function calculateTotal(items: Item[]) {
  return items.reduce((sum, item) => sum + item.price, 0)
}

// Presiona: <leader>af
// ✅ Claude recibe la función completa con contexto
```

### 4️⃣ **Enviar Archivo Completo**
```vim
<leader>aF    " Archivo completo con metadatos

" Claude recibe:
" 📄 Archivo: src/services/api.ts
" 📊 Total líneas: 234
" 🔤 Tipo: typescript
" ✅ Guardado (o ✏️ Modificado)
" 🌳 Branch: feature/auth
" ⚠️ Cambios sin commit (si hay)
```

### 5️⃣ **Enviar Contexto de Proyecto**
```vim
<leader>ap    " Contexto general del proyecto

" Claude recibe:
" 🏗️ Proyecto: mi-app
" 📂 Tipo: Node.js/TypeScript (detectado automáticamente)
" 🌳 Branch: main
" 📍 Path: /home/user/projects/mi-app
```

### 6️⃣ **Agregar Buffer al Contexto**
```vim
<leader>ab    " Agregar archivo actual
<leader>aA    " Agregar TODOS los buffers abiertos

" Útil para:
" - Mantener contexto de múltiples archivos
" - Claude puede referenciar cualquier archivo agregado
```

---

## ⌨️ Keymaps Completos

### Core
| Keymap | Descripción | Modo |
|--------|-------------|------|
| `<leader>ai` | 🤖 Iniciar Claude | Normal |
| `<leader>af` | 👁️ Focus en Claude (cambiar ventana) | Normal |
| `<leader>ar` | 🔄 **Resume última conversación** | Normal |
| `<leader>aC` | ➡️ Continuar conversación actual | Normal |

### Enviar Contexto
| Keymap | Descripción | Modo |
|--------|-------------|------|
| `<leader>as` | 📤 Enviar selección | Visual |
| `<leader>al` | 📍 Enviar línea actual | Normal |
| `<leader>af` | 🔧 Enviar función actual (Treesitter) | Normal |
| `<leader>aF` | 📄 Enviar archivo completo | Normal |
| `<leader>ap` | 🏗️ Contexto de proyecto | Normal |

### Gestión de Contexto
| Keymap | Descripción | Modo |
|--------|-------------|------|
| `<leader>ab` | ➕ Add buffer actual | Normal |
| `<leader>aA` | 📚 Add todos los buffers abiertos | Normal |

### Diffs (Aplicar Cambios)
| Keymap | Descripción | Modo |
|--------|-------------|------|
| `<leader>ay` | ✅ Aceptar diff (Yes) | Normal |
| `<leader>an` | ❌ Rechazar diff (No) | Normal |
| `<leader>ad` | ✅✅ Aceptar todos los diffs | Normal |

### Configuración
| Keymap | Descripción | Modo |
|--------|-------------|------|
| `<leader>am` | 🎛️ Seleccionar modelo (Sonnet/Opus) | Normal |

---

## 💡 Ejemplos Prácticos

### Ejemplo 1: Debuggear Función
```vim
" 1. Abrir archivo con bug
:e src/utils/auth.ts

" 2. Ir a la función problemática (línea 42)
42gg

" 3. Enviar función completa
<leader>af

" 4. En Claude, escribir:
"Esta función está fallando con usuarios null. ¿Qué está mal?"

" 5. Claude analiza y sugiere fix
" 6. Si sugiere cambios:
<leader>ay    " Aceptar cambios
```

### Ejemplo 2: Refactorizar Código Legacy
```vim
" 1. Seleccionar código legacy en modo visual
Vjjjj    " Selecciona 5 líneas

" 2. Enviar a Claude
<leader>as

" 3. Escribir en Claude:
"Refactoriza esto usando TypeScript moderno y async/await"

" 4. Claude sugiere refactor
" 5. Aplicar:
<leader>ay
```

### Ejemplo 3: Code Review
```vim
" 1. Enviar archivo completo
<leader>aF

" 2. En Claude:
"Haz un code review completo. Busca:
- Bugs potenciales
- Problemas de performance
- Mejoras de seguridad
- Best practices"

" 3. Claude analiza todo el archivo
```

### Ejemplo 4: Continuar Conversación del Día Anterior
```vim
" 1. Al día siguiente, abrir proyecto
" 2. Resume última conversación
<leader>ar

" ✅ Claude carga exactamente donde lo dejaste
" ✅ Todo el contexto preservado
```

---

## 💾 Persistencia de Conversaciones

### ¿Cómo funciona?

1. **Guardado Automático**
   - Claude CLI guarda cada conversación automáticamente
   - No necesitas hacer nada especial

2. **Resume (`<leader>ar`)**
   ```vim
   " Carga la última conversación completa
   " - Historial completo de mensajes
   " - Contexto de archivos
   " - Estado exacto donde lo dejaste
   ```

3. **Continue (`<leader>aC`)**
   ```vim
   " Continúa la conversación actual sin cerrar
   " Útil si cerraste el panel accidentalmente
   ```

4. **Log de Sesiones**
   - Cada sesión se registra en: `~/.local/share/nvim/claude_sessions.log`
   - Formato:
     ```
     [2025-01-15 14:30:00] Sesión guardada - Proyecto: mi-app
     [2025-01-15 16:45:00] Sesión guardada - Proyecto: api-backend
     ```

---

## 🔄 Workflows Automatizados

Tus workflows **se mantienen** y ahora se integran con Claude Code.

### Usar Workflow
```vim
<leader>wf    " Crear workflow
<leader>wi    " Ver workflows disponibles
<leader>we    " Ejecutar paso de workflow

" Workflows disponibles:
" 🚀 feature     - Implementar nueva funcionalidad
" 🐛 bugfix      - Corregir bug sistemáticamente
" ♻️ refactor    - Refactorización segura
" ⚡ performance - Optimización de rendimiento
" 🔧 setup       - Setup de proyecto
" 🔍 review      - Code review completo
```

### Combinar con Claude Code
```vim
" 1. Iniciar workflow de feature
<leader>wf
" → Seleccionar: feature
" → Escribir: "Sistema de autenticación OAuth"

" 2. Ejecutar primer paso (Analysis)
<leader>we

" 3. El prompt se copia al clipboard
" 4. Claude Code ya está abierto con contexto
" 5. Pegar prompt en Claude (Ctrl+V)
" 6. Claude analiza paso a paso
```

---

## 💡 Tips y Trucos

### 1. **Usar Contexto Incremental**
```vim
" En lugar de enviar todo de golpe:
<leader>al    " Envía línea problemática
" Explicas el problema
" Luego:
<leader>af    " Envías función completa si Claude necesita más contexto
```

### 2. **Mantener Conversación Activa**
```vim
" Durante el día:
<leader>ai    " Abrir Claude
" Trabajar, hacer preguntas
<leader>af    " Focus cuando necesites volver

" Al cerrar Neovim:
" ✅ Todo se guarda automáticamente

" Mañana siguiente:
<leader>ar    " ¡Continúas donde lo dejaste!
```

### 3. **Code Review Rápido**
```vim
" Antes de commit:
<leader>aA    " Agregar todos los archivos modificados
" En Claude: "Revisa estos cambios antes de commit"
```

### 4. **Explorar Codebase Nuevo**
```vim
" En proyecto desconocido:
<leader>ap    " Contexto de proyecto
" Claude te explica estructura

" Luego navegar archivos y:
<leader>aF    " Enviar archivo completo
" "Explica qué hace este archivo"
```

### 5. **Debugging Interactivo**
```vim
" Error en consola:
<leader>al    " Línea del error
" Copias stack trace en Claude
" Claude te guía paso a paso
```

---

## 🎯 Flujo de Trabajo Recomendado

### Morning Routine
```vim
" 1. Abrir proyecto
cd ~/projects/mi-app
nvim .

" 2. Resume conversación de ayer
<leader>ar

" 3. Revisar TODOs
" 4. Continuar donde lo dejaste
```

### Durante Desarrollo
```vim
" Feature nueva:
<leader>wf → feature → "Login social con Google"
<leader>we → Paso 1 (Analysis)

" Bug encontrado:
<leader>af → Enviar función con bug
"Esta función falla cuando user es null"
<leader>ay → Aplicar fix

" Refactor:
Vjjj → Seleccionar código legacy
<leader>as → Enviar a Claude
"Moderniza usando TypeScript + async/await"
```

### Antes de Commit
```vim
" Code review:
<leader>aA    " Todos los archivos modificados
"Revisa estos cambios. ¿Algo que mejorar antes de commit?"
```

---

## 🆘 Troubleshooting

### Claude no se abre
```bash
# Verificar que Claude CLI está instalado
claude --version

# Si no está instalado:
# Ir a https://claude.ai/download y seguir instrucciones
```

### Error de WebSocket
```vim
" Cerrar Neovim completamente
:qa!

" Reiniciar
nvim .

" Claude Code recrea conexión automáticamente
```

### Conversaciones no se guardan
```bash
# Verificar directorio de datos
ls ~/.claude/

# Debería tener carpeta con sesiones
```

---

## 📚 Recursos

- **Claude CLI Docs**: https://docs.anthropic.com/claude-code
- **Plugin GitHub**: https://github.com/coder/claudecode.nvim
- **Tu Config**: `~/.config/nvim/lua/plugins/claude-code.lua`
- **Workflows**: `~/.config/nvim/lua/config/claude-workflows.lua`

---

## 🎉 ¡Disfruta tu Claude Code super integrado!

**Recuerda:**
- `<leader>ai` - Iniciar
- `<leader>ar` - Resume (persistencia)
- `<leader>as` - Enviar selección (visual mode)
- `<leader>al` - Enviar línea actual
- `<leader>af` - Enviar función
- `<leader>ay` - Aceptar cambios

**¡Happy coding with Claude! 🚀**
