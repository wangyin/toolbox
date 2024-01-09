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
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<F5>", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dc", vim.NIL },
      { "<F9>", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dC", vim.NIL },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>di", vim.NIL },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<F12>", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>do", vim.NIL },
      { "<leader>dO", vim.NIL },
      { "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>ds", vim.NIL },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Repl" },
      { "<leader>dS", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dT", function() require("dap").clear_breakpoints() end, desc = "Clear all breakpoints" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      {
        "<leader>dG",
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
      require("dap.ext.vscode").load_launchjs()
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
        ["<leader>da"] = { name = "+adapters" },
      },
    },
  },
}
