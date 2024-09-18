local event_configs = require 'y3.meta.eventconfig'
local event_datas   = require 'y3.meta.event'

---@class ObjectEvent
---@field private object_event_manager? EventManager
---@overload fun(): self
local M = Class 'ObjectEvent'

-- 注册对象的引擎事件
---@param event_name string
---@param ... any
---@return Trigger
function M:event(event_name, ...)
    if not rawget(self, 'object_event_manager') then
        self.object_event_manager = New 'EventManager' (self)
    end
    local extra_args, callback, unsubscribe = self:subscribe_event(event_name, ...)
    local trigger = self.object_event_manager:event(event_name, extra_args, callback)
    ---@diagnostic disable-next-line: invisible
    trigger:on_remove(unsubscribe)

    local gcHost = self --[[@as GCHost]]
    if gcHost.bindGC then
        gcHost:bindGC(New 'GCBuffer' (0, trigger))
    end

    return trigger
end

---@param self_type string
---@param config table
---@return boolean
local function is_valid_object(self_type, config)
    if config.object == self_type then
        return true
    end
    local extra_objs = config.extraObjs
    if not extra_objs then
        return false
    end
    for _, data in ipairs(extra_objs) do
        if data.luaType == self_type then
            return true
        end
    end
    return false
end

---@param event_name string
---@param ... any
---@return any[]?
---@return Trigger.CallBack
---@return function Unsubscribe
function M:subscribe_event(event_name, ...)
    local config = event_configs.config[event_name]
    local self_type = y3.class.type(self)
    if not config or not self_type then
        error('此事件无法作为对象事件：' .. tostring(event_name))
    end
    if not config or not is_valid_object(self_type, config) then
        error('此事件无法作为对象事件：' .. tostring(event_name))
    end

    local nargs = select('#', ...)
    local extra_args
    ---@type Trigger.CallBack
    local callback
    if nargs == 1 then
        callback = ...
    elseif nargs > 1 then
        extra_args = {...}
        callback = extra_args[nargs]
        extra_args[nargs] = nil
    else
        error('缺少回调函数！')
    end

    if self_type == config.object then
        -- 检查将对象还原到事件参数中
        for i, param in ipairs(config.params) do
            if param.type == config.object then
                if not extra_args then
                    extra_args = {}
                end
                table.insert(extra_args, i, self)
                break
            end
        end
    end

    y3.py_event_sub.event_register(event_name, extra_args)

    local unsubscribe = function ()
        y3.py_event_sub.event_unregister(event_name, extra_args)
    end

    return extra_args, callback, unsubscribe
end

local function get_master(datas, config, lua_params)
    local master = config.master_data
    if not master then
        if config.master then
            for _, data in ipairs(datas) do
                if data.lua_name == config.master then
                    master = data
                    break
                end
            end
        else
            for _, data in ipairs(datas) do
                if data.lua_type == config.object then
                    master = data
                    break
                end
            end
        end
        config.master_data = master
    end
    local py_object = lua_params._py_params[master.name]
    -- 如果一个py对象从来没有被初始化过，
    -- 那么他身上一定不会挂载任何事件，可以直接跳过
    if type(py_object) == 'userdata' and not y3.py_proxy.fetch(py_object) then
        return nil
    end
    return lua_params[master.lua_name]
end

local function event_notify(event_name, extra_args, lua_params)
    local config = event_configs.config[event_name]
    if not config or not config.object then
        return
    end
    local datas = event_datas[config.key]
    local master = get_master(datas, config, lua_params)
    if not master then
        return
    end
    ---@type EventManager?
    local event_manager = master.object_event_manager
    if event_manager then
        if config.dispatch then
            event_manager:dispatch(event_name, extra_args, lua_params)
        else
            event_manager:notify(event_name, extra_args, lua_params)
        end
    end

    if config.extraObjs then
        for _, data in ipairs(config.extraObjs) do
            local extraMaster = data.getter(master, lua_params)
            if extraMaster then
                ---@type EventManager?
                local extra_event_manager = extraMaster.object_event_manager
                if extra_event_manager then
                    if config.dispatch then
                        extra_event_manager:dispatch(event_name, extra_args, lua_params)
                    else
                        extra_event_manager:notify(event_name, extra_args, lua_params)
                    end
                end
            end
        end
    end
end

return {
    event_notify = event_notify,
}
