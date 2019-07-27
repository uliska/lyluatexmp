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
}

-------------------------------------------------------
-- Helper functions

local function _env_alignment()
    local macros = {
        left = 'raggedright',
        center = 'centering',
        right = 'raggedleft'
    }
    return function (alignment)
        return '\\' .. macros[alignment]
    end
end

-- Return the macro used for aligning the content of an environment
local env_alignment = _env_alignment()

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

-----------------------------------
-- File based music example

local function lyfile_musicexample(self, filename, options)
--[[
    Music example based on a LilyPond file.
    TODO:
    - add a \captionsetup
    - add a 'within' option for the numbering (and more provided by 'caption'?)
    - make sure missing/failed examples are reported properly (incl. colors)
--]]

    local function float()
        local non_float, caption_suffix = '', ''
        if not opts.float then
          non_float, caption_suffix = 'nf', 'of{lymusxmp}'
        end
        return non_float, caption_suffix
    end

    -- TODO: Understand how local options work together here. Do they even
    -- *have* to be merged? Or isn't that already done through validation?
    -- Can that be made to work?
    local opts = lua_options.merge_options(
        opts.options, options
    )
    local non_float, caption_suffix = float()
    return self:apply_template{
        alignment = env_alignment(opts.align),
        nonfloat = non_float,
        filename = filename,
        caption = self:wrap_macro('caption'..caption_suffix, opts.caption),
        startlabel = self:wrap_macro('label', opts.startlabel),
        label = self:wrap_macro('label', opts.label),
        lyluatex = self:wrap_optional_arg(opts.lyluatex),
        placement = self:wrap_optional_arg(opts.placement),
    }
end

EXAMPLES:add_formatters('General', {
    lyfilemusicexample = {
        comment = "Music example created from a LilyPond file",
        func = lyfile_musicexample,
        template = [[
\begin{lymusxmp<<<nonfloat>>>}<<<placement>>>
<<<alignment>>>
<<<startlabel>>>
\lilypondfile<<<lyluatex>>>{<<<filename>>>}
<<<caption>>><<<label>>>
\end{lymusxmp<<<nonfloat>>>}
]],
    },
})

return EXAMPLES
