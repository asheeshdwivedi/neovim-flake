{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim.nvim-dap;
in
{
  options.vim.nvim-dap = {
    enable = mkOption {
      type = types.bool;
      description = "Enable nvim-dap plugin";
    };
  };

  config = mkIf cfg.enable ({
    vim.startPlugins = [
        pkgs.neovimPlugins.nvim-dap
        pkgs.neovimPlugins.nvim-dap-virtual-text
        pkgs.neovimPlugins.telescope-dap
        pkgs.neovimPlugins.nvim-dap-ui
    ];

    vim.nnoremap = {
          "<leader>do" = "<cmd>lua require'dap'.step_over()<cr>";
          "<leader>ds" = "<cmd>lua require'dap'.step_into()<cr>";
          "<leader>dO" = "<cmd>lua require'dap'.step_out()<cr>";
          "<leader>dc" = "<cmd>lua require'dap'.continue()<cr>";
          "<leader>db" = "<cmd>lua require'dap'.toggle_breakpoint()<cr>";
          "<leader>dr" = "<cmd>lua require'dap'.repl.toggle()<cr>";
          "<leader>dui" = "<cmd>lua require'dapui'.toggle()<cr>";
    };

    vim.luaConfigRC = ''

        require("nvim-dap-virtual-text").setup()

        require("dapui").setup({
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
          -- Expand lines larger than the window
          -- Requires >= 0.7
          expand_lines = vim.fn.has("nvim-0.7"),
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
          }
        })
    '';
  });
}