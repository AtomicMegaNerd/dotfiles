{
  config,
  lib,
  ...
}:
{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        mouseEvents = false;
        timeFormat = "2006-01-02";
        shortTimeFormat = "15:04";
        showRandomTip = false;
        showBottomLine = false;
        nerdFontsVersion = "3";
        commandLogSize = 12;
      };
      git = {
        autoFetch = false;
        autoRefresh = false;
        diffRenderers = [
          { command = "${lib.getExe config.programs.delta.package} --dark --paging=never"; }
        ];
      };
      os.editPreset = "nvim";
      update.method = "never";
    };
  };
}
