return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = { preset = "super-tab", ["<CR>"] = { "accept", "fallback" } },
      signature = { enabled = true },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 150 },
        ghost_text = { enabled = true },
        accept = { auto_brackets = { enabled = true } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
      diagnostics = {
        virtual_text = { spacing = 4, source = "if_many" },
        severity_sort = true,
        float = { border = "rounded", source = true },
      },
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = { typeCheckingMode = "basic", autoImportCompletions = true },
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              lint = {
                enable = true,
                extendSelect = { "I", "B", "UP", "SIM" },
                -- Allow camelCase functions, arguments, locals and attributes.
                ignore = { "N802", "N803", "N806", "N815", "N816" },
              },
            },
          },
        },
        -- Use the installed system clangd, including its clang-tidy diagnostics.
        clangd = {
          mason = false,
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders=1",
            "--fallback-style=llvm",
          },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "debugpy", "codelldb" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { c = { "clang_format" }, cpp = { "clang_format" }, cmake = { "cmake_format" } },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = { "orjangj/neotest-ctest" },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          python = function(root)
            return require("config.ide").python(root)
          end,
          -- Collect testCamelCase as well as test_snake_case functions.
          args = { "-o", "python_functions=test*" },
        },
        ["neotest-ctest"] = {
          dap_adapter = "codelldb",
          is_test_file = function(file)
            local name = vim.fs.basename(file)
            local stem, ext = name:match("^(.*)%.([^.]+)$")
            if not vim.tbl_contains({ "cpp", "cc", "cxx" }, ext) then
              return false
            end
            return stem ~= nil
              and (stem:match("_tests?$") ~= nil or stem:match("Tests?$") ~= nil or stem:match("^test_") ~= nil)
          end,
        },
      },
    },
  },
  {
    "Civitasv/cmake-tools.nvim",
    cmd = {
      "CMakeGenerate",
      "CMakeBuild",
      "CMakeRun",
      "CMakeDebug",
      "CMakeSelectBuildTarget",
      "CMakeSelectLaunchTarget",
    },
    opts = {
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
      cmake_build_directory = "build",
    },
    keys = {
      { "<leader>om", "<cmd>CMakeGenerate<cr>", desc = "CMake Configure" },
      { "<leader>ob", "<cmd>CMakeBuild<cr>", desc = "CMake Build" },
      { "<leader>or", "<cmd>CMakeRun<cr>", desc = "CMake Run" },
      { "<leader>od", "<cmd>CMakeDebug<cr>", desc = "CMake Debug" },
      { "<leader>os", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "CMake Select Launch Target" },
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      require("dap-python").resolve_python = function()
        return require("config.ide").python()
      end
      require("dap-python").test_runner = "pytest"
    end,
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug / Continue",
      },
      {
        "<F9>",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug Step Into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug Step Out",
      },
      {
        "<S-F5>",
        function()
          require("dap").terminate()
        end,
        desc = "Stop Debugger",
      },
    },
  },
}
