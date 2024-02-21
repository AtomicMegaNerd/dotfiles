return {
	"airblade/vim-rooter",
	config = function()
		-- These files signify the root of a project.
		vim.g.rooter_patterns = {
			"Cargo.toml",
			"go.mod",
			"Dockerfile",
			"pyproject.toml",
			"init.lua",
			"config.fish",
			"flake.nix",
		}
	end,
}
