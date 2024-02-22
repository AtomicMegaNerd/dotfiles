return {
	"numToStr/Comment.nvim",
	config = function()
		local utils = require("amn.utils")
		local comment = utils.do_import("Comment")
		if not comment then
			return
		end

		comment.setup()
	end,
}
