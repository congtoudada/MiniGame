--- File Name : unit_group.lua
--- Created By : duli
--- Description: 单位组

local setmetatable = setmetatable
local ipairs = ipairs

---@class unit_group
local unit_group = {}
unit_group.__index = unit_group
y3.unit_group = unit_group
local UnitGp = setmetatable({}, { __mode = 'kv' })

function unit_group.create_lua_unit_group_from_py(py_unit_group)
    local id = py_id(py_unit_group)
    if not UnitGp[id] then
        local new = {}
        local py = py_obj.new(py_unit_group)
        new.base = py
        setmetatable(new, unit_group)
        UnitGp[id] = new
    end
    return UnitGp[id]
end

--遍历单位组中单位做动作
function unit_group:pick()
    local lua_table = {}
    for i = 0, python_len(self.base()) - 1 do
        local iter_unit = python_index(self.base(), i)
        table.insert(lua_table, y3.unit.get_lua_unit_from_py(iter_unit))
    end
    return lua_table
end

--根据单位组选中单位
function unit_group:select_unit_by_unit_group()
    game_api.set_unit_group_selected(self.base())
end

---@param unit unit 单位
--添加单位
function unit_group:add_unit(unit)
    game_api.add_unit_to_group(unit.base(), self.base())
end

---@param unit unit 单位
--移除单位
function unit_group:remove_unit(unit)
    game_api.remove_unit_in_group(self.base(), unit.base())
end

---@param unit_id integer 单位类型id
--移除单位类型
function unit_group:remove_unit_type(unit_id)
    game_api.remove_unit_in_group_by_key(self.base(), unit_id)
end

---@return unit_group unit_group  随机整数个单位
--单位组中随机整数个单位
function unit_group:integer_random_units_from_unit_group(count)
    local py_unit_group = game_api.get_random_n_unit_in_group(self.base(), count)
    return unit_group.create_lua_unit_group_from_py(py_unit_group)
end

---@return integer unit_group_num 单位数量
--获取单位组中单位数量
function unit_group:number_of_units_in_unit_group()
    return game_api.get_unit_group_num(self.base())
end

---@return integer num_of_unit 单位类型的数量
--单位组中单位类型的数量
function unit_group:get_number_of_units_of_specified_type_in_unit_group(unit_id)
    return game_api.get_num_of_unit_key_in_group(self.base(), unit_id)
end

---@return unit unit 单位组内第一个单位
--获取单位组内第一个单位
function unit_group:get_the_first_unit_in_a_unit_group()
    local py_unit = game_api.get_first_unit_in_group(self.base())
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return unit unit 单位组中随机一个单位
--获取单位组中随机一个单位
function unit_group:get_random_unit_from_unit_group()
    local py_unit = game_api.get_random_unit_in_unit_group(self.base())
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return unit unit 单位组中随机一个单位
--获取单位组内最后一个单位
function unit_group:get_last_unit_in_unit_group()
    local py_unit = game_api.get_last_unit_in_group(self.base())
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param state string 状态名
---@return integer
--单位组中某个状态的单位数量
function unit_group:get_number_of_units_in_specified_state_in_unit_group(state)
    return game_api.get_state_unit_num_in_group(self.base(), state)
end

---@param point point 点
---@param shape area 范围选择
---@param owner_player player 拥有玩家
---@param visible_player player 可见玩家
---@param invisible_player player 不可见玩家
---@param not_in_unit_group unit_group 单位组
---@param has_tag string 拥有标签
---@param not_has_tag string 不拥有便签
---@param unit_name integer 单位类型id
---@param not_unit unit 单位
---@param unit_type string 单位分类
---@param in_state integer 状态
---@param not_in_state integer 不具有状态
---@param is_including_dead boolean 包含死亡单位
---@param max_count integer 数量上限
---@param filtering_rules integer 筛选规则
---@return unit_group unit_group 范围内的所有单位
---筛选范围内的所有单位
function unit_group.filter_unit_in_area(point, shape, owner_player, visible_player, invisible_player, not_in_unit_group,
                                        has_tag,
                                        not_has_tag, unit_name, not_unit, unit_type, in_state, not_in_state,
                                        is_including_dead, max_count, filtering_rules)
    local py_unit_group = game_api.filter_unit_id_list_in_area_v2(point.base(), shape,
        owner_player and owner_player.base() or nil, visible_player and visible_player.base() or nil,
        invisible_player and invisible_player.base() or nil, not_in_unit_group and not_in_unit_group.base() or nil,
        has_tag, not_has_tag, unit_name, not_unit, unit_type, in_state,
        not_in_state, is_including_dead, max_count, filtering_rules)

    return unit_group.create_lua_unit_group_from_py(py_unit_group)
end

---@param unit_id integer 单位类型id
---@return unit_group unit_group 单位组
--指定单位类型的单位
function unit_group.unit_of_a_specified_unit_type(unit_id)
    local py_unit_group = game_api.get_units_by_key(unit_id)
    return unit_group.create_lua_unit_group_from_py(py_unit_group)
end
