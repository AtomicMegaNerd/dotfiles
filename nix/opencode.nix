{
  ...
}:
{

  programs.opencode = {
    enable = true;
    context = builtins.readFile ../static/opencode-AGENTS.md;
    settings = {
      shell = "fish";
      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
          headers = {
            CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
          };
          enabled = true;
        };
      };
    };
  };
}
