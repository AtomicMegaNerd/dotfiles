{ pkgs }: {
  enable = true;

  catppuccin = {
    enable = true;
    flavor = "macchiato";
  };

  settings = {

    monitor = "DP-3,3840x2160@144,0x0,1";

    # Default Apps
    "$terminal" = "alacritty";
    "$browser" = "firefox";
    "$launcher" = "walker";

    # Default mod key
    "$alt" = "alt";
    "$shift_alt" = "shift_alt";
    "$super" = "super";
    "$shiftsuper" = "shift_super";

    # Execute apps at launch
    exec-once = [
      "waybar"
      "mako"
      "hypridle"
      "hyprpaper"
      "blueman"
      ''
        wl-paste -p -t text --watch clipman store -P --histpath="~/.local/share/clipman-primary.json"''
      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &"
    ];

    # Bindings
    bind = [
      "$super, F, exec, thunar"
      "$super, T, exec, $terminal"
      "$super, B, exec, $browser"
      "$super, space, exec, $launcher"
      "$alt, X, exit"
      "$alt, Q, killactive"
      "$alt, U, togglefloating"
      "$alt, L, exec, loginctl lock-session"
      "$shiftmod, S, exec, grim"
      "ctrl, right, workspace, e+1"
      "$alt, left, movefocus, l"
      "$alt, right, movefocus, r"
      "$alt, up, movefocus, u"
      "$alt, down, movefocus, d"
      "$alt, 1, workspace, 1"
      "$alt, 2, workspace, 2"
      "$alt, 3, workspace, 3"
      "$alt, 4, workspace, 4"
      "$alt, 5, workspace, 5"
      "$alt, 6, workspace, 6"
      "$alt, 7, workspace, 7"
      "$alt, 8, workspace, 8"
      "$alt, 9, workspace, 9"
      "$alt, 0, workspace, 10"
      "$alt SHIFT, 1, movetoworkspace, 1"
      "$alt SHIFT, 2, movetoworkspace, 2"
      "$alt SHIFT, 3, movetoworkspace, 3"
      "$alt SHIFT, 4, movetoworkspace, 4"
      "$alt SHIFT, 5, movetoworkspace, 5"
      "$alt SHIFT, 6, movetoworkspace, 6"
      "$alt SHIFT, 7, movetoworkspace, 7"
      "$alt SHIFT, 8, movetoworkspace, 8"
      "$alt SHIFT, 9, movetoworkspace, 9"
      "$alt SHIFT, 0, movetoworkspace, 10"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 1;
      "col.active_border" = "$teal";
      "col.inactive_border" = "$surface1";
    };

    decoration = {
      rounding = 10;
      blur = {
        size = 8;
        passes = 2;
      };
      "col.shadow" = "$teal";
      "col.shadow_inactive" = "0xff$baseAlpha";
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
    };
  };
}
