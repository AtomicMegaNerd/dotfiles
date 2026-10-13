{ ... }:
{
  # Rift is installed and started by nix-darwin's Homebrew integration. Home
  # Manager owns only the user's config, keeping the two generations separate.
  xdg.configFile."rift/config.toml".text = ''
    # Rift scrolling-column layout. The [keys] table replaces Rift's bundled
    # map, so the active bindings below mirror the upstream v0.6.9 defaults.

    [settings.layout]
    mode = "scrolling"

    [settings.layout.scrolling]
    column_width_ratio = 0.7
    alignment = "center"
    focus_navigation_style = "niri"

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

    "Alt + 0" = { switch_to_workspace = 0 }
    "Alt + 1" = { switch_to_workspace = 1 }
    "Alt + 2" = { switch_to_workspace = 2 }
    "Alt + 3" = { switch_to_workspace = 3 }

    "comb1 + 0" = { move_window_to_workspace = 0 }
    "comb1 + 1" = { move_window_to_workspace = 1 }
    "comb1 + 2" = { move_window_to_workspace = 2 }
    "comb1 + 3" = { move_window_to_workspace = 3 }

    "Alt + Tab" = "switch_to_last_workspace"

    "Alt + Shift + Left" = { join_window = "left" }
    "Alt + Shift + Right" = { join_window = "right" }
    "Alt + Shift + Up" = { join_window = "up" }
    "Alt + Shift + Down" = { join_window = "down" }
    "Alt + Comma" = "toggle_stack"
    "Alt + Slash" = "toggle_orientation"
    "Alt + Ctrl + E" = "unjoin_windows"

    "Alt + Shift + Space" = "toggle_window_floating"
    "Alt + F" = "toggle_fullscreen"
    "Alt + Shift + F" = "toggle_fullscreen_within_gaps"
    "comb1 + Ctrl + Space" = "toggle_focus_floating"

    "Alt + Shift + Equal" = "resize_window_grow"
    "Alt + Shift + Minus" = "resize_window_shrink"

    "Alt + Enter" = { exec = [ "/bin/bash", "-c", "open -a \"/System/Applications/Utilities/Terminal.app\"" ] }
    "Alt + Shift + D" = "debug"
    "Alt + Ctrl + S" = "serialize"
    "Alt + Ctrl + Q" = "save_and_exit"
  '';
}
