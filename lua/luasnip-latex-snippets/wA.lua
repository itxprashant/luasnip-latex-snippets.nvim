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
  ls.parser.parse_snippet(
    { trig = "fm", name = "Inline Math" },
    "\\( ${1:${TM_SELECTED_TEXT}} \\)$0"
  ),
  ls.parser.parse_snippet(
    { trig = "dm", name = "Block Math" },
    "\\[\n\t${1:${TM_SELECTED_TEXT}}\n\\] $0"
  ),
  ls.parser.parse_snippet(
    { trig = "dgm", name = "Block Math $" },
    "$$\n\t${1:${TM_SELECTED_TEXT}}\n$$ $0"
  ),

  ls.parser.parse_snippet(
    { trig = "temp1", name = "Template 1" },
    "\\documentclass[a4paper]{report}\n\\usepackage{import}\n\\import{/home/prashantt492/my_notes/}{header.tex}\n\n\\begin{document}\n$0\n\n\\end{document}"
  ),
  ls.parser.parse_snippet(
    { trig = "temp2", name = "Template 2" },
    "\\documentclass{standalone}\n\\usepackage{import}\n\\import{/home/prashantt492/my_notes/}{header_minimal.tex}\n\n\\begin{document}\n$0\n\\end{document}"
  ),
  ls.parser.parse_snippet(
    { trig = "temp3", name = "Template 3" },
    "\\documentclass[a4paper]{report}\n\\usepackage{import}\n\\import{/sdcard/my_notes/}{header.tex}\n\n\\begin{document}\n$0\n\n\\end{document}"
  ),
  ls.parser.parse_snippet(
    { trig = "table1", name = "Table 1" },
    "\\begin{center}\n\\begin{tabular}{${1:|c|c|}}\n\\hline\n$2 \\\\ \n\\hline\n$3\n\n\\hline\n\\end{tabular}\n\\end{center}"
  ),
  s({trig = "mkc", name = "Makecell"}, fmta("\\makecell{<>}", {i(1)})),
  }
end

return M
