local fmt_status, fmt = pcall(require, "formatter")
if not fmt_status then
	return
end

fmt.setup({
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.INFO,
	filetype = {
		python = {
			require("formatter.filetypes.python").black,
		},
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
	},
})
