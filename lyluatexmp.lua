local err, warn, info, log = luatexbase.provides_module({
    name               = "lyluaxmp",
    version            = '0.1',
    date               = "2019/05/11",
    description        = "Lua module for the lyluaxmp package.",
    author             = "Urs Liska",
    copyright          = "2019- Urs Liska",
    license            = "GPL 3",
})

local lib = require(kpse.find_file("lyluatex-lib.lua") or "lyluatex-lib.lua")
local xmp_opts = xmp_opts -- defined in lyluatexmp.sty

local lfs = require 'lfs'

local xmp = {}      -- namespace for the returned table

-- NOTE: This is completely empty so far

return xmp
