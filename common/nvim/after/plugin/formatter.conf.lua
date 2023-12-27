local fmt_status, fmt = pcall(require, "formatter")
if not fmt_status then
  vim.notify("Cannot load formatter", vim.log.levels.ERROR)
  return
end

fmt.setup({
  filetype = {
    nix = {
      require("formatter.filetypes.nix").nixpkgs_fmt,
    },
    json = {
      require("formatter.filetypes.json").prettier,
    },
    yaml = {
      require("formatter.filetypes.yaml").prettier,
    },
    lua = {
      require("formatter.filetypes.lua").stylua,
    },
    sh = {
      require("formatter.filetypes.sh").shfmt,
    },
    terraform = {
      require("formatter.filetypes.terraform").terraformfmt,
    },
  },
})
