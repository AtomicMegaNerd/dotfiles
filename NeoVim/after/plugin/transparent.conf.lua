local tr_status, tr = pcall(require, "transparent")
if not tr_status then
	return
end

tr.setup({
	enable = true,
})
