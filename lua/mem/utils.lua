local a = vim.api
local f = vim.fn
local M = {}

function M.get_files()
  return a.nvim_get_runtime_file('mem/*.mem', true)
end

local function push_to_path(path, ...)
  local path_sep = '/'
  if f.has('win32') == 1 then
    path_sep = '\\'
  end

  for _, subfolder in ipairs({...}) do
    path = path .. path_sep .. subfolder
  end

  return path
end

function M.get_dirs()
  local dirs = {}


  for _, fname in ipairs(M.get_files()) do
    local dir = f.fnamemodify(fname, ':h')
    if not vim.tbl_contains(dirs, fname) then
      table.insert(dirs, dir)
    end
  end

  local data = push_to_path(f.stdpath('data'), 'site', 'mem')
  if not vim.tbl_contains(dirs, data) then
    table.insert(dirs, data)
  end


  return dirs
end

local function list_select(list, prompt)
  return function()
    local lines = { prompt }
    for i, item in ipairs(list) do
      table.insert(lines, string.format("%d. %s", i, item))
    end

    local selection = f.inputlist(lines)

    return list[selection]
  end
end

M.select_file = list_select(M.get_files(), 'Select the file to open:')

M.select_dir = list_select(M.get_dirs(), 'Select the directory:')

function M.create_file()
  local new_dir = M.select_dir()
  f.mkdir(new_dir, 'p')

  local fname = f.input{ prompt = "Filename (without extension): " }

  if not fname or #fname == 0 then return end

  return push_to_path(new_dir, fname .. '.mem')
end

return M
