local fmt_status, fmt = pcall(require, "formatter")
if not fmt_status then
  return
end

fmt.setup({
  filetype = {
    json = {
      require("formatter.filetypes.json").prettier,
    },
    yaml = {
      require("formatter.filetypes.yaml").prettier,
    },
  },
})
