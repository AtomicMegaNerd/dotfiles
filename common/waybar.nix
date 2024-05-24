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
      font-family: JetBrainsMono Nerd Font Mono;
    }

    #waybar {
      background-color: @base;
      margin: 5px 5px;
    }

    #workspaces {
      border-radius: 1rem;
      margin: 5px;
      margin-left: 1rem;
    }

    #workspaces button {
      border-radius: 1rem;
      padding: 0.4rem;
    }

    #workspaces button.active {
      border-radius: 1rem;
    }

    #workspaces button:hover {
      border-radius: 1rem;
    }

    #clock, #cpu, #memory {
      border-radius: 0px 1rem 1rem 0px;
      margin-right: 2rem;
    }

    #tray {
      margin-right: 1rem;
      border-radius: 1rem;
    }
  ''];
}
