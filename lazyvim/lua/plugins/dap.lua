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

local function get_debugpy()
  local path = require("mason-registry").get_package("debugpy"):get_install_path()
  if path == "" then
    return nil
  end
  return path .. "/venv/bin/python"
end

return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", vim.NIL },
      { "<leader>ds", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Repl" },
      { "<leader>dS", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dT", function() require("dap").clear_breakpoints() end, desc = "Clear all breakpoints" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      {
        "<leader>dG",
        function()
          local config = {
            configurations = {
              {
                name = "vscode json launcher",
                type = "python",
                request = "launch",
                cwd = vim.fn.getcwd(),
                python = get_python_path(),
                stopOnEntry = false,
                justMyCode = false,
                -- console = "externalTerminal",
                debugOptions = {},
                program = vim.fn.expand("%:p"),
                args = {},
              },
            },
          }
          -- config["configurations"][1]["justMyCode#json"] = "${justMyCode:true}"
          -- dump `config` to a json file
          local json = vim.fn.json_encode(config)
          -- create .vscode dir if not exists
          vim.fn.mkdir(".vscode", "p")
          local ok, file = pcall(io.open, ".vscode/launch.json", "w")
          if ok and file~=nil then
            file:write(json)
            print("Generated .vscode/launch.json")
          else
            print("Error writing to file: " .. file)
          end
        end,
        mode = "n",
        desc = "Generate .vscode/launch.json",
      },
    },
    opts = function(_, opts)
      require("nvim-dap-virtual-text").setup({
        -- virt_text_pos = 'eol'
        virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
      })

      require("dap.ext.vscode").load_launchjs()
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require("dap-python").setup(get_debugpy())
    end
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
