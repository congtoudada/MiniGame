--- File Name : event_manager.lua

--- Description: 事件管理

event_manager = {}

event_list = {}
---物编
event_list.unit = {}
event_list.item = {}
event_list.ability = {}
event_list.modifier = {}
event_list.projectile = {}
event_list.purchase = {}
event_list.destructible = {}

---全局逻辑
event_list.global = {}

---@class event_enum
event_enum = {
    unit = { list = event_list.unit },
    item = { list = event_list.item },
    ability = { list = event_list.ability },
    modifier = { list = event_list.modifier },
    projectile = { list = event_list.projectile },
    purchase = { list = event_list.purchase },
    destructible = { list = event_list.destructible },

    global = { list = event_list.global }
}

local function new_child(name, enum, params,dispatch)
    local new_instance = {}
    new_instance.name = name
    new_instance.enum = enum
    new_instance.params = params
    new_instance.dispatch = dispatch
    return new_instance
end

---全局事件列表初始化
local function global_event_list_init()
    -- local function global_add(name, enum, params,dispatch)
    --     table.insert(event_list.global, new_child(name, enum, params,dispatch))
    -- end
    for k, v in pairs(const.GlobalEventType) do
        event_list.global[v] = k
    end
    
    for k, v in pairs(const.AbilityEventType) do
        event_list.global[v] = k
    end
    for k, v in pairs(const.ItemEventType) do
        event_list.global[v] = k
    end
    for k, v in pairs(const.UnitEventType) do
        event_list.global[v] = k
    end
    for k, v in pairs(const.ModifierEventType) do
        event_list.global[v] = k
    end
    for k, v in pairs(const.ProjectileEventType) do
        event_list.global[v] = k
    end
    for k, v in pairs(const.DestructibleEventType) do
        event_list.global[v] = k
    end
end

---技能事件列表初始化
local function ability_event_list_init()
    local function ability_add(name, enum, params)
        table.insert(event_list.ability, new_child(name, enum, params))
    end
    
    for k, v in pairs(const.AbilityEventType) do
        ability_add(k,v,{})
    end

end

---道具事件列表初始化
local function item_event_list_init()
    local function item_add(name, enum, params)
        table.insert(event_list.item, new_child(name, enum, params))
    end
    
    for k, v in pairs(const.ItemEventType) do
        item_add(k,v,{})
    end

end

---单位事件列表初始化
local function unit_event_list_init()
    local function unit_add(name, enum, params)
        table.insert(event_list.unit, new_child(name, enum, params))
    end
    for k, v in pairs(const.UnitEventType) do
        unit_add(k,v,{})
    end

end

---魔法效果事件列表初始化
local function modifier_event_list_init()
    local function modifier_add(name, enum, params)
        table.insert(event_list.modifier, new_child(name, enum, params))
    end    
    for k, v in pairs(const.ModifierEventType) do
        modifier_add(k,v,{})
    end

end

---投射物事件列表初始化
local function projectile_event_list_init()
    local function projectile_add(name, enum, params)
        table.insert(event_list.projectile, new_child(name, enum, params))
    end    
    for k, v in pairs(const.ProjectileEventType) do
        projectile_add(k,v,{})
    end

    
end

---可破坏物事件列表初始化
local function destructible_event_list_init()
    local function destructible_add(name, enum, params)
        table.insert(event_list.destructible, new_child(name, enum, params))
    end
    for k, v in pairs(const.DestructibleEventType) do
        destructible_add(k,v,{})
    end

end

function event_manager.init()
    global_event_list_init()

    ability_event_list_init()
    item_event_list_init()
    unit_event_list_init()
    modifier_event_list_init()
    projectile_event_list_init()
    destructible_event_list_init()
end

function event_manager.get_lua_params(params, py_data)
    local lua_data = {}
    for i, v in pairs(params) do
        if v == '__ability' then
            local lua_ability = y3.ability.get_lua_ability_from_py(py_data[v])
            table.insert(lua_data, lua_ability)
        elseif v == '__unit_id' then
            local lua_unit = y3.unit.get_lua_unit_from_py(game_api.get_unit_by_id(py_data[v]))
            table.insert(lua_data, lua_unit)
        elseif v == '__item_id' then
            local lua_item = y3.item.get_lua_item_from_py(py_data[v])
            table.insert(lua_data, lua_item)
        end
    end
    return lua_data
end





function event_manager.has_event(event_name)
    if type(event_name) == 'table' then
        if event_list.global[event_name[1]] then
            return true
        end
    elseif type(event_name) == 'string' then
        if event_list.global[event_name] then
            return true
        end
    end
    return false
end
