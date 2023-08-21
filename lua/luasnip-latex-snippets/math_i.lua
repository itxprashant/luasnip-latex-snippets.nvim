local M = {}

local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta


local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe

function M.retrieve(is_math)
  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    wordTrig = false,
    condition = pipe({ is_math }),
    show_condition = is_math,
  }) --[[@as function]]

  return {

  s(
    { trig = "cases", name = "cases" },
    fmta("\\begin{cases}\n <> \\\\ \n\\end{cases}\n", { i(1) })
  ),
  s(
    { trig = "dif", name = "differentiation" },
    fmta("\\frac{\\mathrm{d} <>}{\\mathrm{d} <>}<>", { i(1), i(2), i(3) })
  ),
  s(
    { trig = "dif_?([0-9])", name = "higher differentiation", regTrig = true },
    fmta("\\frac{\\mathrm{d}^{<>} <>}{\\mathrm{d} <>^{<>}}<>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(3),
    })
  ),
  s(
    { trig = "par", name = "partial differentiation" },
    fmta("\\frac{\\partial <>}{\\partial <>}<>", { i(1), i(2), i(3) })
  ),
  s(
    { trig = "par_?([0-9])", name = "higher partial differentiation", regTrig = true },
    fmta("\\frac{\\partial^{<>} <>}{\\partial <>^{<>}}<>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(3),
    })
  ),

  ls.parser.parse_snippet({ trig = "sum", name = "sum" }, "\\sum_{${1:n=1}}^{${2:\\infty}} $3"),
  s(
    { trig = "\\?int", name = "int", regTrig = true },
    c(1, {
      fmta("\\int_{<>}^{<>} <> \\ \\mathrm{d}<> <>", { i(1), i(2), i(3), i(4), i(5) }),
      fmta("\\int_{<>}^{<>} <> <>", { i(1), i(2), i(3), i(4) }),
    })
  ),
  ls.parser.parse_snippet(
    { trig = "taylor", name = "taylor" },
    "\\sum_{${1:k}=${2:0}}^{${3:\\infty}} ${4:c_$1} (x-a)^$1 $0"
  ),
  ls.parser.parse_snippet({ trig = "lim", name = "limit" }, "\\lim_{${1:n} \\to ${2:\\infty}} "),
  ls.parser.parse_snippet(
    { trig = "limsup", name = "limsup" },
    "\\limsup_{${1:n} \\to ${2:\\infty}} "
  ),
  ls.parser.parse_snippet(
    { trig = "sequence", name = "Sequence indexed by n, from m to infinity" },
    "(${1:a}_${2:n})_{${2:n}=${3:m}}^{${4:\\infty}}"
  ),
  ls.parser.parse_snippet(
    { trig = "prod", name = "product" },
    "\\prod_{${1:n=${2:1}}}^{${3:\\infty}} ${4:${TM_SELECTED_TEXT}} $0"
  ),

  -- Calculus
  ls.parser.parse_snippet(
    { trig = "part", name = "partial d/dx" },
    "\\frac{\\partial ${1:V}}{\\partial ${2:x}} $0"
  ),
  ls.parser.parse_snippet(
    { trig = "ddx", name = "d/dx" },
    "\\frac{\\mathrm{d/${1:V}}}{\\mathrm{d${2:x}}} $0"
  ),

  -- Matrices
  ls.parser.parse_snippet(
    { trig = "pmat", name = "pmat" },
    "\\begin{pmatrix} $1 \\end{pmatrix} $0"
  ),

  -- Enlarged Brackets
  ls.parser.parse_snippet(
    { trig = "rlr", name = "left( right)" },
    "\\left( ${1:${TM_SELECTED_TEXT}} \\right) $0"
  ),
  ls.parser.parse_snippet(
    { trig = "lr|", name = "left| right|" },
    "\\left| ${1:${TM_SELECTED_TEXT}} \\right| $0"
  ),
  ls.parser.parse_snippet(
    { trig = "clr", name = "left{ right}" },
    "\\left\\{ ${1:${TM_SELECTED_TEXT}} \\right\\\\} $0"
  ),
  ls.parser.parse_snippet(
    { trig = "slr", name = "left[ right]" },
    "\\left[ ${1:${TM_SELECTED_TEXT}} \\right] $0"
  ),
  ls.parser.parse_snippet(
    { trig = "lra", name = "leftangle rightangle" },
    "\\left< ${1:${TM_SELECTED_TEXT}} \\right>$0"
  ),
  ls.parser.parse_snippet(
    { trig = "lrb", name = "left\\{ right\\}" },
    "\\left\\{ ${1:${TM_SELECTED_TEXT}} \\right\\\\} $0"
  ),
  }
end

return M
