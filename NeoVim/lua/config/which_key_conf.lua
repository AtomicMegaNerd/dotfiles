local wk_status, wk = pcall(require, "which-key")
if not wk_status then
	return
end

wk.setup()
