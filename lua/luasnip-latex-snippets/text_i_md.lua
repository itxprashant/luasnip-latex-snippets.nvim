local M = {}

local ls = require("luasnip")
local f = ls.function_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local s = ls.snippet
local fmta = require("luasnip.extras.fmt").fmta


local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe

function M.retrieve(not_math)

  return {

  s({trig = "ita", name = "italic"}, fmta("*<>*", {i(1)})),
  s({trig = "bo", name = "bold"}, fmta("**<>**", {i(1)})),


  }

end

return M
