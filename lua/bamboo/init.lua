local M = {}

---Change bamboo option (vim.g.bamboo_config.option)
---It can't be changed directly by modifying that field due to a Neovim lua bug with global variables (bamboo_config is a global variable)
---@param opt string: option name
---@param value any: new value
function M.set_options(opt, value)
  local cfg = vim.g.bamboo_config
  cfg[opt] = value
  vim.g.bamboo_config = cfg
end

---Apply the colorscheme (same as ':colorscheme bamboo')
function M.colorscheme()
  vim.cmd.hi('clear')
  if vim.fn.exists('syntax_on') then
    vim.cmd.syntax('reset')
  end
  vim.o.termguicolors = true
  vim.g.colors_name = 'bamboo'
  require('bamboo.highlights').setup()
  require('bamboo.terminal').setup()
end

local default_config = {
  -- Main options --
  transparent = false, -- don't set background
  dim_inactive = false, -- don't dim inactive windows
  term_colors = true, -- if true enable the terminal
  ending_tildes = false, -- show the end-of-buffer tildes
  cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

  -- Changing Formats --
  code_style = {
    comments = { italic = true },
    conditionals = { italic = true },
    keywords = {},
    functions = {},
    namespaces = { italic = true },
    parameters = { italic = true },
    strings = {},
    variables = {},
  },

  -- Lualine options --
  lualine = {
    transparent = false, -- center bar (c) transparency
  },

  -- Custom Highlights --
  colors = {}, -- Override default colors
  highlights = {}, -- Override highlight groups

  -- Plugins Related --
  diagnostics = {
    darker = false, -- darker colors for diagnostic
    undercurl = true, -- use undercurl for diagnostics
    background = true, -- use background color for virtual text
  },
}

---Setup bamboo.nvim options, without applying colorscheme
---@param opts table?: a table containing options
function M.setup(opts)
  if not vim.g.bamboo_config or not vim.g.bamboo_config.loaded then -- if it's the first time setup() is called
    vim.g.bamboo_config =
      vim.tbl_deep_extend('keep', vim.g.bamboo_config or {}, default_config)
    M.set_options('loaded', true)
  end
  if opts then
    vim.g.bamboo_config =
      vim.tbl_deep_extend('force', vim.g.bamboo_config, opts)
    -- these tables cannot be extended, they have to be replaced
    if opts.code_style then
      local cfg = vim.g.bamboo_config
      cfg.code_style = vim.tbl_extend('force', cfg.code_style, opts.code_style)
      vim.g.bamboo_config = cfg
    end
  end
end

return M
