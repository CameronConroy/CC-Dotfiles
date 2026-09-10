local transparentGroups = {
  "Normal",
  "NormalFloat",
  "NormalNC",
  "SignColumn",
  "EndOfBuffer",
  "TabLine",
  "TabLineFill",
  "StatusLine",
  "StatusLineNC",
  "WinBar",
  "WinBarNC",
  "MsgArea",
  "WinSeparator",
  "VertSplit",
  "SnacksDashboardNormal",
  "SnacksDashboardFooter",
  "SnacksDashboardHeader",
  "SnacksDashboardDesc",
  "SnacksDashboardKey",
  "SnacksDashboardIcon",
  "SnacksDashboardSpecial",
  "SnacksDashboardDir",
  "SnacksNormal",
  "SnacksNormalNC",
}

local function applyTransparency()
  for _, group in ipairs(transparentGroups) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    hl.bg = "NONE"
    hl.ctermbg = "NONE"
    vim.api.nvim_set_hl(0, group, hl)
  end
end

local function keepTransparent()
  vim.schedule(function()
    applyTransparency()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("matugen_transparency", { clear = true }),
      callback = applyTransparency,
    })
  end)
end

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        local f = io.open(os.getenv("HOME") .. "/.config/hypr/scripts/quickshell/qs_colors.json", "r")
        if not f then
          vim.cmd.colorscheme("tokyonight")
          keepTransparent()
          return
        end
        local content = f:read("*a")
        f:close()
        local ok, c = pcall(vim.json.decode, content)
        local keys = {
          "base",
          "surface0",
          "surface1",
          "surface2",
          "subtext1",
          "text",
          "subtext0",
          "overlay0",
          "red",
          "peach",
          "yellow",
          "green",
          "teal",
          "blue",
          "mauve",
          "maroon",
        }
        for _, key in ipairs(keys) do
          if not ok or type(c) ~= "table" or type(c[key]) ~= "string" or not c[key]:match("^#%x%x%x%x%x%x$") then
            vim.cmd.colorscheme("tokyonight")
            keepTransparent()
            return
          end
        end
        require("base16-colorscheme").setup({
          base00 = c.base,
          base01 = c.surface0,
          base02 = c.surface1,
          base03 = c.surface2,
          base04 = c.subtext1,
          base05 = c.text,
          base06 = c.subtext0,
          base07 = c.overlay0,
          base08 = c.red,
          base09 = c.peach,
          base0A = c.yellow,
          base0B = c.green,
          base0C = c.teal,
          base0D = c.blue,
          base0E = c.mauve,
          base0F = c.maroon,
        })
        keepTransparent()
      end,
    },
  },
  {
    "RRethy/nvim-base16",
    lazy = false,
    priority = 1000,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = {
          normal = { c = { bg = "none" } },
          insert = { c = { bg = "none" } },
          visual = { c = { bg = "none" } },
          replace = { c = { bg = "none" } },
          command = { c = { bg = "none" } },
          inactive = { c = { bg = "none" } },
        },
        globalstatus = true,
        section_separators = "",
        component_separators = "",
      },
    },
  },
}
