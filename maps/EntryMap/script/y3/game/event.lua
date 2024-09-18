local setmetatable = setmetatable
local ipairs = ipairs

if y3.game then return end

y3.game = {}

local trg_event_list = {}
local trigger_id = 50000

function y3.event_dispatch(obj, name, ...)
	local events = obj._events
	if not events then
		return
	end
	local event = events[name]
	if not event then
		return
	end
	for i = #event, 1, -1 do
		local res, arg = event[i](...)
		if res ~= nil then
			return res, arg
		end
	end
end

function y3.event_notify(obj, name, ...)
	local events = obj._events
	if not events then
		return
	end
	local event = events[name]
	if not event then
		return
	end
	for i = #event, 1, -1 do
		event[i](...)
	end
end

local function glb_trigger_init(name)
    local py_trigger = nil
    local name1 = {}
    if trg_event_list[name] then
        return
    end
    trg_event_list[name]  = true
    trigger_id = trigger_id + 1
    local c = nil
    if type(name) == "table" then
        if #name <= 2 then
            for k,v in pairs(name) do
                if type(v) == "function" then
                    c = v
                end
            end
            if c then
                name1 = name[1]
            else
                name1 = name
            end
        else
            for k,v in pairs(name) do
                if type(v) == "function" then
                    c = v
                else
                    table.insert(name1,v)
                end
            end
            if c then
            else
                name1 = name
            end
        end
    else
        name1 = name
    end
    py_trigger = new_global_trigger(trigger_id, name, name1, true,c)
    function py_trigger.on_event(trigger, event, actor, data)
        if event == const.GlobalEventType['GAME_INIT'] then
            _game_init = true
        end
        local event_type = name
        if type(name) == 'table' then
            event_type = name[1]
        end
        if EVENT_DATA[event_type] then
            y3.game:event_notify(name,EVENT_DATA[event_type](data))
        else
            y3.game:event_notify(name,data)
        end
        
        -- action(data)
    end
    if _game_init then
        game_api.enable_global_lua_trigger(py_trigger)
    end
end


function y3.event_register(obj, name, f)
    local events = obj._events
    if not events then
        events = {}
        obj._events = events
    end
    local event = events[name]
    if not event then
        if event_manager.has_event(name) then
            glb_trigger_init(name)
        end
        
        event = {}
        events[name] = event
        local ac_event = name
        if obj.event_subscribe then
            obj:event_subscribe(ac_event)
        end
        function event:remove()
            events[name] = nil
            if obj.event_unsubscribe then
                obj:event_unsubscribe(ac_event)
            end
        end
    end
    return y3.create_trigger(event, f)
end

function y3.game:event_dispatch(name, ...)
	return y3.event_dispatch(self, name, ...)
end

function y3.game:event_notify(name, ...)
	return y3.event_notify(self, name, ...)
end

function y3.game:event(name, f,c)
	return y3.event_register(self, name, f,c)
end
