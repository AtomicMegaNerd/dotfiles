{ pkgs }:
{
  enable = true;
  settings = {
    theme = "catppuccin_frappe";
    editor = {
      line-number = "relative";
      true-color = true;
      rulers = [ 100 ];
      scrolloff = 8;
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
