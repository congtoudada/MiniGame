---@enum(key, partial) y3.Const.UnitAttr
local UnitAttr = {
    ["力量"] = "strength",
    ["敏捷"] = "agility",
    ["智力"] = "intelligence",
    ["主属性"] = "main",
}

y3.util.tableMerge(y3.const.UnitAttr or {}, UnitAttr)
