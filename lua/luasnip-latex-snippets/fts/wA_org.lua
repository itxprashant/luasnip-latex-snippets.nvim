local ls = require("luasnip")
local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe
local s = ls.snippet
local f = ls.function_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta
local with_priority = require("luasnip-latex-snippets.util.utils").with_priority

local M = {}

function M.retrieve(not_math)
  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = pipe({ not_math }),
  }) --[[@as function]]

  return {
    parse_snippet({ trig = "fm", name = "Math", }, "\\(${1:${TM_SELECTED_TEXT}}\\)"),
    parse_snippet({ trig = "dm", name = "Block Math", }, "\\[\n\t${1:${TM_SELECTED_TEXT}}\n\\]"),

  }

end

return M
