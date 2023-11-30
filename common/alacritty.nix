{ pkgs }:
{
  enable = true;
  settings = {
    font = {
      normal = {
        family = "JetBrainsMono Nerd Font";
        style = "Medium";
      };
      size = 18;
    };
    env = {
      TERM = "xterm-256color";
    };
    cursor = {
      style = {
        shape = "Block";
        blinking = "Always";
      };
    };
    mouse_bindings = [
      { mouse = "Right"; action = "Paste"; }
      { mouse = "Left"; action = "Copy"; }
    ];
    window = {
      decorations = "None";
      padding = {
        x = 3;
        y = 3;
      };
      opacity = 0.97;
    };

    colors = {
      # Default colors
      primary = {
        background = "#303446"; # base
        foreground = "#C6D0F5"; # text
        # Bright and dim foreground colors
        dim_foreground = "#C6D0F5"; # text
        bright_foreground = "#C6D0F5"; # text
      };

      # Cursor colors
      cursor = {
        text = "#303446"; # base
        cursor = "#F2D5CF"; # rosewater
        vi_mode_cursor = {
          text = "#303446"; # base
          cursor = "#BABBF1"; # lavender
        };
      };

      # Search colors
      search = {
        matches = {
          foreground = "#303446"; # base
          background = "#A5ADCE"; # subtext0
        };
        focused_match = {
          foreground = "#303446"; # base
          background = "#A6D189"; # green
        };
        footer_bar = {
          foreground = "#303446"; # base
          background = "#A5ADCE"; # subtext0
        };
      };

      # Keyboard regex hints
      hints = {
        start = {
          foreground = "#303446"; # base
          background = "#E5C890"; # yellow
        };
        end = {
          foreground = "#303446"; # base
          background = "#A5ADCE"; # subtext0
        };
      };
      # Selection colors
      selection = {
        text = "#303446"; # base
        background = "#F2D5CF"; # rosewater
      };

      # Normal colors
      normal = {
        black = "#51576D"; # surface1
        red = "#E78284"; # red
        green = "#A6D189"; # green
        yellow = "#E5C890"; # yellow
        blue = "#8CAAEE"; # blue
        magenta = "#F4B8E4"; # pink
        cyan = "#81C8BE"; # teal
        white = "#B5BFE2"; # subtext1
      };
      # Bright colors
      bright = {
        black = "#626880"; # surface2
        red = "#E78284"; # red
        green = "#A6D189"; # green
        yellow = "#E5C890"; # yellow
        blue = "#8CAAEE"; # blue
        magenta = "#F4B8E4"; # pink
        cyan = "#81C8BE"; # teal
        white = "#A5ADCE"; # subtext0
      };

      # Dim colors
      dim = {
        black = "#51576D"; #surface1
        red = "#E78284"; #red
        green = "#A6D189"; #green
        yellow = "#E5C890"; #yellow
        blue = "#8CAAEE"; #blue
        magenta = "#F4B8E4"; #pink
        cyan = "#81C8BE"; #teal
        white = "#B5BFE2"; #subtext1
      };

      indexed_colors = [
        {
          index = 16;
          color = "#EF9F76";
        }
        { index = 17; color = "#F2D5CF"; }
      ];
    };
  };
}
