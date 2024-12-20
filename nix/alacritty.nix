{
  enable = true;
  settings = {
    font = {
      size = 18;
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
    window = { decorations_theme_variant = "Dark"; };
  };
}
