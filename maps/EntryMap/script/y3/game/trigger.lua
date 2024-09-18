local setmetatable = setmetatable

---@class trigger
local trigger = {}
trigger.__index = trigger
y3.trigger = trigger

---触发器id，每个触发器id不能重复
local trigger_id = 10000

---获取触发器id，保证不重复
---@return number 触发器id
function trigger.get_trigger_id()
    trigger_id = trigger_id + 1
    return trigger_id
end

--- 创建触发器
---@param event_name string 事件名 固定字符串,特殊情况下是一个table，包含参数
---@param action function 事件发生时执行的行为
function trigger.create_global_trigger(event_name, action) 
    local enum, params = event_manager.get_enum_and_params(event_name)
    local trigger_id = trigger.get_trigger_id()
    local py_trigger = nil
    py_trigger = new_global_trigger(trigger_id, "global event", enum, true)
    function py_trigger.on_event(trigger, event, actor, data)
        action(data) 
    end
end


