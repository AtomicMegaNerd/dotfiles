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
