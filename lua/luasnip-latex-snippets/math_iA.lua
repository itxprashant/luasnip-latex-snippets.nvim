local M = {}

local ls = require("luasnip")
local f = ls.function_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta
local with_priority = require("luasnip-latex-snippets.util.utils").with_priority

function M.retrieve(is_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe, no_backslash = utils.pipe, utils.no_backslash

  local decorator = {
    wordTrig = false,
    condition = pipe({ is_math }),
  }

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, decorator) --[[@as function]]
  local s = ls.extend_decorator.apply(ls.snippet, decorator) --[[@as function]]

return {
  -- auto subscript
  s({trig = "([a-zA-Z]+)([0-9])", regTrig = true, wordTrig = false, name = "Auto subscript"},
    fmta("<>_<>", {f(function(_, snip) return snip.captures[1] end), f(function(_, snip) return snip.captures[2] end)})),

  -- fraction
  s({ trig = "([^/= ]+)/", wordTrig = false, regTrig = true, name = "fraction", priority = 500},
    fmta("\\frac{<>}{<>}", {f(function(_, snip) return snip.captures[1] end, {}), i(1), })),

  -- Sequences
  s({ trig = "([^ ]+)([CP])_?([^ ]+);", wordTrig = true, regTrig = true, name = "permutation/combination", priority = 500, },
    f(function(_, snip) return string.format("{}^{%s}%s_{%s} ", snip.captures[1], snip.captures[2], snip.captures[3]) end, {})),

  -- postfix snippets
  s({ trig = "(%a)bar", wordTrig = false, regTrig = true, name = "bar", priority = 100 },
    f(function(_, snip) return string.format("\\overline{%s}", snip.captures[1]) end, {})),

  s({ trig = "([A-Za-ce-z\\]+)(d+)ot", wordTrig = false, regTrig = true, name = "dot", priority = 100, },
    f(function(_, snip) return string.format("\\%sot{%s}", snip.captures[2], snip.captures[1]) end, {})),

  s(
    {
      trig = "dif_?([0-9]?)([a-zA-Z])([a-zA-Z])",
      wordTrig = false,
      regTrig = true,
      name = "quick differentiation",
      priority = 500,
    },
    f(function(_, snip)
      if snip.captures[1] == "" then
        return string.format(
          "\\frac{\\mathrm{d}%s}{\\mathrm{d}%s}",
          snip.captures[2],
          snip.captures[3]
        )
      else
        return string.format(
          "\\frac{\\mathrm{d}^{%s}%s}{\\mathrm{d}%s^{%s}}",
          snip.captures[1],
          snip.captures[2],
          snip.captures[3],
          snip.captures[1]
        )
      end
    end, {})
  ),

  s(
    {
      trig = "par_?([0-9]?)([a-zA-Z])([a-zA-Z])",
      wordTrig = false,
      regTrig = true,
      name = "quick differentiation",
      priority = 500,
    },
    f(function(_, snip)
      if snip.captures[2] == "t" and snip.captures[3] == "i" then
        return string.format("\\partial")
      elseif snip.captures[1] == "" then
        return string.format(
          "\\frac{\\partial %s}{\\partial %s}",
          snip.captures[2],
          snip.captures[3]
        )
      else
        return string.format(
          "\\frac{\\partial^{%s} %s}{\\partial %s^{%s}}",
          snip.captures[1],
          snip.captures[2],
          snip.captures[3],
          snip.captures[1]
        )
      end
    end, {})
  ),

  s(
    {
      trig = "\\?sum([^ ]*)to_?([^ ]*) ",
      wordTrig = false,
      regTrig = true,
      name = "sum",
      priority = 1000,
    },
    f(function(_, snip)
      return string.format("\\sum_{%s}^{%s} ", snip.captures[1], snip.captures[2])
    end, {})
  ),

  s(
    {
      trig = "\\?int_?([^ ]*)to_?([^ ]*) ",
      wordTrig = false,
      regTrig = true,
      name = "definite integral",
      priority = 1000,
    },
    f(function(_, snip)
      return string.format("\\int_{%s}^{%s} ", snip.captures[1], snip.captures[2])
    end, {})
  ),

  -- Vector postfix
  s({ trig = "vec", name = "vector prefix", priority = 100 }, fmta("\\vec{<>}<>", { i(1), i(2) })),
  s({
    trig = "([A-Z]?[A-Za-z])(,%.)",
    wordTrig = false,
    regTrig = true,
    name = "vector postfix",
    priority = 2000,
  }, {
    f(function(_, snip)
      return string.format("\\vec{%s}", snip.captures[1])
    end, {}),
  }),
  s({
    trig = "(\\[^ {}]+)(,%.)",
    wordTrig = false,
    regTrig = true,
    name = "vector postfix greek",
    priority = 3000,
  }, {
    f(function(_, snip)
      return string.format("\\vec{%s}", snip.captures[1])
    end, {}),
  }),

  s(
    { trig = "hat", name = "unit vector prefix", priority = 100 },
    fmta("\\hat{<>}<>", { i(1), i(2) })
  ),
  s({
    trig = "([A-Z]?[A-Za-z])(hat)",
    wordTrig = false,
    regTrig = true,
    name = "unit vector postfix",
    priority = 2000,
  }, {
    f(function(_, snip)
      return string.format("\\hat{%s}", snip.captures[1])
    end, {}),
  }),

  s({ trig = "(\\[^ {}]+)(hat)", wordTrig = false, regTrig = true, name = "unit vector postfix greek", priority = 3000,},
    { f(function(_, snip) return string.format("\\hat{%s}", snip.captures[1]) end, {}), }),

  s({ trig = "bf", name = "boldface", priority = 100 }, fmta("\\mathbf{<>}<>", { i(1), i(2) })),

  s({ trig = "([a-zA-Z])bf", name = "boldface vector", regTrig = true, wordTrig = false, priority = 200, },
    f(function(_, snip) return string.format("\\mathbf{%s}", snip.captures[1]) end)),

  s({ trig = "rm", name = "mathrm", priority = 100 }, fmta("\\mathrm{<>}<>", { i(1), i(2) })),

  s({ trig = "([a-zA-Z])rm", name = "mathrm", regTrig = true, wordTrig = false, priority = 200 },
    f(function(_, snip) return string.format("\\mathrm{%s}", snip.captures[1]) end)),

  s({ trig = "td", name = "to the ... power ^{}" }, fmta("^{<>}", { i(1) })),
  s({ trig = "rd", name = "to the ... subscript _{}" }, fmta("_{<>}", { i(1) })),
  s({ trig = "cb", name = "Cube ^3" }, t("^3")),
  s({ trig = "sr", name = "Square ^2" }, t("^2")),
  s({ trig = "sq", name = "\\sqrt{}" }, c(1, { fmta("\\sqrt{<>}", { i(1) }), fmta("\\sqrt[<>]{<>}", { i(1), i(2) }) })),
  s({ trig = "deg", name = "Degree Symbol" }, t("^{\\circ}")),
  s({ trig = "ooo", name = "circ" }, t("\\circ")),
  s({ trig = "R0+", name = "R0+" }, t("\\mathbb{R}_0^+")),
  s({ trig = "notin", name = "not in " }, t("\\notin")),
  s({ trig = "cc", name = "subset" }, t("\\subset")),
  s({ trig = "<->", name = "leftrightarrow", priority = 200 }, t("\\leftrightarrow")),
  s({ trig = "lr=", name = "<=>" }, t("\\Leftrightarrow ")),
  s({ trig = "EE", name = "exists" }, t("\\exists ")),
  s({ trig = "AA", name = "forall" }, t("\\ \\forall \\ ")),
  s({ trig = "...", name = "ldots", priority = 100 }, t("\\ldots ")),
  s({ trig = "!>", name = "mapsto" }, t("\\mapsto ")),
  s({ trig = "iff", name = "iff" }, t("\\iff ")),
  s({ trig = "nab", name = "nabla" }, t("\\nabla ")),
  s({ trig = "<!", name = "normal" }, t("\\triangleleft ")),
  s({ trig = "tg", name = "triangle" }, t("\\triangle")),
  s({ trig = "floor", name = "floor" }, fmta("\\left\\lfloor <> \\right\\rfloor <>", { i(1), i(2) })),
  s({ trig = "mcal", name = "mathcal" }, fmta("\\mathcal{<>}<>", { i(1), i(2) })),
  s({ trig = "set", name = "set" }, fmta("\\{<>\\}", { i(1) })),
  s({ trig = "//", name = "Fraction" }, fmta("\\frac{<>}{<>}<>", { i(1), i(2), i(3) })),
  s({ trig = "\\\\\\", name = "setminus" }, t("\\setminus")),
  s({ trig = "too", name = "to" }, t("\\to ")),
  s({ trig = "ncr", name = "comb" }, fmta("{}^{<>}C_{<>}<> ", { i(1, "n"), i(2, "r"), i(3) })),
  s({ trig = "npr", name = "perm" }, fmta("{}^{<>}P_{<>}<> ", { i(1, "n"), i(2, "r"), i(3) })),
  s({ trig = "4pep", name = "coulomb's constant" }, t("\\frac{1}{4\\pi\\epsilon_0}")),
  s({ trig = "letw", name = "let omega" }, t("Let \\Omega \\subset \\C be open.")),
  s({ trig = "nnn", name = "bigcap" }, fmta("\\bigcap_{<> \\in <>} ", { i(1, "i"), i(2, "I") })),
  s({ trig = "norm", name = "norm" }, fmta("\\|<>\\|", { i(1) })),
  s({ trig = "<>", name = "hokje" }, t("\\diamond ")),
  s({ trig = "stt", name = "text subscript" }, fmta("_{\\text{<>}} ", { i(1) })),
  s({ trig = "tt", name = "text" }, fmta("\\text{<>}", { i(1) })),
  s({ trig = "xx", name = "cross" }, t("\\times ")),
  s({ trig = "**", name = "cdot", priority = 100 }, t("\\cdot ")),
  s({ trig = "cvec", name = "column vector" }, fmta("\\begin{pmatrix} <> \\\\ <> \\end{pmatrix}", {i(1), i(2)})),
  s({ trig = "ceil", name = "ceil" }, fmta("\\left\\lceil <> \\right\\rceil ", { i(1) })),
  --  s({ trig = "OO", name = "emptyset" }, t("\\O")),
  s({ trig = "RR", name = "R" }, t("\\mathbb{R}")),
  s({ trig = "QQ", name = "Q" }, t("\\mathbb{Q}")),
  s({ trig = "ZZ", name = "Z" }, t("\\mathbb{Z}")),
  s({ trig = "CC", name = "C" }, t("\\mathbb{C}")),
  s({ trig = "UU", name = "cup" }, t("\\cup ")),
  s({ trig = "NN", name = "n" }, t("\\mathbb{N}")),
  s({ trig = "II", name = "I" }, t("\\mathbb{I}")),
  s({ trig = "||", name = "mid" }, t(" \\mid ")),
  s({ trig = "Nn", name = "cap" }, t("\\cap ")),
  s({ trig = "bmat", name = "bmat" }, fmta("\\begin{bmatrix} <> \\end{bmatrix}", { i(1) })),
  s({ trig = "uuu", name = "bigcup" }, fmta("\\bigcup_{<> \\in <>} ", { i(1, "i"), i(2, "I") })),
  s({ trig = "DD", name = "D" }, t("\\mathbb{D}")),
  s({ trig = "HH", name = "H" }, t("\\mathbb{H}")),
  s({ trig = "big|", name = "begger vert line" }, t("\\biggr\\vert")),
  s({ trig = "lll", name = "l" }, t("\\ell")),
  s({ trig = "==", name = "equals" }, fmta("&= <> \\\\", { i(1) })),
  s({ trig = "!=", name = "not equals" }, t("\\neq ")),
  s({ trig = "__", name = "subscript" }, fmta("_{<>}", { i(1) })),
  s({ trig = "=>", name = "implies" }, t("\\implies")),
  s({ trig = "=<", name = "implied by" }, t("\\impliedby")),
  s({ trig = "<<", name = "<<" }, t("\\ll")),
  s({ trig = "<=", name = "leq" }, t("\\leq ")),
  s({ trig = ">=", name = "geq" }, t("\\geq ")),
  s({ trig = ">>", name = ">>" }, t("\\gg")),
  s({ trig = "<<", name = "<<" }, t("\\ll")),
  s({ trig = "compl", name = "complement" }, t("^{c}")),
  s({ trig = "invs", name = "inverse" }, t("^{-1}")),
  s({ trig = "~~", name = "~" }, t("\\approx ")),
  s({ trig = "conj", name = "conjugate" }, fmta("\\overline{<>}", { i(1) })),
  s({ trig = "prop", name = "proportional" }, t("\\propto")),
  s({ trig = "hat", name = "hat", priority = 10 }, fmta("\\hat{<>}", { i(1) })),
  s({ trig = "bar", name = "hat", priority = 10 }, fmta("\\overline{<>}", { i(1) })),
  s({ trig = "inf", name = "\\infty" }, t("\\infty")),
  s({ trig = "inn", name = "in" }, t("\\in")),
  s({ trig = "nin", name = "not in" }, t("\\notin")),
  s({ trig = "SI", name = "SI" }, fmta("\\SI{<>}{<>}", { i(1), i(2) })),

  -- postfix
  s({ trig = "\\?sin", name = "sin", regTrig = true }, t("\\sin")),
  s({ trig = "\\?cos", name = "cos", regTrig = true }, t("\\cos")),
  s({ trig = "\\?tan", name = "tan", regTrig = true }, t("\\tan")),
  s({ trig = "\\?sec", name = "sec", regTrig = true }, t("\\sec")),
  s({ trig = "\\?csc", name = "csc", regTrig = true }, t("\\csc")),
  s({ trig = "\\?cot", name = "cot", regTrig = true }, t("\\cot")),
  s({ trig = "\\?ln", name = "ln", regTrig = true }, t("\\ln")),
  s({ trig = "\\?log", name = "log", regTrig = true }, t("\\log")),
  s({ trig = "\\?exp", name = "exp", regTrig = true }, t("\\exp")),
  s({ trig = "\\?star", name = "star", regTrig = true }, t("\\star")),
  s({ trig = "\\?perp", name = "perp", regTrig = true }, t("\\perp")),
  s({ trig = "\\?int", name = "int", regTrig = true }, t("\\int")),
  s({ trig = "\\?subset", name = "subset", regTrig = true }, t("\\subset")),



  -- Greek Letters
  s(";a", t("\\alpha")),
  s(";b", t("\\beta")),
  s(";c", t("\\chi")),
  s(";d", t("\\delta")),
  s(";ep", t("\\epsilon")),
  s(";g", t("\\gamma")),
  s(";i", t("\\iota")),
  s(";k", t("\\kappa")),
  s(";l", t("\\lambda")),
  s(";m", t("\\mu")),
  s(";n", t("\\nu")),
  s(";o", t("\\omega")),
  s({trig = ";?pi", regTrig = true}, t("\\pi")),
  s(";ph", t("\\phi")),
  s(";ps", t("\\psi")),
  s(";r", t("\\rho")),
  s(";si", t("\\sigma")),
  s(";ta", t("\\tau")),
  s(";th", t("\\theta")),
  s(";z", t("\\zeta")),
  s(";et", t("\\eta")),

  s(";A", t("\\Alpha")),
  s(";B", t("\\Beta")),
  s(";C", t("\\Chi")),
  s(";D", t("\\Delta")),
  s(";Ep", t("\\Epsilon")),
  s(";G", t("\\Gamma")),
  s(";I", t("\\Iota")),
  s(";K", t("\\Kappa")),
  s(";L", t("\\Lambda")),
  s(";M", t("\\Mu")),
  s(";N", t("\\Nu")),
  s(";O", t("\\Omega")),
  s({trig = ";?Pi", regTrig = true}, t("\\Pi")),
  s(";Ph", t("\\Phi")),
  s(";Ps", t("\\Psi")),
  s(";R", t("\\Rho")),
  s(";Si", t("\\Sigma")),
  s(";Ta", t("\\Tau")),
  s(";Th", t("\\Theta")),
  s(";Z", t("\\Zeta")),
  s(";Et", t("\\Eta")),
}

end

return M
