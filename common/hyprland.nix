{
  enable = true;

  catppuccin = {
    enable = true;
    flavor = "frappe";
  };

  settings = {

    monitor = "DP-3,3840x2160@144,0x0,1";

    # Default Apps
    "$terminal" = "alacritty";
    "$browser" = "firefox";
    "$launcher" = "walker";

    # Default mod key
    "$mod" = "SUPER";

    # Execute apps at launch
    exec-once = [
      "waybar"
      "mako"
      "hypridle"
      "hyprpaper"
      "blueman"
      ''
        wl-paste -p -t text --watch clipman store -P --histpath="~/.local/share/clipman-primary.json"''
    ];

    # Bindings
    bind = [
      "$mod, M, exit"
      "$mod, Q, killactive"
      "$mod, F, exec, thunar"
      "$mod, U, togglefloating"
      "$mod, T, exec, $terminal"
      "$mod, B, exec, $browser"
      "$mod, space, exec, $launcher"
      "$mod, L, exec, loginctl lock-session"
      "ctrl, right, workspace, e+1"
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 1;
      col.active_border = "$teal";
      col.inactive_border = "$surface1";
    };

    decoration = {
      rounding = 10;
      blur = {
        size = 8;
        passes = 2;
      };

      col.shadow = "$teal";
      col.shadow_inactive = "0xff$baseAlpha";
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
    };
  };
}
