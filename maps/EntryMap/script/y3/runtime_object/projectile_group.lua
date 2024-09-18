--- File Name : projectile_group.lua
--- Created By : duli
--- Description: 投射物组

local setmetatable = setmetatable
local ipairs = ipairs

---@class projectile_group
local projectile_group = {}
projectile_group.__index = projectile_group
y3.projectile_group = projectile_group


function projectile_group.create_lua_projectile_group_from_py(py_projectile_group)
    local new = {}
    local py = py_obj.new(py_projectile_group)
    new.base = py
    setmetatable(new, projectile_group)
    return new
end

---@param point point 点
---@param shape shape 筛选范围
---@param order_type string 筛选规则
---筛选范围内的所有投射物
function projectile_group.get_all_projectile_in_shapes(point,shape,order_type)
    local py_projectile_group = game_api.get_all_items_in_shapes(point.base(),shape,order_type)
    return projectile_group.create_lua_projectile_group_from_py(py_projectile_group)
end

---@param tag string 点
---获取拥有指定标签的投射物
function projectile_group.get_all_projectiles_with_tag(tag)
    local py_projectile_group = game_api.get_all_projectiles_with_tag(tag)
    return projectile_group.create_lua_projectile_group_from_py(py_projectile_group)
end

---遍历投射物组中投射物做动作
function projectile_group:pick()
    local lua_table ={}
    for i = 0, python_len(self.base())-1 do
        local iter_item = python_index(self.base(),i)
        table.insert(lua_table,y3.projectile.get_lua_projectile_from_py(iter_item))
    end
    return lua_table
end

---