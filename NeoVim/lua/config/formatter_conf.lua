require("formatter").setup({
	filetype = {
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		go = {
			require("formatter.filetypes.go").gofmt,
		},
		rust = {
			require("formatter.filetypes.rust").rustfmt,
		},
		python = {
			require("formatter.filetypes.python").black,
		},
		javascript = {
			require("formatter.filetypes.javascript").prettier,
		},
	},
})
