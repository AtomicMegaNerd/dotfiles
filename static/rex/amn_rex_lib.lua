-- AtomicMegaNerd's Rex Library.
local M = {}

local FLOATING = "floating"
local RSPLIT = "rsplit"

---@class TuiBlockConfig
---@field app_name string
---@field keybinding string
---@field focus boolean
---@field label string
---@field action_name string
---@field description string
---@field bounds? { x: number, y: number, w: number, h: number }
---@field create_block fun(ctx: table, layout: table): any

--- Build the config for the Rex block for the specified app.
---@param kind "floating"|"rsplit"
---@param app_name string
---@param keybinding string
---@return TuiBlockConfig
local function build_block_cfg_object(kind, app_name, keybinding)
	local label = kind .. "_" .. app_name
	local block_cfg = {
		app_name = app_name,
		keybinding = keybinding,
		focus = true,
		label = label,
		action_name = "open_" .. label,
	}

	if kind == FLOATING then
		block_cfg.description = "Open " .. app_name .. " at the working directory in a floating pane."
		block_cfg.bounds = { x = 0.1, y = 0.1, w = 0.8, h = 0.8 }
		block_cfg.create_block = function(_, layout)
			return rex.session.new_layer({
				bounds = block_cfg.bounds,
				layout = layout,
				focus = block_cfg.focus,
			})
		end
	elseif kind == RSPLIT then
		block_cfg.description = "Open "
			.. app_name
			.. " at the working directory to the right of this pane."
		block_cfg.create_block = function(ctx, layout)
			return rex.session.new_split({
				anchor_id = ctx.block_id,
				direction = "horizontal",
				side = "after",
				layout = layout,
				focus = block_cfg.focus,
			})
		end
	else
		error("Unknown TUI app kind: " .. tostring(kind))
	end

	return block_cfg
end

--- Return the invoking terminal's cwd, preferring the foreground process.
---@param ctx table Rex action context.
---@return string cwd
local function get_cwd(ctx)
	local process =
		assert(rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id }))
	local cwd = (process.foreground and process.foreground.cwd)
		or (process.child and process.child.cwd)
	if not cwd then
		error("Couldn't determine the focused terminal's working directory", 0)
	end
	return cwd
end

local function bind_if_available(keybinding, action_name)
	if #rex.bindings({ key = keybinding }) > 0 then
		error(("Rex keybinding %q is already in use"):format(keybinding), 0)
	end

	rex.bind(keybinding, action_name)
end

--- Make the API calls to actually create our new split/floating block, etc.
---@param block_cfg TuiBlockConfig
local function create_rex_tui_block(block_cfg)
	rex.action({
		name = block_cfg.action_name,
		title = block_cfg.app_name,
		description = block_cfg.description,

		run = function(ctx)
			local cwd = get_cwd(ctx)

			local layout = rex.layout.block({
				flavor = "com.superlogical.terminal.shell",
				label = block_cfg.label,
				options = {
					command = { block_cfg.app_name },
					cwd = cwd,
					interactive = true,
				},
			})

			return assert(block_cfg.create_block(ctx, layout))
		end,
	})

	bind_if_available(block_cfg.keybinding, block_cfg.action_name)
end

--- Opens the app in a floating pane.
---@param tool { app: string, key: string }
function M.open_floating_tui_app(tool)
	create_rex_tui_block(build_block_cfg_object(FLOATING, tool.app, tool.key))
end

--- Opens the app in a new pane to the right of the invoking pane.
---@param tool { app: string, key: string }
function M.open_right_split_tui_app(tool)
	create_rex_tui_block(build_block_cfg_object(RSPLIT, tool.app, tool.key))
end

--- Define a keybinding to create a Rex workspace at the working directory.
---@param tab_names string[]
---@param keybinding string
function M.new_rex_workspace(tab_names, keybinding)
	local action_name = "new_rex_workspace"

	rex.action({
		name = action_name,
		title = "New Rex Workspace",
		description = "Create a Rex workspace at the working directory with a shell tab for each requested name.",
		run = function(ctx)
			local cwd = get_cwd(ctx)
			local initial_windows = {}

			for _, tab_name in ipairs(tab_names) do
				initial_windows[#initial_windows + 1] = {
					window_label = tab_name,
					layout = rex.layout.block({
						flavor = "com.superlogical.terminal.shell",
						label = tab_name,
						options = { cwd = cwd },
					}),
				}
			end

			return assert(rex.call("session.create", {
				label = cwd,
				initial_windows = initial_windows,
			}))
		end,
	})

	bind_if_available(keybinding, action_name)
end

return M
