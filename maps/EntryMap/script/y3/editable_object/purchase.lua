--- File Name : purchase.lua
--- Description: 物品相关逻辑 对应编辑器---物品

local setmetatable = setmetatable
local ipairs = ipairs

---@class purchase
local purchase = {}
purchase.__index = purchase
y3.purchase = purchase

---所有物品实例
local Purchases = setmetatable({}, { __mode = 'kv' })
---所有触发器组
local TriggerGroups = {}





---@param group table 物编触发器组
---@param purchase_id number 物编平台道具id
---初始化物编触发器组
local function trigger_group_init(group, purchase_id)
    group.add_trigger = function(event_name,action)
        local enum, params = event_manager.get_enum_and_params(event_name,event_enum.purchase)
        local trigger_id = trigger.get_trigger_id()
        local py_trigger = new_item_trigger(item_id, trigger_id, event_name, enum, true)
        function py_trigger.on_event(trigger, event, actor, data)
            --local lua_data = event_manager.get_lua_params(params, data)
            action(data)
        end
    end
end


---@param item_id number 物编道具id
---@return trigger_group 触发器组
---按照道具id创建道具触发器组
function purchase.create_purchase_trigger_group(purchase_id)
    if not TriggerGroups[purchase_id] then
        TriggerGroups[purchase_id] = {}
        trigger_group_init(TriggerGroups[purchase_id], purchase_id)
    end
    return TriggerGroups[purchase_id]
end


---@param  py_item table py层的道具实例
---@return table 返回在lua层初始化后的lua层道具实例
---通过py层的技能实例获取lua层的道具实例
function purchase.get_lua_purchase_from_py(py_purchase)
    if not py_purchase then
        return
    end
    --TODO:获取id的api不知道是不是这个，要再确认
    local py = py_obj.new(py_purchase)
    local id = py_purchase.api_get_id()
    if not Purchases[id] then
        local new_purchase = {}
        setmetatable(new_purchase, purchase)
        new_purchase.base = py
        new_purchase.id = id
        Purchases[id] = new_purchase
    end
    return Purchases[id]
end

