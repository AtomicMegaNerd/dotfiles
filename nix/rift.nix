{ ... }:
{
  xdg.configFile."rift/config.toml".text = ''
    [settings]
    focus_follows_mouse = false

    [settings.layout]
    mode = "master_stack"

    [settings.layout.master_stack]
    master_ratio = 0.55
    master_count = 1
    master_side = "left"
    new_window_placement = "stack"

    [settings.layout.gaps.outer]
    left = 5.0
    right = 5.0

    [settings.layout.gaps.inner]
    horizontal = 5.0
    vertical = 5.0

    [virtual_workspaces]
    enabled = false
    app_rules = [
      { app_id = "com.factorio", manage = false },
      { app_id = "io.github.endless-sky", manage = false },
    ]

    [modifier_combinations]
    comb1 = "Alt + Shift"

    [keys]
    "Alt + Z" = "toggle_space_activated"

    "Alt + H" = { move_focus = "left" }
    "Alt + J" = { move_focus = "down" }
    "Alt + K" = { move_focus = "up" }
    "Alt + L" = { move_focus = "right" }

    "comb1 + H" = { move_node = "left" }
    "comb1 + J" = { move_node = "down" }
    "comb1 + K" = { move_node = "up" }
    "comb1 + L" = { move_node = "right" }

    "Alt + Enter" = "promote_to_master"
    "Alt + Slash" = "swap_master_stack"
    "Alt + Comma" = { adjust_master_count = { delta = 1 } }
    "Alt + Period" = { adjust_master_count = { delta = -1 } }

    "Alt + Shift + Space" = "toggle_window_floating"
    "Alt + F" = "toggle_fullscreen"
    "Alt + Shift + F" = "toggle_fullscreen_within_gaps"
    "comb1 + Ctrl + Space" = "toggle_focus_floating"

    "Alt + Shift + Equal" = { adjust_master_ratio = 0.05 }
    "Alt + Shift + Minus" = { adjust_master_ratio = -0.05 }

    "Alt + Shift + Enter" = { exec = [ "/bin/bash", "-c", "open -a Ghostty" ] }
    "Alt + Shift + D" = "debug"
    "Alt + Ctrl + S" = "serialize"
    "Alt + Ctrl + Q" = "save_and_exit"
  '';
}
