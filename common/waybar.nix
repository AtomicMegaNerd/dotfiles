{ lib }: {
  enable = true;
  catppuccin = {
    enable = true;
    flavor = "frappe";
  };
  settings = [{
    layer = "top";
    modules-left = [ "hyprland/workspaces" ];
    modules-center = [ "hyprland/window" ];
    modules-right = [ "pulseaudio" "memory" "cpu" "clock" "tray" ];
    "hyprland/workspaces" = { format = "{name}"; };
    "hyprland/window" = {
      max-length = 200;
      separate-outputs = true;
    };
    pulseaudio = {
      format = "{volume}% {icon}";
      format-bluetooth = "{volume}% {icon}";
      format-muted = "";
      format-icons = {
        "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
        "headphones" = "";
        "handsfree" = "";
        "headset" = "";
        "phone" = "";
        "portable" = "";
        "car" = "";
        "default" = [ "" "" ];
      };
      scroll-step = 1;
      on-click = "pavucontrol";
    };
    memory = {
      interval = 5;
      format = "Mem {}%";
    };
    cpu = {
      interval = 5;
      format = "CPU {usage:2}%";
    };
    clock = { format-alt = "{:%a; %d. %b  %H:%M}"; };
    tray = {
      icon-size = 24;
      spacing = 10;
    };
  }];

  style = lib.strings.concatStrings [''
    * {
      font-size: 20px;
      border-radius: 0px;
      border: none;
      margin: 10px 10px;
      font-family: JetBrainsMono Nerd Font Mono;
      min-height: 0px;
    }
  ''];
}
