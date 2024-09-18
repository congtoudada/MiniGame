local ipairs = ipairs
local pairs = pairs
local setmetatable = setmetatable
local table_remove = table.remove
local table_insert = table.insert

local trigger_map = setmetatable({}, { __mode = 'kv' })

local mt = {}
mt.__index = mt
-- 结构
mt.type = 'trigger'
-- 是否允许
mt.enable_flag = true
mt.sign_remove = false
-- 事件
mt.event = nil

function mt:__tostring()
    return '[table:trigger]'
end

-- 禁用触发器
function mt:disable()
    self.enable_flag = false
end

function mt:enable()
    self.enable_flag = true
end

function mt:is_enable()
    return self.enable_flag
end

-- 运行触发器
function mt:__call(...)
    if self.sign_remove then
        return
    end
    if self.enable_flag then
        return self:callback(...)
    end
end

-- 摧毁触发器(移除全部事件)
function mt:remove()
    if not self.event then
        return
    end
    trigger_map[self] = nil
    local event = self.event
    self.event = nil
    self.sign_remove = true
    y3.wait(0, function()
        for i, trg in ipairs(event) do
            if trg == self then
                table_remove(event, i)
                break
            end
        end
        if #event == 0 then
            if event.remove then
                event:remove()
            end
        end
    end)
end

function y3.each_trigger()
    return pairs(trigger_map)
end

-- 创建触发器
function y3.create_trigger(event, callback)
    local trg = setmetatable({event = event, callback = callback}, mt)
    table_insert(event, trg)
    trigger_map[trg] = true
    return trg
end

