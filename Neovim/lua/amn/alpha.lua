local alpha_status, alpha = pcall(require, "alpha")
if not alpha_status then
  vim.notify("Cannot load alpha", vim.log.levels.ERROR)
  return
end

local startify_status, startify = pcall(require, "alpha.themes.startify")
if not startify_status then
  vim.notify("Cannot load alpha.themes.startify", vim.log.levels.ERROR)
  return
end

startify.section.header.val = {
  [[     ___   __                  _      __  ___                 _   __              __]],
  [[    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /]],
  [[   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /]],
  [[  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /]],
  [[ /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/]],
  [[                                              /____/]],
}
alpha.setup(startify.config)
