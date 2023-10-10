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
		nix = {
			require("formatter.filetypes.nix").nixpkgs_fmt,
		},
		go = {
			require("formatter.filetypes.go").gofmt,
		},
		json = {
			require("formatter.filetypes.json").prettier,
		},
		yaml = {
			require("formatter.filetypes.yaml").prettier,
		},
	},
})
