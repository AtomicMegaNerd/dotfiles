{
  enable = true;
  settings = {
    gui = {
      showBottomLine = false;
      theme = {
        activeBorderColor = [
          "yellow"
          "bold"
        ];
        inactiveBorderColor = [ "blue" ];
        selectedLineBgColor = [ "blue" ];
        optionsTextColor = [ "cyan" ];
      };
    };
    commandTemplates = {
      dockerCompose = "docker-compose";
    };
  };
}
