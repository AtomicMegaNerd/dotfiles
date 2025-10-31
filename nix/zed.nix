let
  fontFamily = "Monaspace Argon";
  fontSize = 14;
  defaultTabSize = 4;
in
{
  enable = true;

  extensions = [
    "catppuccin"
    "catppuccin-icons"
    "nix"
    "lua"
    "toml"
    "comment"
    "git-firefly"
    "golangci-lint"
    "bash"
    "dockerfile"
    "docker-compose"
    "zig"
    "sql"
    "html"
    "log"

    # MCP Servers
    "mcp-server-context7"
    "mcp-server-github"
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
    ui_font_size = fontSize;

    # Editor
    buffer_font_size = fontSize;
    buffer_font_family = fontFamily;
    relative_line_numbers = true;
    preferred_line_length = 100;
    wrap_guides = [ 100 ];
    tab_size = defaultTabSize;

    # Terminal
    terminal = {
      font_family = fontFamily;
      font_size = fontSize;
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
        tab_size = defaultTabSize;
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
