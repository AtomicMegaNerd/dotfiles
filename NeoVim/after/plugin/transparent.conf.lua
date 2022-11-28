local status, tr = pcall(require, "transparent")
if not status then
	return
end

tr.setup({
	enable = true,
})
