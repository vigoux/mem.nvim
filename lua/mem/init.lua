local utils = require'mem.utils'
local M = {}

local options = {}

function M.init()
  require "nvim-treesitter.parsers".get_parser_configs().mem = {
    install_info = {
      url = "https://github.com/vigoux/tree-sitter-mem",
      files = {"src/parser.c"}
    }
  }
end

function M.setup(opts)

end

local function edit_file(default_fn)
  return function(file)
    if not file then
      file = default_fn(file)
      if not file then return end
    end

    vim.cmd(string.format("edit " .. file))
    vim.api.nvim_buf_set_option(0, 'filetype', 'mem')
  end
end

M.open = edit_file(utils.select_file)
M.create = edit_file(utils.create_file)

return M
