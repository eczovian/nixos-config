# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "nixos-23.11";
  });
in
{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    (import "${home-manager}/nixos")
  ];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users = {
    lohsey = {
      initialPassword = "ThisIsAnInitialPassword";
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
    };
  };

  wsl.enable = true;
  wsl.defaultUser = "lohsey";
  

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  home-manager.users.lohsey = {
  	  imports = [
	  	nixvim.homeManagerModules.nixvim
	  ];
	  # Home Manager needs a bit of information about you and the paths it should
	  # manage.
	  home.username = "lohsey";
	  home.homeDirectory = "/home/lohsey";

	  # This value determines the Home Manager release that your configuration is
	  # compatible with. This helps avoid breakage when a new Home Manager release
	  # introduces backwards incompatible changes.
	  #
	  # You should not change this value, even if you update Home Manager. If you do
	  # want to update the value, then make sure to first check the Home Manager
	  # release notes.
	  home.stateVersion = "23.11"; # Please read the comment before changing.

	  # The home.packages option allows you to install Nix packages into your
	  # environment.
	  home.packages =with pkgs; [
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
	     xclip
	     pure-prompt
	     python311Packages.pynvim
	     ripgrep
	     nodejs
	     rustup
	     python313
	     poetry
	     wget
	     curl
	     gcc
          ]; 
	  # Home Manager is pretty good at managing dotfiles. The primary way to manage
	  # plain files is through 'home.file'.
	  home.file = {
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
	  # 'home.sessionVariables'. If you don't want to manage your shell through Home
	  # Manager then you have to manually source 'hm-session-vars.sh' located at
	  # either
	  #
	  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
	  #
	  # or
	  #
	  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
	  #
	  # or
	  #
	  #  /etc/profiles/per-user/lohsey/etc/profile.d/hm-session-vars.sh
	  #
	  home.sessionVariables = {
	    # EDITOR = "emacs";
	  };

	  # Let Home Manager install and manage itself.
	  programs.home-manager.enable = true;
	  programs = {
	    nixvim = {
	      luaLoader.enable = true;
	      vimAlias = true;
	      viAlias = true;
	      colorschemes.catppuccin.enable = true;
	      globals = {
		mapleader = " ";
		maplocalleader = " ";
	      };
	      enable = true;
	      options = {
		colorcolumn = "100";
		mouse = "a";
	        number = true;
	        relativenumber = true;
	        shiftwidth = 2;
		autoindent = true;
		swapfile = false;
	      };
	      plugins = {
		harpoon = {
		  enable = true;
		};
		lualine = {
		 enable = true;
		};
	        lsp = {
	          enable = true;
		  servers = {
		    rust-analyzer= {
                      enable = true;
		      installRustc = true;
		      installCargo = true;
		    };
		  };
	        };
		luasnip.enable = true;
		lsp-format = {
		  enable = true;
		};
		lspkind = {
		  enable = true;
		  cmp = {
		    enable = true;
		    menu = {
		      nvim_lsp = "[LSP]";
		      nvim_lua = "[api]";
		      path = "[path]";
		      luasnip = "[snip]";
		      buffer = "[buffer]";
		      neorg = "[neorg]";
		      cmp_tabnine = "[TabNine]";
		    };
		  };
		};
		nvim-cmp = {
		  enable = true;
		  snippet.expand = "luasnip";
		  sources = [
		    {name = "path";}
		    {name = "nvim_lsp";}
		    {name = "luasnip";}
		    {
		      name = "buffer";
		      # Words from other open buffers can also be suggested.
		      option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
		    }
		  ];
		};
		which-key = {
		  enable = true;
		};
	      };
	    };
	    git = {
	      enable = true;
	      userName = "eczovian";
	      userEmail = "eczovian@pm.me";
	      extraConfig = {
		core = {
		  editor = "nvim";
		};
	      };
	    };
	    zsh = {
	      enable = true;
	      enableCompletion = true;
	      enableAutosuggestions = true;
	      syntaxHighlighting.enable = true;
	      initExtra =''
		autoload -U promptinit; promptinit
		prompt pure 
		   '';

	      shellAliases = {
		ls = "ls -a";
	      };
	      oh-my-zsh = {
		enable = true;
		theme = "";
		plugins = ["git" "rust" "history"];
	      };
	    };
	    #tmux = {
		#shell = "${pkgs.zsh}/bin/zsh";
		#escapeTime = 70;
		#enable = true;
		#baseIndex = 1;
		#newSession = true;
		#mouse = true;
		#prefix = "C-space";
		#terminal = "xterm-256color";
		#disableConfirmationPrompt = true;
		#plugins = with pkgs.tmuxPlugins; 
		#[
		   #sensible
		   #vim-tmux-navigator
		   #catppuccin
		   #yank
		#];
		#keyMode = "vi";
		#extraConfig = ''
		#set -g @catppuccin_flavour 'mocha'
		#bind | split-window -h -c "#{pane_current_path}"
		#bind _ split-window -v -c "#{pane_current_path}"
		#bind-key -T copy-mode-vi v send-keys -X begin-selection
		#bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
		#bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
		#'';
		#      };
	  };
	};
}
