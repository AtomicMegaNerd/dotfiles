{
  enable = true;

  extensions = [
    "catppuccin"
    "catppuccin-icons"
    "nix"
    "lua"
    "toml"
  ];

  userSettings = {

    # Features
    edit_predictions = {
      mode = "subtle";
    };

    ssh_connections = [
      {
        host = "blahaj";
        username = "rcd";
        projects = [
          {
            paths = [ "/home/rcd/Code/Configs/dotfiles" ];
          }
        ];
      }
    ];

    # AI
    agent = {
      always_allow_tool_actions = true;
      default_model = {
        provider = "copilot_chat";
        model = "gpt-4.1";
      };
    };

    features = {
      edit_prediction_provider = "copilot";
    };

    # UI
    ui_font_size = 14;

    # Editor
    buffer_font_size = 14;
    buffer_font_family = "Monaspace Neon";
    relative_line_numbers = true;
    preferred_line_length = 100;
    wrap_guides = [ 100 ];

    # File Types
    file_types = {
      "Shell Script" = [
        "**/env.list"
        "**/.env"
        "**/.envrc"
      ];
    };

    # Languages
    languages = {
      Python = {
        tab_size = 4;
        language_servers = [
          "ruff"
          "pyright"
        ];
        format_on_save = "on";
        wrap_guides = [ 88 ]; # Default for black/ruff
        formatter = [
          { code_action = "source.organizeImports.ruff"; }
          { code_action = "source.fixAll.ruff"; }
          {
            language_server = {
              name = "ruff";
            };
          }
        ];
      };
      Go = {
        tab_size = 4;
        format_on_save = "on";
        language_servers = [
          "gopls"
          "golangci-lint"
        ];
      };
      Lua = {
        tab_size = 2;
        format_on_save = "on";
      };
      Nix = {
        tab_size = 2;
        format_on_save = "on";
        language_servers = [ "nil" ];
      };
    };

    # LSP
    lsp = {
      golangci-lint = {
        initialization_options = {
          command = [
            "golangci-lint"
            "run"
            "--output.json.path=stdout"
            "--issues-exit-code=1"
            "--show-stats=false"
          ];
        };
      };
    };

    # Terminal
    terminal = {
      font_family = "Monaspace Neon";
      font_size = 14;
      blinking = "on";
      shell = {
        program = "fish";
      };
      detect_venv = {
        on = {
          activate_script = "fish";
        };
      };
    };

    # Misc
    vim_mode = true;
    load_direnv = "shell_hook";
  };

  userKeymaps = [
    {
      context = "Workspace";
      bindings = {
        # "shift shift" = "file_finder::Toggle";
      };
    }
    {
      context = "Editor && vim_mode == insert";
      bindings = {
        # "j k" = "vim::NormalBefore";
      };
    }
    {
      context = "vim_mode == normal && !menu";
      bindings = {
        ";" = "command_palette::Toggle";
      };
    }
  ];
}
