return {
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { bashls = {} } },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "shfmt", "shellcheck", "stylua", "prettier" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
    },
  },
}
