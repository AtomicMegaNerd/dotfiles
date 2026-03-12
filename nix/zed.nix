{ lib, pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    package = null; # Just manage the config
    userSettings = {
      # AI and MCP
      edit_predictions = {
        provider = "copilot";
        mode = "subtle";
      };
      agent = {
        button = false;
        tool_permissions.default = "allow";
        default_model = {
          provider = "copilot_chat";
          model = "gpt-5";
        };
      };
      context_servers = {
        context7 = {
          enabled = true;
          command = "npx";
          args = [
            "-y"
            "@upstash/context7-mcp"
          ];
        };
        github-mcp-server = {
          enabled = true;
          command = "github-mcp-server";
          args = [ "stdio" ];
        };
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
      icon_theme = "Catppuccin Macchiato";
      theme = lib.mkForce "Catppuccin Macchiato - No Italics";

      # Fonts
      ui_font_size = 16;
      buffer_font_size = 16;
      buffer_font_family = "Monaspace Argon Var";
      buffer_font_weight = 500;
      buffer_font_features = {
        ss01 = true;
        ss02 = true;
        ss03 = true;
        ss04 = true;
        ss05 = true;
        ss06 = true;
        ss07 = true;
        ss08 = true;
        ss09 = true;
        ss10 = true;
        liga = true;
        calt = true;
      };

      # Editor
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
        font_size = 16;
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
        };
        Rust.format_on_save = "on";
        JavaScript = {
          tab_size = 2;
          format_on_save = "on";
          formatter.language_server.name = "prettier";
        };
        TypeScript = {
          tab_size = 2;
          format_on_save = "on";
          formatter.language_server.name = "prettier";
        };
        TSX = {
          tab_size = 2;
          format_on_save = "on";
          formatter.language_server.name = "prettier";
        };
        HTML = {
          tab_size = 2;
          format_on_save = "on";
          formatter.language_server.name = "prettier";
        };
        CSS = {
          tab_size = 2;
          format_on_save = "on";
          formatter.language_server.name = "prettier";
        };
        YAML = {
          format_on_save = "on";
          formatter.language_server.name = "prettier";
        };
        Markdown = {
          tab_size = 2;
          format_on_save = "on";
          soft_wrap = "preferred_line_length";
          formatter.language_server.name = "prettier";
        };
        "Shell Script".hard_tabs = true;
        Lua = {
          tab_size = 2;
          format_on_save = "on";
        };
        Nix = {
          tab_size = 2;
          format_on_save = "on";
          language_servers = [ "nil" ];
        };
        JSON = {
          tab_size = 2;
          format_on_save = "on";
        };
        JSONC = {
          tab_size = 2;
          format_on_save = "on";
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
          staticcheck = false;
        };
        yaml-language-server.settings.yaml.keyOrdering = false;
        golangci-lint.initialization_options.command = [
          "golangci-lint"
          "run"
          "--output.json.path=stdout"
          "--issues-exit-code=1"
          "--show-stats=false"
        ];
      };

      # Title bar / chrome
      title_bar = {
        show_branch_icon = true;
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
        git_status = true;
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
      {
        bindings."\\ f f" = [
          "task::Spawn"
          {
            task_name = "Television File Finder";
            reveal_target = "center";
          }
        ];
      }
    ];

    userTasks = [
      {
        label = "Television File Finder";
        command = "zed \"$(tv files)\"";
        hide = "always";
        allow_concurrent_runs = true;
        use_new_terminal = true;
      }
    ];
  };
}
