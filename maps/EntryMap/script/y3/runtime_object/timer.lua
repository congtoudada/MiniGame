--- File Name : timer.lua

--- Description: 


local setmetatable = setmetatable

---@class  timer
local timer = {}
timer.__index = timer
y3.timer = timer

function y3.wait(timeout, on_timer)
    return timer.run_single_timer(timeout, on_timer)
end

function y3.loop(timeout, on_timer)
    return timer.run_looped_timer(timeout, true, on_timer)
end

function y3.count_loop(timeout, count, on_timer)
    return timer.run_count_timer(timeout, count, true, on_timer)
end

function timer.run_single_timer(wait_time, action, data)
    local delay = function()
        return Fix32(wait_time)
    end
    local repeat_count = function()
        return 1
    end
    local is_run_at_start = function()
        return false
    end
    local py_timer = game_api.run_lua_timer(delay(), repeat_count(), is_run_at_start(), function(data)
        action(data)
    end,data or {})
    return timer.get_lua_timer_from_py(py_timer)
end

function timer.run_looped_timer(interval_time, is_run_immediately, action, data)
    local delay = function()
        return Fix32(interval_time)
    end
    local repeat_count = function()
        return -1
    end
    local is_run_at_start = function()
        return is_run_immediately
    end
    local py_timer = game_api.run_lua_timer(delay(), repeat_count(), is_run_at_start(), function(data)
        action(data)
    end,data or {})
    return timer.get_lua_timer_from_py(py_timer)
end

function timer.run_count_timer(interval_time, count, is_run_immediately, action, data)
    local delay = function()
        return Fix32(interval_time)
    end
    local repeat_count = function()
        return count
    end
    local is_run_at_start = function()
        return is_run_immediately
    end
    local py_timer = game_api.run_lua_timer(delay(), repeat_count(), is_run_at_start(), function(data)
        action(data)
    end,data or {})
    return timer.get_lua_timer_from_py(py_timer)
end

function timer.get_lua_timer_from_py(py_timer)
    local new = {}
    local py = py_obj.new(py_timer)
    new.base = py
    setmetatable(new, timer)
    return new
end

---获取当前到期的计时器
function timer.get_removed_tech(data)
    local py_timer = game_api.get_current_expired_timer(data.current_timer)
    return timer.get_lua_timer_from_py(py_timer)
end

function timer:is_running()
    return game_api.is_timer_valid(self.base())
end

---@return number time 计时器经过的时间
---获取计时器经过的时间
function timer:get_elapsed_time()
    return game_api.get_timer_elapsed_time(self.base())
end

---@return integer count 初始计数
---获取计时器初始计数
function timer:get_init_count()
    return game_api.get_timer_init_count(self.base())
end

---@return number time 计时器剩余时间
---获取计时器剩余时间
function timer:get_remaining_time()
    return game_api.get_timer_remaining_time(self.base())
end

---@return integer count 剩余计数
---获取计时器剩余计数
function timer:get_remaining_count()
    return game_api.get_timer_remaining_count(self.base())
end

---@return number time 设置的时间
---获取计时器设置的时间
function timer:get_time_out_time()
    return game_api.get_timer_time_out_time(self.base())
end