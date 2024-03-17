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
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      config = function()
        local path = require("mason-registry").get_package("debugpy"):get_install_path()
        local opts = {
          pythonPath = get_python_path()
        }
        require("dap-python").setup(path .. "/venv/bin/python", opts)
      end,
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Continue" },
      { "<F9>", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dS", function() require("dap").session() end, desc = "Session" },
      { "<leader>ds", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dT", function() require("dap").clear_breakpoints() end, desc = "Clear all breakpoints" },
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
    opts = function()
      require('dap').defaults.python.exception_breakpoints = {'uncaught'}
      local vscode = require("dap.ext.vscode")
      vscode.json_decode = require("neoconf.json.jsonc").decode_jsonc
      vscode.load_launchjs()
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "python"
      },
    },
  },
  -- which key integration
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>d"] = { name = "+debug" },
      },
    },
  },
}
