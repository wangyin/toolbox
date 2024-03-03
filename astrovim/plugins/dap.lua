-- get the python path from the venv(like which python)
-- get the conda env path
local function get_python_path()
  -- this is only compatible with linux
  -- Implement a version that works with windows as well
  local path = vim.fn.system("which python")
  -- right trim the '\n' in   path
  path = string.gsub(path, "\n$", "")
  if path == "" then
    return nil
  end
  return path
end


return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      {
        "<leader>dv",
        function()
          local python_config = {
            configurations = {
              {
                name = "New VS Launcher",
                type = "python",
                request = "launch",
                cwd = vim.fn.getcwd(),
                python = get_python_path(),
                stopOnEntry = false,
                justMyCode = true,
                debugOptions = {},
                program = vim.fn.expand("%:p"),
                args = {},
              },
            },
          }
          -- create .vscode dir if not exists
          vim.fn.mkdir(".vscode", "p")
          local ok, file = pcall(io.open, ".vscode/launch.json", "w")
          if ok and file~=nil then
            file:write(vim.json.encode(python_config))
            file:close()
            print("Generated .vscode/launch.json")
          else
            print("Error writing to file: " .. file)
          end
        end,
        desc = "Generate .vscode/launch.json",
      },
    },
    config = function()
      require('dap').defaults.python.exception_breakpoints = {'uncaught'}
      local vscode = require("dap.ext.vscode")
      vscode.json_decode = require("neoconf.json.jsonc").decode_jsonc
      vscode.load_launchjs()
    end,
  },
}
