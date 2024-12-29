{
  enable = true;
  settings = {
    theme = "catppuccin-macchiato";

    editor = {
      line-number = "relative";
      true-color = true;
      rulers = [ 100 ];
      scrolloff = 10;
      gutters = [ "diagnostics" "line-numbers" ];
      auto-format = true;

      cursor-shape = {
        insert = "block";
        normal = "block";
        select = "block";
      };
    };
  };
}
