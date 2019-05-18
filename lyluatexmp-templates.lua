local err, warn, info, log = luatexbase.provides_module({
    name               = "lyluaxmp-templates",
    version            = '0.1',
    date               = "2019/05/11",
    description        = "Lua helper module for lyluaxmp. Dealing with templates",
    author             = "Urs Liska",
    copyright          = "2019- Urs Liska",
    license            = "GPL 3",
})

local templates = {}

function templates.get(templates, key, options)
--[[
    Retrieve (and replace) a single template from a templates table.
    - templates
      table with stored templates
    - key
      key by which the template is retrieved
    - options (optional table)
      If 'options' is a table then the data is used to replace the <<<key>>>
      keys from the tmplate, otherwise the template is returned as-is.
--]]
    template = templates[template] or ''
    if options then
        return templates.replace(template, options)
    else
        return template
    end
end


function templates.replace(template, options)
--[[
    Replace all occurences of options from a template. A template
    is a string with arbitrary replacement templates enclosed by
    <<< >>>. Note that the keys must not include hyphens or other
    special
--]]
    for k, v in pairs(options) do
        template = template:gsub('<<<'..k:gsub('%-', '%-')..'>>>', v)
    end
    return template
end


function templates.wrap_macro(macro, value)
--[[
    If value is not empty return it wrapped in a macro, or an empty string.
    'macro' is a macro name without the leading backslash:
    'mymacro', 'myvalue' will return \mymacro{myvalue}
--]]
    if value and value ~= '' then
        return string.format([[\%s{%s}]], macro, value)
    else
        return ''
    end
end

function templates.wrap_optional_args(value)
--[[
    If value is not empty return value wrapped in square brackets, to be used
    as an optional argument
--]]
    if value and value ~= '' then return '['..value..']' else return '' end
end


return templates
