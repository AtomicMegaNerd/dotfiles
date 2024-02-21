return {
  "numToStr/Comment.nvim",
  config = function()
    local status, comment = pcall(require, "Comment")
    if not status then
      vim.notify("Cannot load Comment", vim.log.levels.ERROR)
      return
    end

    comment.setup()
  end,
}
