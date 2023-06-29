-- get the python path from the venv(like which python)
-- get the conda env path
local function get_python_path()
  -- TODO: this is only compatible with linux
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
    dependencies = { "mfussenegger/nvim-dap-python" },
    lazy = true,
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
                stopOnEntry = true,
                -- console = "externalTerminal",
                debugOptions = {},
                program = vim.fn.expand("%:p"),
              -- TODO: select args in neovim
                args = {},
              },
            },
          }
          config["configurations"][1]["justMyCode#json"] = "${justMyCode:true}"
          -- dump `config` to a json file
          local json = vim.fn.json_encode(config)
          -- create .vscode dir if not exists
          vim.fn.mkdir(".vscode", "p")
          local ok, file = pcall(io.open, ".vscode/launch.json", "w")
          if ok then
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
    config = function()
      local dap = require("dap")
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python3",
        args = { "-m", "debugpy.adapter" },
      }

      require("dap-python").setup(get_python_path())
      require("dap.ext.vscode").load_launchjs()
      -- dap.configurations.python = {
      --   {
      --     -- The first three options are required by nvim-dap
      --     type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
      --     request = "launch",
      --     name = "Launch file",
      --     -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
      --     program = "${file}", -- This configuration will launch the current file if used.
      --     args = function()
      --       local cmd_args = vim.fn.input("CommandLine Args:")
      --       local params = {}
      --       for param in string.gmatch(cmd_args, "[^%s]+") do
      --         table.insert(params, param)
      --       end
      --       return params
      --     end,
      --     pythonPath = function()
      --       --The below line will work for virtualenvwrapper, as vim.env.VIRTUAL_ENV points to the active env directory if you use it
      --       --Test the variable by running :lua print(vim.env.VIRTUAL_ENV) and find your path from there if it is defined
      --       local conda = vim.fn.environ()["CONDA_PREFIX"]
      --       if conda then
      --         return conda .. "/bin/python"
      --       end
      --       -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      --       -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      --       -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable (done above).
      --       return "/usr/bin/python"
      --     end,
      --   },
      -- }

      local dap_breakpoint_color = {
        breakpoint = {
          ctermbg = 0,
          fg = "#993939",
          bg = "#31353f",
        },
        logpoing = {
          ctermbg = 0,
          fg = "#61afef",
          bg = "#31353f",
        },
        stopped = {
          ctermbg = 0,
          fg = "#98c379",
          bg = "#31353f",
        },
      }

      vim.api.nvim_set_hl(0, "DapBreakpoint", dap_breakpoint_color.breakpoint)
      vim.api.nvim_set_hl(0, "DapLogPoint", dap_breakpoint_color.logpoing)
      vim.api.nvim_set_hl(0, "DapStopped", dap_breakpoint_color.stopped)

      local dap_breakpoint = {
        error = {
          text = "",
          texthl = "DapBreakpoint",
          linehl = "DapBreakpoint",
          numhl = "DapBreakpoint",
        },
        condition = {
          text = "ﳁ",
          texthl = "DapBreakpoint",
          linehl = "DapBreakpoint",
          numhl = "DapBreakpoint",
        },
        rejected = {
          text = "",
          texthl = "DapBreakpint",
          linehl = "DapBreakpoint",
          numhl = "DapBreakpoint",
        },
        logpoint = {
          text = "",
          texthl = "DapLogPoint",
          linehl = "DapLogPoint",
          numhl = "DapLogPoint",
        },
        stopped = {
          text = "",
          texthl = "DapStopped",
          linehl = "DapStopped",
          numhl = "DapStopped",
        },
      }

      vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
      vim.fn.sign_define("DapBreakpointCondition", dap_breakpoint.condition)
      vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
      vim.fn.sign_define("DapLogPoint", dap_breakpoint.logpoint)
      vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)

      require("dap.ext.vscode").load_launchjs()
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local present, dapui = pcall(require, "dapui")
      if not present then
        return
      end

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        -- Use this to override mappings for specific elements
        element_mappings = {
          -- Example:
          -- stacks = {
          --   open = "<CR>",
          --   expand = "o",
          -- }
        },
        -- Expand lines larger than the window
        -- Requires >= 0.7
        expand_lines = vim.fn.has("nvim-0.7") == 1,
        -- Layouts define sections of the screen to place windows.
        -- The position can be "left", "right", "top" or "bottom".
        -- The size specifies the height/width depending on position. It can be an Int
        -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
        -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
        -- Elements are the elements shown in the layout (in order).
        -- Layouts are opened in order so that earlier layouts take priority in window sizing.
        layouts = {
          {
            elements = {
              -- Elements can be strings or table with id and size keys.
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40, -- 40 columns
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
          },
        },
        controls = {
          -- Requires Neovim nightly (or 0.8 when released)
          enabled = true,
          -- Display controls in this element
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "↻",
            terminate = "□",
          },
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
          border = "single", -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil, -- Can be integer or nil.
          max_value_lines = 100, -- Can be integer or nil.
        },
      })

      require("dap").listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      require("dap").listeners.before.disconnect["dapui_config"] = function()
        dapui.close()
      end
      require("dap").listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      require("dap").listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
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
  -- virtual text for the debugger
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },
}
