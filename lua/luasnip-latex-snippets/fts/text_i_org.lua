local M = {}

local ls = require("luasnip")
-- local f = ls.function_node
local t = ls.text_node
local i = ls.insert_node
-- local c = ls.choice_node
local s = ls.snippet
local fmta = require("luasnip.extras.fmt").fmta


-- local utils = require("luasnip-latex-snippets.util.utils")
-- local pipe = utils.pipe

function M.retrieve(not_math)

  return {

  s({trig = "ita", name = "italic"}, fmta("/<>/", {i(1)})),
  s({trig = "bo", name = "bold"}, fmta("*<>*", {i(1)})),


  -- Environment callouts
  s({trig = "def", name = "definition"}, {t({"\\begin{definition}"}), i(1), t("\\end{definition}"), t("")}),
  s({trig = "note", name = "note"}, {t({"\\begin{note}"}), i(1), t("\\end{note}"), t("")}),
  s({trig = "ques", name = "question"}, {t({"\\begin{question}"}), i(1), t("\\end{question}"), t("")}),


  }

end

return M
