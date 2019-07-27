local err, warn, info, log = luatexbase.provides_module({
    name               = "lyluatexmp-formatters",
    version            = '0.1',
    date               = "2019/05/11",
    description        = "Lua formatters for the lyluatexmp package.",
    author             = "Urs Liska",
    copyright          = "2019- Urs Liska",
    license            = "GPL 3",
})

local lib = require('luaoptions-lib')
local opts = lua_options.client('lyluatexmp')

EXAMPLES = lua_formatters:new_client{
    name = 'lyluatexmp',
    namespace = {},
    prefix = 'lymusxmp',
}

function EXAMPLES:env_align(alignment)
    local macros = {
        left = 'raggedright',
        center = 'centering',
        right = 'raggedleft'
    }
    return '\\' .. macros[alignment]
end

function EXAMPLES:set_cref_names()
--[[
    This function is called when -- while loading lyluatexmp --
    it is detected that 'cleveref' has already been loaded.
    Look up the crefname and Crefname options and use them.
    If the option is not formatted properly (both crefname and
    Crefname must be formatted as singular/plural names separated
    by a "|" pipe smybol) the English fallback values are chosen
--]]
    local crefname, Crefname = opts.crefname, opts.Crefname
    local cref_sing, cref_plur = crefname:match('(.-)%s-|%s-([^%s]*)')
    local Cref_sing, Cref_plur = Crefname:match('(.-)%s-|%s-([^%s]*)')
    if not (cref_sing and Cref_sing) then
        err(string.format([[
Malformatted option 'crefname' or 'Crefname'
(expected: two elements separated by "|").
crefname={%s},
Crefname={%s}]],
        crefname, Crefname))
    end
    cref_plur = cref_plur or cref_sing
    Cref_plur = Cref_plur or Cref_sing
    lua_formatters:write_latex(
        lua_formatters:wrap_macro('crefname', 'lymusxmp', cref_sing, cref_plur))

    lua_formatters:write_latex(
        lua_formatters:wrap_macro('Crefname', 'lymusxmp', Cref_sing, Cref_plur))
end

if lib.package_loaded('cleveref') then
    EXAMPLES:set_cref_names()
end

return EXAMPLES
