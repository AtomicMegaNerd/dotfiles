{
  enable = true;

  extensions = [
    "comment"
    "docker-compose"
    "dockerfile"
    "emmet"
    "golangci-lint"
    "html"
    "nix"
    "tokyo-night"
    "toml"
    "xml"
    "zed-icons-colored-theme"
  ];

  userSettings = {

    agent_servers = {
      opencode = {
        type = "registry";
      };
    };

    agent = {
      button = false;
    };

    # Smart tab completion
    edit_predictions = {
      provider = "copilot";
      mode = "subtle";
    };

    # Remote connections
    ssh_connections = [
      {
        host = "blahaj";
        username = "rcd";
        projects = [ { paths = [ "/home/rcd/Code/Configs/dotfiles" ]; } ];
      }
    ];

    # Key help
    which_key = {
      delay_ms = 500;
      enabled = true;
    };

    # UI
    cursor_shape = "block";
    icon_theme = "Colored Zed Icons Theme Dark";
    theme = "Tokyo Night Storm";

    # Fonts
    ui_font_size = 18;
    buffer_font_size = 18;
    buffer_font_family = "Monaspace Argon Var";

    # Editor
    code_lens = "on";
    semantic_tokens = "combined";
    relative_line_numbers = "enabled";
    cursor_blink = true;
    scrollbar.show = "never";
    vertical_scroll_margin = 10;
    preferred_line_length = 100;
    wrap_guides = [ 100 ];
    tab_size = 4;

    # Terminal
    terminal = {
      button = false;
      font_family = "Monaspace Argon Var";
      font_size = 18;
      blinking = "on";
      shell.program = "fish";
      detect_venv.on.activate_script = "fish";
    };

    # Files
    file_types."Shell Script" = [
      "**/env.list"
      "**/.env"
      "**/.envrc"
    ];

    # Languages
    languages = {
      Python = {
        language_servers = [
          "ruff"
          "pyright"
        ];
        format_on_save = "on";
        wrap_guides = [ 88 ];
        formatter = [
          { code_action = "source.organizeImports.ruff"; }
          { code_action = "source.fixAll.ruff"; }
          { language_server.name = "ruff"; }
        ];
      };
      Go = {
        tab_size = 4;
        hard_tabs = true;
        format_on_save = "on";
        language_servers = [
          "gopls"
          "golangci-lint"
        ];
        formatter.language_server.name = "gopls";
      };
      Rust.format_on_save = "on";
      JavaScript = {
        tab_size = 2;
        format_on_save = "on";
        formatter.language_server.name = "biome";
        language_servers = [
          "biome"
          "tsgo"
        ];
      };
      TypeScript = {
        tab_size = 2;
        format_on_save = "on";
        formatter.language_server.name = "biome";
        language_servers = [
          "biome"
          "tsgo"
        ];
      };
      TSX = {
        tab_size = 2;
        format_on_save = "on";
        formatter.language_server.name = "biome";
        language_servers = [
          "biome"
          "tsgo"
        ];
      };
      HTML = {
        tab_size = 2;
        format_on_save = "on";
        formatter.language_server.name = "biome";
      };
      CSS = {
        tab_size = 2;
        format_on_save = "on";
        formatter.language_server.name = "biome";
      };
      YAML = {
        format_on_save = "on";
        formatter.language_server.name = "biome";
      };
      Markdown = {
        tab_size = 2;
        format_on_save = "on";
        soft_wrap = "preferred_line_length";
        formatter.language_server.name = "oxfmt";
      };
      Nix = {
        tab_size = 2;
        format_on_save = "on";
        language_servers = [ "nil" ];
      };
      JSON = {
        tab_size = 2;
        format_on_save = "on";
        formatter.language_server.name = "biome";
      };
      JSONC = {
        tab_size = 2;
        format_on_save = "on";
        formatter.language_server.name = "biome";
      };
      Lua = {
        tab_size = 2;
        format_on_save = "on";
        language_servers = [ "lua_ls" ];
        formatter.language_server.name = "lua_ls";
      };
      "Shell Script" = {
        tab_size = 2;
        language_servers = [ "bashls" ];
      };
      Dockerfile = {
        tab_size = 4;
        language_servers = [ "docker_language_server" ];
      };
      XML = {
        tab_size = 2;
        language_servers = [ "lemminx" ];
      };
      Nushell = {
        tab_size = 4;
        language_servers = [ "nushell" ];
      };
    };

    # LSP
    lsp = {
      gopls.settings = {
        gofumpt = true;
        analyses = {
          unusedparams = true;
          shadow = true;
        };
        completeUnimported = true;
        usePlaceholders = true;
        deepCompletion = true;
        matcher = "fuzzy";
        semanticTokens = true;
        staticcheck = false;
        codelenses = {
          generate = true;
          gc_details = true;
        };
        hints = {
          assignVariableTypes = true;
          compositeLiteralFields = true;
          compositeLiteralTypes = true;
          constantValues = true;
          functionTypeParameters = true;
          parameterNames = true;
          rangeVariableTypes = true;
        };
      };
      yaml-language-server.settings.yaml = {
        keyOrdering = false;
        validate = false;
      };
      lua_ls.settings.Lua = {
        codeLens.enable = true;
        hint = {
          enable = true;
          semicolon = "Disable";
        };
        runtime.version = "LuaJIT";
        workspace = {
          checkThirdParty = false;
          library = [ ];
        };
      };
      golangci-lint.initialization_options.command = [
        "golangci-lint"
        "run"
        "--output.json.path=stdout"
        "--issues-exit-code=1"
        "--show-stats=false"
      ];
    };

    # Semantic token overrides
    global_lsp_settings = {
      semantic_token_rules = [
        {
          token_type = "parameter";
          foreground_color = "#e0af68";
        }
        {
          token_type = "namespace";
          foreground_color = "#7aa2f7";
        }
        {
          token_type = "property";
          foreground_color = "#73daca";
        }
        {
          token_type = "variable.member";
          foreground_color = "#73daca";
        }
      ];
    };

    # Title bar / chrome
    title_bar = {
      show_branch_status_icon = true;
      show_branch_name = true;
      show_project_items = true;
      show_onboarding_banner = false;
      show_user_picture = false;
      show_user_menu = false;
      show_sign_in = false;
      show_menus = false;
    };
    toolbar = {
      breadcrumbs = false;
      quick_actions = false;
    };
    tab_bar.show = false;

    # Disable all the buttons
    project_panel.button = false;
    outline_panel.button = false;
    collaboration_panel.button = false;
    git_panel.button = false;
    notification_panel.button = false;
    debugger.button = false;
    diagnostics.button = false;
    search.button = false;

    file_finder = {
      file_icons = true;
      modal_max_width = "large";
    };

    vim_mode = true;
    vim = {
      use_smartcase_find = true;
      use_system_clipboard = "always";
    };
    confirm_quit = false;
    load_direnv = "shell_hook";
  };

  userKeymaps = [
    {
      context = "Editor && vim_mode != insert";
      bindings.";" = "command_palette::Toggle";
    }
    {
      context = "Workspace && !Editor";
      bindings.";" = "command_palette::Toggle";
    }
    {
      context = "Workspace";
      bindings = {
        "\\ a p" = "agent::Toggle";
        "\\ f b" = "tab_switcher::Toggle";
        "\\ f l" = "pane::DeploySearch";
        "\\ f d" = "diagnostics::DeployCurrentFile";
        "\\ f D" = "diagnostics::Deploy";
        "\\ f w" = "project_symbols::Toggle";
        "\\ f c" = "command_palette::Toggle";
        "\\ n g" = "git::Diff";
        "\\ g S" = "git::StageAll";
        "\\ g s" = "git::ToggleStaged";
        "\\ g c" = "git::Commit";
        "\\ g P" = "git::Push";
        "\\ g a" = "git::Add";
        "\\ g p" = "git::Pull";
      };
    }
    {
      context = "Editor";
      bindings = {
        up = null;
        down = null;
        left = null;
        right = null;
      };
    }
    {
      context = "Editor && vim_mode == normal";
      bindings = {
        "\\ f b" = "tab_switcher::Toggle";
        "\\ f l" = "pane::DeploySearch";
        "\\ f d" = "diagnostics::Deploy";
        "\\ f f" = "file_finder::Toggle";
        "\\ f s" = "outline::Toggle";
        "\\ f w" = "project_symbols::Toggle";
        "\\ f r" = "editor::FindAllReferences";
        "\\ f c" = "command_palette::Toggle";
        "\\ n g" = "git::Diff";
        "\\ g s" = "git::StageFile";
        "\\ g c" = "git::Commit";
        "\\ g a" = "git::Add";
        "\\ g P" = "git::Push";
        "\\ g p" = "git::Pull";
        "\\ r n" = "editor::Rename";
        "\\ c a" = "editor::ToggleCodeActions";
        "\\ t d" = "editor::ToggleDiagnostics";
        "g l" = "editor::GoToDeclaration";
        "g t" = "editor::GoToTypeDefinition";
      };
    }
  ];
}
