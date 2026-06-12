{
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
      theme = {
        activeBorderColor = [
          "#ff966c"
          "bold"
        ];
        inactiveBorderColor = [ "#589ed7" ];
        searchingActiveBorderColor = [
          "#ff966c"
          "bold"
        ];
        optionsTextColor = [ "#82aaff" ];
        selectedLineBgColor = [ "#2d3f76" ];
        cherryPickedCommitFgColor = [ "#82aaff" ];
        cherryPickedCommitBgColor = [ "#c099ff" ];
        markedBaseCommitFgColor = [ "#82aaff" ];
        markedBaseCommitBgColor = [ "#ffc777" ];
        unstagedChangesColor = [ "#c53b53" ];
        defaultFgColor = [ "#c8d3f5" ];
      };
    };
    git = {
      autoFetch = false;
      autoRefresh = false;
    };
    os.editPreset = "nvim";
    update.method = "never";
  };
}
