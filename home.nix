{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sherlock";
  home.homeDirectory = "/home/sherlock";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    kitty
    tree
    nerd-fonts.symbols-only
    jetbrains-mono
    fastfetch
    python3
    nodejs
    lazygit
    vim-language-server
    luarocks
    php84Packages.composer
    julia
  ];

  programs.zoxide.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/kitty/kitty.conf".source = ./dotfiles/kitty.conf;
    # ".zshrc".source = ./dotfiles/zshrc;
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/sherlock/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  # Install zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      la = "ls -lA";
      rm = "rm -v";
      cp = "cp -v";
      cd = "z";
      open = "xdg-open";
      lg = "lazygit";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      custom = "$HOME/.oh-my-zsh/";
      theme = "af-magic";
    };
    initContent = ''
        clear
        fastfetch
    '';
  };

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Hippolyte Melica";
    userEmail = "hmelica@student.42.fr";
    extraConfig = {
      color = {
        ui = "auto";
      };
      pull = {
        rebase = true;
      };
    };
  };

  programs.neovim = {
    enable = true;
    # extraLuaConfig = ''
    #   ${builtins.readFile ./nvim/init.lua}
    # '';
  };
  # xdg.configFile."nvim".source = "${inputs.nvim-config}";
  home.activation.nvimConfig = {
    # this ensures it runs late enough
    after = [ "writeBoundary" ];
    before = [ ];
    data = ''
      if [ ! -d "$HOME/.config/nvim/.git" ]; then
        echo "→ Clonage du repo Neovim dans ~/.config/nvim"
        rm -rf "$HOME/.config/nvim"
        ${pkgs.git}/bin/git clone https://github.com/etyloppihacilem/mvim_config "$HOME/.config/nvim"
      else
        echo "→ Mise à jour de la config Neovim"
        ${pkgs.git}/bin/git -C "$HOME/.config/nvim" pull --ff-only
      fi
    '';
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
