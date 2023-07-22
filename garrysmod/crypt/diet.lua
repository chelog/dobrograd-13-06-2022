local string = string
local math = math
local table = table
local require = require
local print = print
local sub = string.sub
local gmatch = string.gmatch

-- support modules
require "llex"
require "lparser"
require "optlex"
require "optparser"

local option = {}                       -- program options

local CONFIG = [[
  --opt-comments --opt-whitespace --opt-emptylines
  --opt-eols --opt-strings --opt-numbers
  --opt-locals --opt-entropy
]]

local OPTION = [[
--opt-comments,'remove comments and block comments'
--opt-whitespace,'remove whitespace excluding EOLs'
--opt-emptylines,'remove empty lines'
--opt-eols,'all above, plus remove unnecessary EOLs'
--opt-strings,'optimize strings and long strings'
--opt-numbers,'optimize numbers'
--opt-locals,'optimize local variable names'
--opt-entropy,'tries to reduce symbol entropy of locals'
]]

local MSG_OPTIONS = ""
do
  local WIDTH = 24
  local o = {}
  for op, desc in gmatch(OPTION, "%s*([^,]+),'([^']+)'") do
    local msg = "  "..op
    msg = msg..string.rep(" ", WIDTH - #msg)..desc.."\n"
    MSG_OPTIONS = MSG_OPTIONS..msg
    o[op] = true
    o["--no"..sub(op, 3)] = true
  end
  OPTION = o  -- replace OPTION with lookup table
end

local function set_options(CONFIG)
  for op in gmatch(CONFIG, "(%-%-%S+)") do
    if sub(op, 3, 4) == "no" and OPTION["--"..sub(op, 5)] then
      option[sub(op, 5)] = false
    else
      option[sub(op, 3)] = true
    end
  end
end

------------------------------------------------------------------------
-- read source code from file
------------------------------------------------------------------------

local function load_file(fname)
  print(fname)
  print(io.open(fname))
  return io.open(fname):read('*all')
end

------------------------------------------------------------------------
-- save source code to file
------------------------------------------------------------------------

local function save_file(fname, dat)
  -- file.Write(fname, dat)
end

------------------------------------------------------------------------
-- process source file(s), write output and reports some statistics
------------------------------------------------------------------------

local function process(content)
  local function print(...) end
  --------------------------------------------------------------------
  -- load file and process source input into tokens
  --------------------------------------------------------------------
  llex.init(content)
  llex.llex()
  local toklist, seminfolist, toklnlist
    = llex.tok, llex.seminfo, llex.tokln
  --------------------------------------------------------------------
  -- do parser optimization here
  --------------------------------------------------------------------
  if option["opt-locals"] then
    optparser.print = print  -- hack
    lparser.init(toklist, seminfolist, toklnlist)
    local globalinfo, localinfo = lparser.parser()
    optparser.optimize(option, toklist, seminfolist, globalinfo, localinfo)
  end
  --------------------------------------------------------------------
  -- do lexer optimization here, save output file
  --------------------------------------------------------------------
  optlex.print = print  -- hack
  toklist, seminfolist, toklnlist
    = optlex.optimize(option, toklist, seminfolist, toklnlist)
  local dat = table.concat(seminfolist)
  -- depending on options selected, embedded EOLs in long strings and
  -- long comments may not have been translated to \n, tack a warning
  if string.find(dat, "\r\n", 1, 1) or
     string.find(dat, "\n\r", 1, 1) then
    optlex.warn.mixedeol = true
  end
  -- save optimized source stream to output file
  -- save_file(destfl, dat)
  return dat
end

set_options(CONFIG)

return process
