-- AtomicMegaNerd's Rex Lua Config
--
-- NOTE: After editing, run `rex config check` and then `rex config reload` to activate changes.

local amn = require("amn_rex_lib")

amn.open_floating_tui_app({
	app = "lazygit",
	key = "alt+g",
})

amn.open_right_split_tui_app({
	app = "lazygit",
	key = "shift+alt+g",
})

amn.open_floating_tui_app({
	app = "btop",
	key = "alt+b",
})

amn.open_floating_tui_app({
	app = "fish",
	key = "alt+shift+f",
})

amn.new_rex_workspace({ "Neovim", "Fish", "OpenCode" }, "alt+n")
