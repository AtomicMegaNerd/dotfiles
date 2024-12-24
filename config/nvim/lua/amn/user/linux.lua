-- Detect if this Neovim is running in WSL
local is_wsl = function()
	local kern_ver = vim.fn.readfile("/proc/version")[1]
	if kern_ver == nil then
		return false
	end
	if string.find(kern_ver, "microsoft") then
		return true
	end
	return false
end

local is_wayland = function()
	local xdg_session_type = vim.fn.getenv("XDG_SESSION_TYPE")
	if xdg_session_type == nil then
		return false
	end
	if string.find(xdg_session_type, "wayland") then
		return true
	end
	return false
end

-- If we are in WSL then we want to use the Windows clipboard :-)
if is_wsl() then
	vim.g.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = "clip.exe",
			["*"] = "clip.exe",
		},
		paste = {
			["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		},

		cache_enabled = 0,
	}
end

-- If we are in Wayland then we want to use wl-clipboard :-)
if is_wayland() then
	vim.g.clipboard = {
		name = "WaylandClipboard",
		copy = {
			["+"] = "wl-copy",
			["*"] = "wl-copy",
		},
		paste = {
			["+"] = "wl-paste",
			["*"] = "wl-paste",
		},

		cache_enabled = 0,
	}
end
