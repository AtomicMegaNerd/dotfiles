{ pkgs, ... }: {
  enable = true;
  settings = if pkgs.stdenv.isDarwin then {
    font = {
      size = 16;
      bold = {
        family = "JetBrainsMono Nerd Font";
        style = "Bold";
      };
      italic = {
        family = "JetBrainsMono Nerd Font";
        style = "Italic";
      };
      normal = {
        family = "JetBrainsMono Nerd Font";
        style = "Medium";
      };
    };
    mouse = {
      bindings = [
        {
          action = "Paste";
          mouse = "Right";
        }
        {
          action = "Copy";
          mouse = "Left";
        }
      ];
    };
    selection = { save_to_clipboard = true; };
    window = {
      decorations = "Buttonless";
      padding = {
        x = 3;
        y = 3;
      };
    };
  } else {
    font = {
      size = 16;
      bold = {
        family = "JetBrainsMono Nerd Font";
        style = "Bold";
      };
      italic = {
        family = "JetBrainsMono Nerd Font";
        style = "Italic";
      };
      normal = {
        family = "JetBrainsMono Nerd Font";
        style = "Medium";
      };
    };
    mouse = {
      bindings = [
        {
          action = "Paste";
          mouse = "Right";
        }
        {
          action = "Copy";
          mouse = "Left";
        }
      ];
    };
    selection = { save_to_clipboard = true; };
    window = {
      decorations = "None";
      padding = {
        x = 3;
        y = 3;
      };
    };
  };
  catppuccin = {
    enable = true;
    flavor = "macchiato";
  };
}
