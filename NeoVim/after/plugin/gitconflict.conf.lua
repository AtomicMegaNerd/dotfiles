local status, gc = pcall(require, "git-conflict")
if not status then
	return
end

gc.setup()
