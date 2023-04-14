{ pkgs }:
{
  enable = true;
  languages = [{
    name = "python";
    indent = {
      tab-width = 4;
      unit = " ";
    };
    language-server = {
      command = "pyright-langserver";
      args = [ "--stdio" ];
    };
    formatter = { command = "black"; args = [ "-" ]; };
    auto-format = true;
  }];

  settings = {
    theme = "nightfox";
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
