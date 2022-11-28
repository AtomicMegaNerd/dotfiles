local gc_status, gc = pcall(require, "git-conflict")
if not gc_status then
	return
end

gc.setup()
