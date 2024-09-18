--- File Name : item_group.lua
--- Created By : duli
--- Description: 物品组

local setmetatable = setmetatable
local ipairs = ipairs

---@class item_group
local item_group = {}
item_group.__index = item_group
y3.item_group = item_group


function item_group.create_lua_item_group_from_py(py_item_group)
    local new = {}
    local py = py_obj.new(py_item_group)
    new.base = py
    setmetatable(new, item_group)
    return new
end

--遍历物品组中玩家做动作
function item_group:pick()
    local lua_table ={}
    for i = 0, python_len(self.base())-1 do
        local iter_item = python_index(self.base(),i)
        table.insert(lua_table,y3.item.get_lua_item_from_py(iter_item))
    end
    return lua_table
end

---@param point point 点
---@param shape shape 筛选范围
---@param order_type string 筛选规则
---筛选范围内的所有物品
function item_group.get_all_items_in_shapes(point,shape,order_type)
    local py_item_group = game_api.get_all_items_in_shapes(point.base(),shape,order_type)
    return item_group.create_lua_item_group_from_py(py_item_group)
end

---@param item item 物品
---添加物品到物品组
function item_group:add(item)
    game_api.api_add_item_to_group(item.base())
end

---@param item item 物品
---删除物品组中某个物品
function item_group:remove(item)
    game_api.api_remove_item_in_group(item.base())
end