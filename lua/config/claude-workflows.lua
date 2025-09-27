-- =========================
-- Claude Automated Workflows
-- Sistema de workflows y planes automatizados para Claude
-- =========================

local M = {}

-- ========================
-- PLANTILLAS DE WORKFLOWS
-- ========================

local WORKFLOW_TEMPLATES = {
  feature = {
    name = "🚀 Implementar Nueva Feature",
    description = "Workflow completo para implementar una nueva funcionalidad",
    prompts = {
      analysis = "Analiza los requisitos de la feature: {objective}. Identifica componentes, dependencias y posibles desafíos.",
      architecture = "Diseña la arquitectura para: {objective}. Define estructura de componentes, servicios y tipos necesarios.",
      implementation = "Implementa la feature: {objective}. Sigue las mejores prácticas y patrones del proyecto.",
      testing = "Crea tests para la feature: {objective}. Incluye tests unitarios y de integración.",
      integration = "Integra la feature {objective} con el sistema existente. Verifica compatibilidad y rendimiento.",
      documentation = "Documenta la feature: {objective}. Incluye ejemplos de uso y guías para desarrolladores."
    },
    agent_preferences = {
      react = "scope-rule-architect-react",
      nextjs = "scope-rule-architect-nextjs",
      angular = "angular-expert-architect",
      default = "software-architect"
    }
  },

  bugfix = {
    name = "🐛 Corregir Bug",
    description = "Workflow para debugging y corrección sistemática",
    prompts = {
      reproduce = "Reproduce y analiza el bug: {objective}. Identifica pasos exactos para reproducirlo.",
      investigate = "Investiga la causa raíz del bug: {objective}. Analiza stack traces, logs y comportamiento.",
      solution = "Diseña la solución para el bug: {objective}. Evalúa diferentes aproximaciones.",
      implement = "Implementa la corrección para: {objective}. Asegúrate de no introducir regresiones.",
      test = "Crea tests de regresión para: {objective}. Verifica que el bug no vuelva a ocurrir.",
      verify = "Verifica que la corrección para {objective} funciona correctamente en todos los escenarios."
    },
    agent_preferences = {
      default = "general-purpose"
    }
  },

  refactor = {
    name = "♻️ Refactorización",
    description = "Workflow para refactorización sistemática y segura",
    prompts = {
      analyze = "Analiza el código actual para refactorizar: {objective}. Identifica patrones problemáticos.",
      plan = "Planifica la refactorización de: {objective}. Define pasos incrementales y seguros.",
      extract = "Extrae componentes/funciones reutilizables de: {objective}. Aplica principios SOLID.",
      optimize = "Optimiza la estructura de: {objective}. Mejora legibilidad y mantenibilidad.",
      test = "Actualiza y expande tests para: {objective}. Asegura que la funcionalidad se mantiene.",
      validate = "Valida que la refactorización de {objective} mejora el código sin romper funcionalidad."
    },
    agent_preferences = {
      react = "scope-rule-architect-react",
      nextjs = "scope-rule-architect-nextjs",
      angular = "angular-expert-architect",
      default = "software-architect"
    }
  },

  performance = {
    name = "⚡ Optimización de Performance",
    description = "Workflow para análisis y optimización de rendimiento",
    prompts = {
      profile = "Profilea y mide el performance actual de: {objective}. Identifica métricas clave.",
      bottlenecks = "Identifica cuellos de botella en: {objective}. Analiza CPU, memoria, red y I/O.",
      strategy = "Diseña estrategia de optimización para: {objective}. Prioriza mejoras por impacto.",
      implement = "Implementa optimizaciones para: {objective}. Aplica técnicas de caching, lazy loading, etc.",
      measure = "Mide el impacto de las optimizaciones en: {objective}. Compara métricas antes/después.",
      monitor = "Configura monitoreo continuo para: {objective}. Establece alertas y dashboards."
    },
    agent_preferences = {
      nextjs = "scope-rule-architect-nextjs",
      react = "scope-rule-architect-react",
      default = "software-architect"
    }
  },

  setup = {
    name = "🔧 Setup de Proyecto",
    description = "Workflow para configuración inicial de proyectos",
    prompts = {
      requirements = "Analiza los requisitos del proyecto: {objective}. Define stack tecnológico y arquitectura.",
      structure = "Crea la estructura base para: {objective}. Organiza directorios y archivos principales.",
      config = "Configura herramientas de desarrollo para: {objective}. Eslint, Prettier, tests, CI/CD.",
      foundation = "Implementa los componentes base para: {objective}. Layout, routing, state management.",
      documentation = "Crea documentación inicial para: {objective}. README, contributing, deployment.",
      deployment = "Configura pipeline de deployment para: {objective}. CI/CD, environments, monitoring."
    },
    agent_preferences = {
      react = "scope-rule-architect-react",
      nextjs = "scope-rule-architect-nextjs",
      angular = "scope-rule-architect-angular",
      astro = "scope-rule-architect-astro",
      default = "software-architect"
    }
  },

  review = {
    name = "🔍 Code Review",
    description = "Workflow para revisión sistemática de código",
    prompts = {
      overview = "Revisa la estructura general de: {objective}. Evalúa organización y arquitectura.",
      patterns = "Analiza patrones de diseño en: {objective}. Identifica violaciones de principios SOLID.",
      performance = "Revisa performance y optimizaciones en: {objective}. Identifica mejoras potenciales.",
      security = "Analiza aspectos de seguridad en: {objective}. Identifica vulnerabilidades y malas prácticas.",
      testing = "Revisa cobertura y calidad de tests en: {objective}. Sugiere mejoras en testing.",
      recommendations = "Proporciona recomendaciones finales para: {objective}. Prioriza cambios por impacto."
    },
    agent_preferences = {
      angular = "angular-expert-architect",
      react = "scope-rule-architect-react",
      nextjs = "scope-rule-architect-nextjs",
      default = "software-architect"
    }
  }
}

-- ========================
-- GESTIÓN DE WORKFLOWS
-- ========================

-- Obtener workflow apropiado para el tipo de proyecto
local function get_workflow_agent(workflow_key, project_type)
  local workflow = WORKFLOW_TEMPLATES[workflow_key]
  if not workflow then return "general-purpose" end

  return workflow.agent_preferences[project_type] or workflow.agent_preferences.default or "general-purpose"
end

-- Crear plan automatizado desde workflow
local function create_automated_plan(workflow_key, objective)
  local workflow = WORKFLOW_TEMPLATES[workflow_key]
  if not workflow then
    vim.notify("❌ Workflow no encontrado: " .. workflow_key, vim.log.levels.ERROR)
    return
  end

  local claude_global = require("config.claude-agents-global")
  local project_type = claude_global.get_recommended_agent().agent:match("([^-]+)")

  -- Crear lista de tareas basada en el workflow
  local todos = {}
  local step_num = 1

  for step_key, prompt_template in pairs(workflow.prompts) do
    local prompt = prompt_template:gsub("{objective}", objective)
    local task_content = string.format("%d. %s - %s", step_num, step_key:gsub("^%l", string.upper), prompt)

    table.insert(todos, {
      content = task_content,
      status = step_num == 1 and "pending" or "pending",
      activeForm = step_key:gsub("^%l", string.upper) .. " - " .. objective,
      workflow = workflow_key,
      step = step_key,
      prompt = prompt,
      agent = get_workflow_agent(workflow_key, project_type)
    })

    step_num = step_num + 1
  end

  return todos, workflow
end

-- Ejecutar paso de workflow con Claude
local function execute_workflow_step(todo_item)
  if not todo_item.workflow or not todo_item.step then
    vim.notify("❌ Información de workflow incompleta", vim.log.levels.ERROR)
    return
  end

  local claude_global = require("config.claude-agents-global")
  local contextual_prompt, agent_info = claude_global.create_contextual_prompt(todo_item.prompt, true)

  -- Agregar información específica del workflow
  local workflow_context = string.format([[

🔄 WORKFLOW: %s
📋 PASO: %s (%s)
🎯 AGENTE RECOMENDADO: %s

]], todo_item.workflow, todo_item.step, todo_item.activeForm, todo_item.agent)

  contextual_prompt = contextual_prompt .. workflow_context

  -- Guardar en historial
  claude_global.save_prompt_history(todo_item.prompt, todo_item.agent, {
    workflow = todo_item.workflow,
    step = todo_item.step
  })

  -- Copiar al clipboard
  vim.fn.setreg("+", contextual_prompt)

  -- Abrir Claude
  require("config.claude-workflow").open_claude_persistent()

  vim.notify(string.format("📋 Ejecutando paso: %s\n🤖 Agente: %s\n📄 Prompt copiado al clipboard",
    todo_item.activeForm,
    todo_item.agent
  ), vim.log.levels.INFO, {
    title = "Workflow Step",
    timeout = 5000
  })
end

-- ========================
-- INTERFAZ DE USUARIO
-- ========================

-- Selector de workflows
local function select_workflow()
  local workflow_keys = vim.tbl_keys(WORKFLOW_TEMPLATES)
  table.sort(workflow_keys)

  local items = vim.tbl_map(function(key)
    local workflow = WORKFLOW_TEMPLATES[key]
    return {
      key = key,
      display = workflow.name .. " - " .. workflow.description
    }
  end, workflow_keys)

  vim.ui.select(items, {
    prompt = "Selecciona un workflow:",
    format_item = function(item)
      return item.display
    end,
  }, function(choice)
    if choice then
      vim.ui.input({
        prompt = "Describe el objetivo específico: ",
        default = "Proyecto actual"
      }, function(objective)
        if objective then
          local todos, workflow = create_automated_plan(choice.key, objective)
          if todos and #todos > 0 then
            vim.notify(string.format("📋 Workflow '%s' creado con %d pasos\nUsa los TODOs para seguir el progreso",
              workflow.name, #todos), vim.log.levels.INFO, {
              title = "Automated Workflow"
            })

            -- Mostrar primer paso
            vim.defer_fn(function()
              vim.notify("💡 Primer paso listo. Usa <leader>we para ejecutar pasos del workflow",
                vim.log.levels.INFO, {
                title = "Workflow Ready"
              })
            end, 2000)
          end
        end
      end)
    end
  end)
end

-- Mostrar workflows disponibles
local function show_workflows()
  local info_lines = {"📋 WORKFLOWS DISPONIBLES:\n"}

  for key, workflow in pairs(WORKFLOW_TEMPLATES) do
    table.insert(info_lines, string.format("🔸 %s: %s", workflow.name, workflow.description))
    table.insert(info_lines, string.format("   Pasos: %d | Agentes: %s\n",
      vim.tbl_count(workflow.prompts),
      table.concat(vim.tbl_values(workflow.agent_preferences), ", ")
    ))
  end

  vim.notify(table.concat(info_lines, "\n"), vim.log.levels.INFO, {
    title = "Claude Workflows",
    timeout = 15000
  })
end

-- Ejecutar workflow paso a paso
local function execute_current_workflow_step()
  -- Esta función se integraría con el sistema de TODOs
  -- Por ahora, mostramos un placeholder
  vim.notify("🔄 Funcionalidad en desarrollo: integración con sistema de TODOs",
    vim.log.levels.WARN, {
    title = "Workflow Execution"
  })
end

-- ========================
-- KEYMAPS
-- ========================

local keymap = vim.keymap.set

-- Workflows
keymap("n", "<leader>wf", select_workflow, { desc = "🔄 Crear workflow" })
keymap("n", "<leader>wi", show_workflows, { desc = "ℹ️ Info de workflows" })
keymap("n", "<leader>we", execute_current_workflow_step, { desc = "▶️ Ejecutar paso workflow" })

-- ========================
-- INTEGRACIÓN CON WHICH-KEY
-- ========================

local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({
    { "<leader>w", group = "🔄 Workflows" },
    { "<leader>wf", desc = "🔄 Crear workflow" },
    { "<leader>wi", desc = "ℹ️ Info de workflows" },
    { "<leader>we", desc = "▶️ Ejecutar paso workflow" },
  })
end

-- ========================
-- COMANDOS
-- ========================

vim.api.nvim_create_user_command("ClaudeWorkflow", select_workflow, {
  desc = "Crear workflow automatizado"
})

vim.api.nvim_create_user_command("ClaudeWorkflows", show_workflows, {
  desc = "Mostrar workflows disponibles"
})

-- ========================
-- CONFIGURACIÓN
-- ========================

M.setup = function()
  vim.notify("🔄 Claude Workflows configurado\n📋 Disponibles: " .. vim.tbl_count(WORKFLOW_TEMPLATES) .. " workflows",
    vim.log.levels.INFO, {
    title = "Claude Workflows",
    timeout = 3000
  })
end

-- Exportar funciones para otros módulos
M.create_automated_plan = create_automated_plan
M.execute_workflow_step = execute_workflow_step
M.get_workflow_templates = function() return WORKFLOW_TEMPLATES end

return M