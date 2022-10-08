{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.vim.nvim-terminal;
in
{
  options.vim.nvim-terminal = {
    enable = mkOption {
      type = types.bool;
      description = "Enable nvim-terminal plugin";
    };
  };

  config = mkIf cfg.enable ({
    vim.startPlugins = [ pkgs.neovimPlugins.nvim-terminal ];
    vim.tnoremap = {
      "<Esc>" = "<C-\\><C-n>";
      "<M-h>" = "<C-\\><C-n><C-w>h";
      "<M-j>" = "<C-\\><C-n><C-w>j";
      "<M-k>" = "<C-\\><C-n><C-w>k";
      "<M-l>" = "<C-\\><C-n><C-w>l";
    };

    vim.nnoremap = {
        "<leader>T;" = "<cmd>:lua NTGlobal[\"terminal\"]:toggle()<cr>";
       "<leader>T1" = "<cmd>:lua NTGlobal[\"terminal\"]:open(1)<cr>";
       "<leader>T2" = "<cmd>:lua NTGlobal[\"terminal\"]:open(2)<cr>";
    };

    vim.luaConfigRC = ''
      -- following option will hide the buffer when it is closed instead of deleting
      -- the buffer. This is important to reuse the last terminal buffer
      -- IF the option is not set, plugin will open a new terminal every single time
      vim.o.hidden = true

      require('nvim-terminal').setup({
          window = {
              -- Do `:h :botright` for more information
              -- NOTE: width or height may not be applied in some "pos"
              position = 'botright',

              -- Do `:h split` for more information
              split = 'sp',

              -- Width of the terminal
              width = 50,

              -- Height of the terminal
              height = 15,
          },

          -- keymap to disable all the default keymaps
          disable_default_keymaps = false,
      })
    '';
  });
}
