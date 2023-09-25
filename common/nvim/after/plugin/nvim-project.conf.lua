local status, project_nvim = pcall(require, "project_nvim")
if not status then
	return
end

project_nvim.setup()
