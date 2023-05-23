local rf_status, rf = pcall(require, "refactoring")
if not rf_status then
	return
end

rf.setup()
