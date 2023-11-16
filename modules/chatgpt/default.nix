{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.vim.chatgpt;
in
{
  options.vim.chatgpt = {
    enable = mkOption {
      type = types.bool;
      description = "Enable ChatGPT.nvim plugin";
    };
    openaiApiKey = mkOption {
      default = null;
      description = "The OpenAI API KEY (can also be set as an env variable)";
      type = types.nullOr types.str;
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [ nvim-nui nvim-chatgpt ];

    vim.luaConfigRC = ''
      require("chatgpt").setup({
         api_key_cmd = "echo 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"
      })
    '';
  };
}
