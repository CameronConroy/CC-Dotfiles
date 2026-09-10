local M = {}

function M.python(root)
  if package.loaded["venv-selector"] then
    local selected = require("venv-selector").python()
    if selected and vim.fn.executable(selected) == 1 then
      return selected
    end
  end
  root = root or LazyVim.root()
  for _, env in ipairs({ ".venv", "venv", "env" }) do
    local candidate = root .. "/" .. env .. "/bin/python"
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
  -- Avoid accidentally using an unrelated virtualenv injected into shell PATH.
  if vim.fn.executable("/usr/bin/python3") == 1 then
    return "/usr/bin/python3"
  end
  return vim.fn.exepath("python3")
end

function M.runFile()
  local file = vim.api.nvim_buf_get_name(0)
  local ft = vim.bo.filetype
  if file == "" or (ft ~= "python" and ft ~= "cpp" and ft ~= "c") then
    vim.notify("Save a Python, C or C++ file first", vim.log.levels.WARN)
    return
  end
  vim.cmd.update()
  local cwd = vim.fs.dirname(file)
  if ft == "python" then
    Snacks.terminal({ M.python(), file }, { cwd = cwd, auto_close = false })
    return
  end
  -- Quick single-file programs; use CMake controls for multi-file projects.
  local compiler = ft == "cpp" and "clang++" or "clang"
  local outDir = vim.fn.stdpath("cache") .. "/run"
  vim.fn.mkdir(outDir, "p")
  local binary = outDir .. "/" .. vim.fn.sha256(file):sub(1, 16)
  local task = require("overseer").new_task({
    name = "Build " .. vim.fs.basename(file),
    cmd = compiler,
    args = { ft == "cpp" and "-std=c++20" or "-std=c17", "-Wall", "-Wextra", "-g", file, "-o", binary },
    cwd = cwd,
    components = { { "on_output_quickfix", open_on_exit = "failure" }, "default" },
  })
  task:subscribe("on_complete", function(_, status)
    if status == "SUCCESS" then
      Snacks.terminal({ binary }, { cwd = cwd, auto_close = false })
    end
  end)
  task:start()
end

return M
