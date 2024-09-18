---@enum(key, partial) y3.Const.PlayerAttr
local PlayerAttr = {
    ["gold"] = "official_res_1",
}

y3.util.tableMerge(y3.const.PlayerAttr or {}, PlayerAttr)
