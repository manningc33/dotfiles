local augend = require("dial.augend")

local function cycle(elements, word)
  return augend.constant.new({ elements = elements, word = word ~= false, cyclic = true })
end

local default = {
  augend.integer.alias.decimal,
  augend.integer.alias.decimal_int,
  augend.integer.alias.hex,
  augend.integer.alias.octal,
  augend.integer.alias.binary,
  augend.date.alias["%m/%d/%Y"],
  augend.date.alias["%H:%M"],
  augend.date.alias["%H:%M:%S"],
  cycle({ "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth" }, false),
  cycle({ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" }),
  cycle({ "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" }),
  cycle({
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  }),
  cycle({
    "january",
    "february",
    "march",
    "april",
    "may",
    "june",
    "july",
    "august",
    "september",
    "october",
    "november",
    "december",
  }),
  cycle({ "True", "False" }),
  augend.constant.alias.bool,
  cycle({ "&&", "||" }, false),
}

-- Each filetype group also gets the whole default group.
local function with_default(augends)
  return vim.list_extend(augends, default)
end

require("dial.config").augends:register_group({
  default = default,
  markdown = with_default({ cycle({ "[ ]", "[x]" }, false), augend.misc.alias.markdown_header }),
  json = with_default({ augend.semver.alias.semver }),
  lua = with_default({ cycle({ "and", "or" }) }),
  python = with_default({ cycle({ "and", "or" }) }),
})

vim.g.dials_by_ft = { markdown = "markdown", json = "json", lua = "lua", python = "python" }
