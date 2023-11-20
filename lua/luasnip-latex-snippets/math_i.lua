local M = {}

local ls = require("luasnip")
local f = ls.function_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta


local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe

function M.retrieve(is_math)
  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, { wordTrig = false, condition = pipe({ is_math }), show_condition = is_math,}) --[[@as function]]
  local s = ls.extend_decorator.apply(ls.snippet, { condition = pipe({ is_math }), show_condition = is_math, wordTrig = false }) --[[@as function]]


  return {

  s({trig = "dsp", name = "display-style"}, t("\\displaystyle ")),
  s({trig = "stk", name = "substack"}, fmta("\\substack{<> \\\\  <>}", {i(1), i(2)})),

  s({ trig = "cases", name = "cases" }, fmta("\\begin{cases}\n <> \\\\ \n\\end{cases}\n", { i(1) })),

  -- Calculus -------------------------------------------------------------------------------------------------------------

  s({ trig = "dif", name = "differentiation" }, fmta("\\frac{\\mathrm{d} <>}{\\mathrm{d} <>}<>", { i(1), i(2), i(3) })),
  s({ trig = "dif_?([0-9])", name = "higher differentiation", regTrig = true }, fmta("\\frac{\\mathrm{d}^{<>} <>}{\\mathrm{d} <>^{<>}}<>",
    { f(function(_, snip) return snip.captures[1] end), i(1), i(2), f(function(_, snip) return snip.captures[1] end), i(3), })),

  s({ trig = "par", name = "partial differentiation" }, fmta("\\frac{\\partial <>}{\\partial <>}<>", { i(1), i(2), i(3) })),
  s({ trig = "par_?([0-9])", name = "higher partial differentiation", regTrig = true }, fmta("\\frac{\\partial^{<>} <>}{\\partial <>^{<>}}<>", {
      f(function(_, snip) return snip.captures[1] end), i(1), i(2), f(function(_, snip) return snip.captures[1] end), i(3), })),

  s({ trig = "\\?int", name = "int", regTrig = true },c(1,
    { fmta("\\int_{<>}^{<>} <> \\ \\mathrm{d}<> <>", { i(1), i(2), i(3), i(4), i(5) }),
      fmta("\\int_{<>}^{<>} <> \\ <>", { i(1), i(2), i(3), i(4) }),})),

  s({ trig = "\\?sum", name = "sum", regTrig = true }, fmta("\\sum_{<>}^{<>} <>", { i(1), i(2, "\\infty"), i(3) })),
  s({ trig = "\\?prod", name = "prod", regTrig = true }, fmta("\\prod_{<>}^{<>} <>", { i(1), i(2), i(3) })),

  s({ trig = "\\?lim", name = "limit", regTrig = true }, fmta("\\lim_{<>} ", { i(1) })),
  s({ trig = "\\?limsup", name = "limit-super", regTrig = true }, fmta("\\limsup_{<> \\to <>} ", { i(1), i(2, "\\infty") })),

  ls.parser.parse_snippet({ trig = "taylor", name = "taylor" }, "\\sum_{${1:k}=${2:0}}^{${3:\\infty}} ${4:c_$1} (x-a)^$1 $0"),

  -- Matrices -----------------------------------------------------------------------------------------------------------
  s({ trig = "pmat", name = "pmat" }, fmta("\\begin{pmatrix} \n<> \n \\end{pmatrix}", {i(1)})),
  s({ trig = "bmat", name = "bmat" }, fmta("\\begin{bmatrix} \n<> \n \\end{bmatrix}", {i(1)})),
  s({ trig = "vmat", name = "vmat" }, fmta("\\begin{vmatrix} \n<> \n \\end{vmatrix}", {i(1)})),

  s({ trig = "idm_?2", name = "identity-matrix 2x2", regTrig = true }, fmta("\\begin{bmatrix} \n 1 & 0 \\\\ \n 0 & 1 \\\\ \n \\end{bmatrix}", {})),
  s({ trig = "idm_?3", name = "identity-matrix 3x3", regTrig = true }, fmta("\\begin{bmatrix} \n 1 & 0 & 0 \\\\ \n 0 & 1 & 0 \\\\ \n 0 & 0 & 1 \\\\ \n \\end{bmatrix}", {})),



  -- Enlarged Brackets ---------------------------------------------------------------------------------------------------
  parse_snippet({ trig = "rlr", name = "left( right)" }, "\\left( ${1:${TM_SELECTED_TEXT}} \\right) $0"),
  parse_snippet({ trig = "lr|", name = "left| right|" }, "\\left| ${1:${TM_SELECTED_TEXT}} \\right| $0"),
  parse_snippet({ trig = "clr", name = "left{ right}" }, "\\left\\{ ${1:${TM_SELECTED_TEXT}} \\right\\\\} $0"),
  parse_snippet({ trig = "slr", name = "left[ right]" }, "\\left[ ${1:${TM_SELECTED_TEXT}} \\right] $0"),
  parse_snippet({ trig = "lra", name = "leftangle rightangle" }, "\\left< ${1:${TM_SELECTED_TEXT}} \\right>$0"),

  }
end

return M
