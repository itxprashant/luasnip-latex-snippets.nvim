local ls = require("luasnip")
-- local f = ls.function_node
local t = ls.text_node
local i = ls.insert_node
-- local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep


local M = {}

function M.retrieve(not_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local condition = utils.pipe({ require("luasnip.extras.expand_conditions").line_begin, not_math })

  local s = ls.extend_decorator.apply(ls.snippet, { condition = condition, }) --[[@as function]]

  return {

  s({ trig = "ali", name = "Align" }, { t({ "\\begin{align*}", "\t" }), i(1), t({ "", ".\\end{align*}" }) }),
  s({ trig = "beg", name = "begin{} / end{}" }, fmta("\\begin{<>}\n\t<>\n\\end{<>}", { i(1), i(2), rep(1) })),
  s({ trig = "case", name = "cases" }, fmta("\\begin{cases}\n\t<>\n\\end{cases}", { i(1) })),
  s({ trig = "ques", name = "Question" }, fmta("\\begin{question}\n<>\n\\end{question}", { i(1) })),
  s({ trig = "note", name = "Note" }, fmta("\\begin{note}\n<>\n\\end{note}", { i(1) })),
  s({ trig = "exam", name = "Example" }, fmta("\\begin{example}\n<>\n\\end{example}", { i(1) })),

  }
end

return M
