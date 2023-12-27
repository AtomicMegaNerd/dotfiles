local nt_status, nt = pcall(require, "neotest")
if not nt_status then
  vim.notify("Cannot load neotest", vim.log.levels.ERROR)
  return
end

local nt_pytest_status, nt_pytest = pcall(require, "neotest-python")
if not nt_pytest_status then
  vim.notify("Cannot load neotest-python", vim.log.levels.ERROR)
  return
end

local nt_go_status, nt_go = pcall(require, "neotest-go")
if not nt_go_status then
  vim.notify("Cannot load neotest-go", vim.log.levels.ERROR)
  return
end

nt.setup({
  adapters = {
    nt_pytest({
      args = { "--log-level", "INFO" },
    }),
    nt_go({}),
  },
})
