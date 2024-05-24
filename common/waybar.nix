{ lib }: {
  enable = true;
  catppuccin = {
    enable = true;
    flavor = "frappe";
  };
  settings = [{
    layer = "top";
    height = 40;
    modules-left = [ "hyprland/workspaces" ];
    modules-center = [ "hyprland/window" ];
    modules-right = [ "pulseaudio" "memory" "cpu" "clock" "tray" ];
    "hyprland/workspaces" = { format = "{name}"; };
    "hyprland/window" = {
      max-length = 200;
      separate-outputs = true;
    };
    pulseaudio = {
      format = "{volume}% ";
      format-bluetooth = "{volume}%   ";
      format-muted = "";
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
      font-family: JetBrainsMono Nerd Font Mono;
      min-height: 0px;
    }

    #waybar {
      background-color: @base;
      margin: 0px 5px;
    }

    #window {
      font-weight: bold;
      border-radius: 1rem;
    }

    #workspaces {
      border-radius: 16px;
      margin: 0px 4px;
      padding: 0px 5px;
    }

    #workspaces button {
      font-weight: bold;
      border-radius: 1rem;
      opacity: 0.5;
    }

    #workspaces button.active {
      font-weight: bold;
      opacity: 1;
      border-radius: 1rem;
    }

    #workspaces button:hover {
      font-weight: bold;
      border-radius: 1rem;
    }

    #pulseaudio, #cpu, #memory {
      font-weight: bold;
      border-radius: 24px 5px 24px 5px;
      margin: 4px 0px;
      margin-left: 7px;
      padding: 0px 18px;
      padding-top: 2px;
      padding-bottom: 2px;
    }

    #clock {
      font-weight: bold;
      border-radius: 24px 5px 24px 5px;
      margin: 4px 0px;
      margin-left: 7px;
      padding: 0px 18px;
      margin-right: 7px;
      padding-top: 2px;
      padding-bottom: 2px;
    }

    #tray {
      margin-right: 1rem;
      border-radius: 1rem;
    }
  ''];
}
