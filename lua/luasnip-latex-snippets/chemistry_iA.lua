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
    condition = pipe({ is_math, no_backslash }),
  }

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, decorator) --[[@as function]]
  local s = ls.extend_decorator.apply(ls.snippet, decorator) --[[@as function]]

return {


-- Environments
s({trig = "ce", name = "Chemical Equation"}, fmta( "\\ce{<>}", { i(1) } ) ),
s({trig = "cre", name = "Chemical Reaction"}, fmta( "\\ce{<> ->>[<>][<>] <>}", { i(1), i(2), i(3), i(4) } ) ),
s({trig = "eqa", name = "Equilirium arrow"}, t("<=> ") ),
s({trig = "R'", name = "r dash"}, t("\\text{R'}")),

-- Organic Chemistry
s({trig = "cfig", name = "Chemical figure"}, fmta( "\\chemfig{<>}", { i(1) } ) ),
s({trig = "dqd", name = "\\quad"}, t("$\\quad$ ") ),
s({trig = "alpc", name = "alpha carbon"}, t("\\chemabove{C}{\\alpha} ") ),
s({trig = "betc", name = "beta carbon"}, t("\\chemabove{C}{\\beta} ") ),




-- Chemfig branches
s({ trig = "[_ ]*([0-9])br", wordTrig = false, regTrig = true, name = "Chemfig Branch", priority = 500, },
 {f(function(_, snip) return string.format("(-[%s]", snip.captures[1]) end), i(1), t(")"), i(2)}, {}),

s({ trig = "[_ ]*([0-9])bb", wordTrig = false, regTrig = true, name = "Blank Bond", priority = 500, },
 {f(function(_, snip) return string.format("(-[%s,,,,opacity=0]", snip.captures[1]) end), i(1), t(")"), i(2)}, {}),

s({ trig = ",,d", name = "Dotted bond" }, t(",,,,thick,dotted")),
s({ trig = ",,b", name = "Blank bond" }, t(",,,,opacity=0")),

s({ trig = " ?([A-Za-z0-9_]*)cat", wordTrig = false, regTrig = true, name = "cation", priority = 300, },
  f(function(_, snip) return string.format("\\chemabove{%s}{\\oplus}", snip.captures[1]) end, {})),

s({ trig = " ?([A-Za-z0-9_]*)ani", wordTrig = false, regTrig = true, name = "anion", priority = 300, },
  f(function(_, snip) return string.format("\\chemabove{%s}{\\ominus}", snip.captures[1]) end, {})),

s({ trig = "([A-Z][a-z]?)lpr", wordTrig = false, regTrig = true, name = "lone-pair", priority = 300, },
  f(function(_, snip) return string.format("\\charge{90=\\:}{%s}", snip.captures[1]) end, {})),

s({ trig = "([A-Z][a-z]?)rad", wordTrig = false, regTrig = true, name = "radical", priority = 300, },
  f(function(_, snip) return string.format("\\charge{90=\\.}{%s}", snip.captures[1]) end, {})),







  -- Spacing in chemfig
s({trig = "(\\chemfig%b{}) *cf", wordTrig = false, regTrig = true, name = "spacing in chemfig", priority = 1000},
  f(function(_, snip) return string.format("%s $\\quad$ cf", snip.captures[1]) end, {})),
s({trig = "(\\chemfig%b{}) *->", wordTrig = false, regTrig = true, name = "spacing in chemfig", priority = 1000},
  f(function(_, snip) return string.format("%s $\\quad$ ->", snip.captures[1]) end, {})),
s({trig = "(\\chemfig%b{}) *%+", wordTrig = false, regTrig = true, name = "spacing in chemfig", priority = 1000},
  f(function(_, snip) return string.format("%s $\\quad$ +", snip.captures[1]) end, {})),
s({trig = "(\\chemname%b{}%b{}) *cf", wordTrig = false, regTrig = true, name = "spacing in chemfig", priority = 1000},
  f(function(_, snip) return string.format("%s $\\quad$ cf", snip.captures[1]) end, {})),
s({trig = "(\\chemname%b{}%b{}) *->", wordTrig = false, regTrig = true, name = "spacing in chemfig", priority = 1000},
  f(function(_, snip) return string.format("%s $\\quad$ ->", snip.captures[1]) end, {})),
s({trig = "(\\chemname%b{}%b{}) *%+", wordTrig = false, regTrig = true, name = "spacing in chemfig", priority = 1000},
  f(function(_, snip) return string.format("%s $\\quad$ +", snip.captures[1]) end, {})),

s({trig = "(%->) *cf", wordTrig = false, regTrig = true, name = "spacing in chemfig", priority = 1000},
  f(function(_, snip) return string.format("%s $\\quad$ cf", snip.captures[1]) end, {})),
s({trig = "(%->%b[]) *cf", wordTrig = false, regTrig = true, name = "spacing in chemfig", priority = 1000},
  f(function(_, snip) return string.format("%s $\\quad$ cf", snip.captures[1]) end, {})),
s({trig = "(%->%b[]%b[]) *cf", wordTrig = false, regTrig = true, name = "spacing in chemfig", priority = 1000},
  f(function(_, snip) return string.format("%s $\\quad$ cf", snip.captures[1]) end, {})),

s({trig = "+ *cf", wordTrig = false, regTrig = true, name = "spacing in chemfig", priority = 1000},
  t("+ $\\quad$ cf")),




-- name
s({trig = "(\\chemfig%b{})name", wordTrig = false, regTrig = true, name = "double bond oxygen at ..", priority = 500},
  {f(function(_, snip) return string.format("\\chemname{%s}{", snip.captures[1]) end, {}), i(1), t("}"), i(2)}),



 -- Quick groups
s({trig = "[_ ]*([0-9])do", wordTrig = false, regTrig = true, name = "double bond oxygen at ..", priority = 500},
  f(function(_, snip) return string.format("(=[%s]O)", snip.captures[1]) end, {})),

s({trig = "[_ ]*([0-9])hh", wordTrig = false, regTrig = true, name = "hydrogen at ..", priority = 500},
  f(function(_, snip) return string.format("(-[%s]H)", snip.captures[1]) end, {})),

s({trig = "[_ ]*([0-9])oh", wordTrig = false, regTrig = true, name = "alcohol at ..", priority = 500},
  f(function(_, snip) return string.format("(-[%s]OH)", snip.captures[1]) end, {})),

s({trig = "[_ ]*([0-9])met", wordTrig = false, regTrig = true, name = "methyl at ..", priority = 500},
  f(function(_, snip) return string.format("(-[%s]CH_3)", snip.captures[1]) end, {})),

s({trig = "[_ ]*([0-9])eth", wordTrig = false, regTrig = true, name = "ethyl at ..", priority = 500},
  f(function(_, snip) return string.format("(-[%s]C_2H_5)", snip.captures[1]) end, {})),

s({trig = "[_ ]*([0-9])alk", wordTrig = false, regTrig = true, name = "alkyl at ..", priority = 500},
  f(function(_, snip) return string.format("(-[%s]R)", snip.captures[1]) end, {})),

s({trig = "[_ ]*([0-9])akl", wordTrig = false, regTrig = true, name = "alkyl at ..", priority = 500},
  f(function(_, snip) return string.format("(-[%s]\\text{R'})", snip.captures[1]) end, {})),

s({trig = "[_ ]*1co7", wordTrig = false, regTrig = true, name = "carbonyl compound", priority = 1000}, {t("-[1]C(=[2]O)-[7]"), i(1)}),

with_priority(ls.parser.parse_snippet({ trig = "1ene", name = "ethene" }, "C(-[3])(-[5])=C(-[1])(-[7])$0"), 20),


}

end

return M
