local fmt_status, fmt = pcall(require, "formatter")
if not fmt_status then
	return
end

fmt.setup({

	filetype = {

		python = {
			require("formatter.filetypes.python").black,
		},
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
	},
})
