
local setmetatable = setmetatable

local enum_f = {
    number = function (u)
        return u:float()
    end,
    player = function (id)
        return y3.player(id)
    end,
    projectile = function (u)
        return y3.projectile.get_lua_projectile_from_py(u)
    end,
    unit = function(u) 
        return y3.unit.get_lua_unit_from_py(u) 
    end,
    item = function(u) return y3.item.get_lua_item_from_py(u) end,
    skill = function (u) return y3.ability.get_lua_ability_from_py(u) end,
    -- point = function (u) return up.actor_point(u) end,
    buff = function(u) return y3.modifier.get_lua_modifier_from_py(u) end,
    unit_group = function (u)  --转化待优化
        return y3.unit_group.create_lua_unit_group_from_py(u)
    end,
    destructible = function (u)
        return y3.destructible.get_lua_destructible_from_py(u)
    end,
    other = function (u)
        return u
    end
}

EVENT_DATA = {}
-- event_data.unit_die.unit = y3.unit.get_lua_unit_from_py(data['__target_unit'])


---@class EVENT_DATA.ET_EVENT_CUSTOM
--********************缺少自定义参数列表********************

-- local arg_data = {
--     ['parm_dict'] = {'__c_param_dict','other'},
-- }

-- EVENT_DATA.ET_EVENT_CUSTOM = function (data)
--     -- local a= {}
--     -- a.data = data
--     -- local mytable = setmetatable(a,
-- 	-- {__index = function(mytable,key)
--     --     if arg_data[key] then 
--     --         return arg_data[key]
--     --     else 
--     --         return nil
--     --     end 
--     -- end})
--     -- return mytable
-- end

---@class EVENT_DATA.ET_TRIGGER_COMPONENT_EVENT

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['ui_event'] = {'__mousewhell','other'},
    ['comp'] = {'__mousewhell','other'},
}

EVENT_DATA.ET_TRIGGER_COMPONENT_EVENT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_MOUSE_WHEEL_EVENT

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['wheel'] = {'__mousewhell','other'},
}


EVENT_DATA.ET_MOUSE_WHEEL_EVENT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.MOUSE_MOVE_EVENT

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['point'] = {'__pointing_world_pos','point'},
    ['screen_x'] = {'__tar_x','other'},
    ['screen_y'] = {'__tar_y','other'},
}

EVENT_DATA.MOUSE_MOVE_EVENT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end


---@class EVENT_DATA.MOUSE_KEY_DB_CLICK_EVENT


local arg_data = {
    ['player'] = {'__role_id','player'},
    ['key'] = {'__mouse_wheel','other'},
    ['point'] = {'__pointing_world_pos','point'},
}

EVENT_DATA.MOUSE_KEY_DB_CLICK_EVENT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_MOUSE_KEY_UP_EVENT


local arg_data = {
    ['player'] = {'__role_id','player'},
    ['key'] = {'__cur_key','other'},
    ['point'] = {'__pointing_world_pos','point'},
}

EVENT_DATA.ET_MOUSE_KEY_UP_EVENT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_MOUSE_KEY_DOWN_EVENT


local arg_data = {
    ['player'] = {'__role_id','player'},
    ['key'] = {'__cur_key','other'},
    ['point'] = {'__pointing_world_pos','point'},
}

EVENT_DATA.ET_MOUSE_KEY_DOWN_EVENT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end


---@class EVENT_DATA.ET_UNIT_START_NAV_EVENT


local arg_data = {
    ['unit'] = {'__unit_id','unit'},
}

EVENT_DATA.UNIT_END_NAV_EVENT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end


---@class EVENT_DATA.ET_UNIT_START_NAV_EVENT


local arg_data = {
    ['unit'] = {'__unit_id','unit'},
}

EVENT_DATA.ET_UNIT_START_NAV_EVENT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_KEYBOARD_KEY_UP_EVENT


local arg_data = {
    ['player'] = {'__role_id','player'},
    ['key'] = {'__current_key','other'},
}

EVENT_DATA.ET_KEYBOARD_KEY_UP_EVENT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_KEYBOARD_KEY_DOWN_EVENT


local arg_data = {
    ['player'] = {'__role_id','player'},
    ['key'] = {'__current_key','other'},
}

EVENT_DATA.ET_KEYBOARD_KEY_DOWN_EVENT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ROLE_JOIN_BATTLE

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['middle_join'] = {'__is_middle_join','other'},
}

EVENT_DATA.ET_ROLE_JOIN_BATTLE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ROLE_ACTIVE_EXIT_GAME_EVENT

local arg_data = {
    ['player'] = {'__role_id','player'},
}

EVENT_DATA.ET_ROLE_ACTIVE_EXIT_GAME_EVENT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ROLE_LOSE_CONNECT

local arg_data = {
    ['player'] = {'__role_id','player'},
}

EVENT_DATA.ET_ROLE_LOSE_CONNECT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ROLE_INPUT_MSG

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['msg'] = {'__msg','other'},
}

EVENT_DATA.ET_ROLE_INPUT_MSG = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_CHAT_SEND_GM

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['msg'] = {'__str1','other'},
}

EVENT_DATA.ET_CHAT_SEND_GM = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_SELECT_UNIT

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['unit'] = {'__unit_id','unit'},
}

EVENT_DATA.ET_SELECT_UNIT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_SELECT_UNIT_GROUP

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['unit_group'] = {'__unit_group_id_list','unit_group'},
    ['team_id'] = {'__team_id','other'}
}

EVENT_DATA.ET_SELECT_UNIT_GROUP = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_SELECT_ITEM

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['item'] = {'__item_id','item'},
}

EVENT_DATA.ET_SELECT_ITEM = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_DOUBLE_CLICK_ITEM

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['item'] = {'__item_id','item'},
}

EVENT_DATA.ET_DOUBLE_CLICK_ITEM = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end


--********************缺少技能转化********************
---@class EVENT_DATA.ET_START_SKILL_POINTER

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['unit'] = {'__unit_id','unit'},
    -- ['ability'] = {'__item_id','item'},
}

-- (EParams.ROLE_ID, EType.RoleID, '玩家ID'),
-- (EParams.UNIT_ID, EType.UnitID, '释放单位id'),
-- (EParams.ABILITY_TYPE, EType.AbilityType, '技能类型'),
-- (EParams.ABILITY_INDEX, EType.AbilityIndex, '技能Index'),
-- (EParams.ABILITY_SEQ, EType.AbilitySeq, '技能Seq'),),
EVENT_DATA.ET_START_SKILL_POINTER = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_STOP_SKILL_POINTER

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['unit'] = {'__unit_id','unit'},
}

EVENT_DATA.ET_STOP_SKILL_POINTER = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end


---@class EVENT_DATA.ET_SELECT_DEST

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['destructible'] = {'__destructible_id','destructible'},
}

EVENT_DATA.ET_SELECT_DEST = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_DOUBLE_CLICK_DEST

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['destructible'] = {'__destructible_id','destructible'},
}

EVENT_DATA.ET_DOUBLE_CLICK_DEST = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ROLE_RESOURCE_CHANGED

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['res'] = {'__res_key','other'},
    ['value'] = {'__res_value','other'},
}

EVENT_DATA.ET_ROLE_RESOURCE_CHANGED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.MOUSE_KEY_DB_CLICK_UNIT_EVENT

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['key'] = {'__cur_key','other'},
    ['unit'] = {'__unit_id','unit'},
}

EVENT_DATA.MOUSE_KEY_DB_CLICK_UNIT_EVENT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_BUILD_FINISH

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['buid_unit'] = {'__build_unit_id','unit'},
    ['ability'] = {'__ability','skill'},
}

EVENT_DATA.ET_ABILITY_BUILD_FINISH = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_ATTR_CHANGE

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['attr'] = {'__attr','unit'},
    ['ability'] = {'__ability','skill'},
}

EVENT_DATA.ET_UNIT_ATTR_CHANGE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ITEM_BROKEN

local arg_data = {
    ['item'] = {'__item','item'},
    ['unit'] = {'__unit','unit'},
}


EVENT_DATA.ET_ITEM_BROKEN = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ITEM_SOLD

local arg_data = {
    ['item'] = {'__item','item'},
    ['unit'] = {'__unit2','unit'},
    ['shop'] = {'__unit','unit'},
}

EVENT_DATA.ET_ITEM_SOLD = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_AREA_ENTER

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['area'] = {'__area_id','other'},
}

EVENT_DATA.ET_AREA_ENTER = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_AREA_LEAVE

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['area'] = {'__area_id','area'},
}

EVENT_DATA.ET_AREA_LEAVE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_PRECONDITION_SUCCEED

local arg_data = {
    ['unit_type'] = {'__unit_key','other'},
    ['player'] = {'__role_id','player'},
}

EVENT_DATA.ET_UNIT_PRECONDITION_SUCCEED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_PRECONDITION_FAILED

local arg_data = {
    ['unit_type'] = {'__unit_key','other'},
    ['player'] = {'__role_id','player'},
}

EVENT_DATA.ET_UNIT_PRECONDITION_FAILED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ITEM_PRECONDITION_SUCCEED

local arg_data = {
    ['item_type'] = {'__item_no','other'},
    ['player'] = {'__role_id','player'},
}

EVENT_DATA.ET_ITEM_PRECONDITION_SUCCEED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ITEM_PRECONDITION_FAILED

local arg_data = {
    ['item_type'] = {'__item_no','other'},
    ['player'] = {'__role_id','player'},
}

EVENT_DATA.ET_ITEM_PRECONDITION_FAILED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_PRECONDITION_SUCCEED

local arg_data = {
    ['skill_type'] = {'__ability_id','other'},
    ['player'] = {'__role_id','player'},
}

EVENT_DATA.ET_ABILITY_PRECONDITION_SUCCEED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_PRECONDITION_FAILED

local arg_data = {
    ['skill_type'] = {'__ability_id','other'},
    ['player'] = {'__role_id','player'},
}

EVENT_DATA.ET_ABILITY_PRECONDITION_FAILED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_TECH_PRECONDITION_SUCCEED

local arg_data = {
    ['tech_type'] = {'__tech_no','other'},
    ['player'] = {'__role_id','player'},
}

EVENT_DATA.ET_TECH_PRECONDITION_SUCCEED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_TECH_PRECONDITION_FAILED

local arg_data = {
    ['tech_type'] = {'__tech_no','other'},
    ['player'] = {'__role_id','player'},
}

EVENT_DATA.ET_TECH_PRECONDITION_FAILED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ROLE_TECH_UPGRADE

local arg_data = {
    ['tech_type'] = {'__tech_no','other'},
    ['player'] = {'__role_id','player'},
    ['lv'] = {'__curr_lv','other'},
}

EVENT_DATA.ET_ROLE_TECH_UPGRADE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ROLE_TECH_DOWNGRADE

local arg_data = {
    ['tech_type'] = {'__tech_no','other'},
    ['player'] = {'__role_id','player'},
    ['lv'] = {'__curr_lv','other'},
}

EVENT_DATA.ET_ROLE_TECH_DOWNGRADE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end


---@class EVENT_DATA.ET_ROLE_TECH_CHANGED

local arg_data = {
    ['tech_type'] = {'__tech_no','other'},
    ['player'] = {'__role_id','player'},
    ['lv'] = {'__curr_lv','other'},
    ['delta_lv'] = {'__delta_lv','other'},
}

EVENT_DATA.ET_ROLE_TECH_CHANGED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

--单位死亡参数
---@class EVENT_DATA.ET_UNIT_DIE

local arg_data = {
    ['target_unit'] = {'__target_unit','unit'},
    ['source_unit'] = {'__source_unit','unit'},
}

EVENT_DATA.ET_UNIT_DIE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

--单位死亡参数
---@class EVENT_DATA.ET_KILL_UNIT

local arg_data = {
    ['target_unit'] = {'__target_unit','unit'},
    ['source_unit'] = {'__source_unit','unit'},
    ['damage'] = {'__damage','number'},
    ['damage_type'] = {'__damage_type','other'},
    ['ability'] = {'__ability','skill'},
}

EVENT_DATA.ET_KILL_UNIT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            if type(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])) == "number" then
                return math.abs(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]]))
            else
                return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
            end
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_BORN

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
}

EVENT_DATA.ET_UNIT_BORN = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_BEFORE_UNIT_DIE

local arg_data = {
    ['target_unit'] = {'__target_unit','unit'},
    ['source_unit'] = {'__source_unit','unit'},
    ['damage'] = {'__damage','number'},
    ['damage_type'] = {'__damage_type','other'},
    ['ability'] = {'__ability','skill'},
}

EVENT_DATA.ET_BEFORE_UNIT_DIE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            if type(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])) == "number" then
                return math.abs(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]]))
            else
                return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
            end
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_REVIVE_UNIT

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
}

EVENT_DATA.ET_REVIVE_UNIT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end


---@class EVENT_DATA.ET_UPGRADE_UNIT

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
}

EVENT_DATA.ET_UPGRADE_UNIT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end


---@class EVENT_DATA.ET_UNIT_PRE_ADD_EXP

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['exp'] = {'__add_exp','number'}
}

EVENT_DATA.ET_UNIT_PRE_ADD_EXP = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_ON_ADD_EXP

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['exp'] = {'__add_exp','number'}
}

EVENT_DATA.ET_UNIT_ON_ADD_EXP = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end


---@class EVENT_DATA.ET_UNIT_BE_HURT

local arg_data = {
    ['target_unit'] = {'__target_unit','unit'},
    ['source_unit'] = {'__source_unit','unit'},
    ['damage'] = {'__damage','number'},
    ['damage_type'] = {'__damage_type','other'},
    ['ability'] = {'__ability','skill'},
}

EVENT_DATA.ET_UNIT_BE_HURT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            if type(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])) == "number" then
                return math.abs(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]]))
            else
                return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
            end
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_HURT_OTHER

local arg_data = {
    ['target_unit'] = {'__target_unit','unit'},
    ['source_unit'] = {'__source_unit','unit'},
    ['damage'] = {'__damage','number'},
    ['damage_type'] = {'__damage_type','other'},
    ['ability'] = {'__ability','skill'},
}

EVENT_DATA.ET_UNIT_HURT_OTHER = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            if type(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])) == "number" then
                return math.abs(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]]))
            else
                return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
            end
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_BE_HURT_BEFORE_APPLY

local arg_data = {
    ['target_unit'] = {'__target_unit','unit'},
    ['source_unit'] = {'__source_unit','unit'},
    ['damage'] = {'__damage','number'},
    ['damage_type'] = {'__damage_type','other'},
    ['ability'] = {'__ability','skill'},
}

EVENT_DATA.ET_UNIT_BE_HURT_BEFORE_APPLY = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then
            if type(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])) == "number" then
                return math.abs(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]]))
            else
                return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
            end
        else 
            return nil
        end 
    end})
    return mytable
end


---@class EVENT_DATA.ET_UNIT_HURT_OTHER_BEFORE_APPLY

local arg_data = {
    ['target_unit'] = {'__target_unit','unit'},
    ['source_unit'] = {'__source_unit','unit'},
    ['damage'] = {'__damage','number'},
    ['damage_type'] = {'__damage_type','other'},
    ['ability'] = {'__ability','skill'},
}

EVENT_DATA.ET_UNIT_HURT_OTHER_BEFORE_APPLY = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            if type(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])) == "number" then
                return math.abs(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]]))
            else
                return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
            end
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_BE_HURT_COMPLETE

local arg_data = {
    ['target_unit'] = {'__target_unit','unit'},
    ['source_unit'] = {'__source_unit','unit'},
    ['damage'] = {'__damage','number'},
    ['is_crit'] = {'__is_critical_hit','other'},
    ['is_attack'] = {'__is_normal_hit','other'},
    ['damage_type'] = {'__damage_type','other'},
    ['ability'] = {'__ability','skill'},
}

EVENT_DATA.ET_UNIT_BE_HURT_COMPLETE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            if type(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])) == "number" then
                return math.abs(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]]))
            else
                return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
            end
        else 
            return nil
        end 
    end})
    return mytable
end


---@class EVENT_DATA.ET_UNIT_HURT_OTHER_FINISH

local arg_data = {
    ['target_unit'] = {'__target_unit','unit'},
    ['source_unit'] = {'__source_unit','unit'},
    ['damage'] = {'__damage','number'},
    ['is_crit'] = {'__is_critical_hit','other'},
    ['is_attack'] = {'__is_normal_hit','other'},
    ['damage_type'] = {'__damage_type','other'},
    ['ability'] = {'__ability','skill'},
}

EVENT_DATA.ET_UNIT_HURT_OTHER_FINISH = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            if type(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])) == "number" then
                return math.abs(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]]))
            else
                return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
            end
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_GET_CURE_BEFORE_APPLY

local arg_data = {
    ['health'] = {'__cured_value','number'},
    ['target_unit'] = {'__target_unit','unit'},
    ['source_unit'] = {'__source_unit','unit'},
}

EVENT_DATA.ET_UNIT_GET_CURE_BEFORE_APPLY = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_GET_CURE_FINISH

local arg_data = {
    ['health'] = {'__cured_value','number'},
    ['target_unit'] = {'__target_unit','unit'},
    ['source_unit'] = {'__source_unit','unit'},
}

EVENT_DATA.ET_UNIT_GET_CURE_FINISH = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_GET_CURE

local arg_data = {
    ['health'] = {'__cured_value','number'},
    ['target_unit'] = {'__target_unit','unit'},
    ['source_unit'] = {'__source_unit','unit'},
}

EVENT_DATA.ET_UNIT_GET_CURE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_RELEASE_ABILITY

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['ability'] = {'__ability','skill'},
}

EVENT_DATA.ET_UNIT_RELEASE_ABILITY = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_START_MOVE

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
}

EVENT_DATA.ET_UNIT_START_MOVE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_ENTER_BATTLE

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
}

EVENT_DATA.ET_UNIT_ENTER_BATTLE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_EXIT_BATTLE

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
}

EVENT_DATA.ET_UNIT_EXIT_BATTLE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_ENTER_GRASS

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
}

EVENT_DATA.ET_UNIT_ENTER_GRASS = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_LEAVE_GRASS

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
}

EVENT_DATA.ET_UNIT_LEAVE_GRASS = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end
		
-----*****************8不太对
---@class EVENT_DATA.ET_ABILITY_PLUS_POINT

local arg_data = {
    ['ability'] = {'__ability','skill'},
}

EVENT_DATA.ET_ABILITY_PLUS_POINT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end
		
---@class EVENT_DATA.ET_UNIT_REMOVE

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
}

EVENT_DATA.ET_UNIT_REMOVE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end
	
---@class EVENT_DATA.ET_UNIT_SHOP_BUY_ITEM

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['shop'] = {'__shop_unit_id','unit'},
    ['item'] = {'__item_stuff_id','item'},
}

EVENT_DATA.ET_UNIT_SHOP_BUY_ITEM = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_ITEM_SELL

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['shop'] = {'__shop_unit_id','unit'},
    ['item'] = {'__item_id','item'},
}

EVENT_DATA.ET_UNIT_ITEM_SELL = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_ITEM_COMPOSE

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['item'] = {'__item_prop_id','item'},
    ['compose_id'] = {'__compose_id','other'},
}

EVENT_DATA.ET_UNIT_ITEM_COMPOSE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_SHOP_BUY_WITH_COMPOSE

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['shop'] = {'__shop_unit_id','unit'},
    ['item'] = {'__item_id','item'},
}

EVENT_DATA.ET_UNIT_SHOP_BUY_WITH_COMPOSE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_UPGRADE_TECH

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['player'] = {'__role_id','player'},
    ['tech_type'] = {'__tech_no','other'},
}

EVENT_DATA.ET_UNIT_UPGRADE_TECH = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_ADD_TECH

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['player'] = {'__role_id','player'},
    ['tech_type'] = {'__tech_no','other'},
}

EVENT_DATA.ET_UNIT_ADD_TECH = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_REMOVE_TECH
local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['player'] = {'__role_id','player'},
    ['tech_type'] = {'__tech_no','other'},
}

EVENT_DATA.ET_UNIT_REMOVE_TECH = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_ROLE_CHANGED

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['player'] = {'__new_role_id','player'},
    ['old_player'] = {'__old_role_id','player'},
}

EVENT_DATA.ET_UNIT_ROLE_CHANGED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ITEM_ON_CREATE

local arg_data = {
    ['item'] = {'__item_id','item'},
}

EVENT_DATA.ET_ITEM_ON_CREATE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_ADD_ITEM

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['item'] = {'__item_id','item'},
}

EVENT_DATA.ET_UNIT_ADD_ITEM = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_ADD_ITEM_TO_PKG

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['item'] = {'__item_id','item'},
    ['item_type'] = {'__item_no','other'}
}

EVENT_DATA.ET_UNIT_ADD_ITEM_TO_PKG = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_ADD_ITEM_TO_BAR

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['item'] = {'__item_id','item'},
    ['item_type'] = {'__item_no','other'}
}

EVENT_DATA.ET_UNIT_ADD_ITEM_TO_BAR = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_REMOVE_ITEM

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['item'] = {'__item_id','item'},
}

EVENT_DATA.ET_UNIT_REMOVE_ITEM = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_REMOVE_ITEM_FROM_PKG

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['item'] = {'__item_id','item'},
    ['item_type'] = {'__item_no','other'}
}

EVENT_DATA.ET_UNIT_REMOVE_ITEM_FROM_PKG = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_REMOVE_ITEM_FROM_BAR

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['item'] = {'__item_id','item'},
    ['item_type'] = {'__item_no','other'}
}

EVENT_DATA.ET_UNIT_REMOVE_ITEM_FROM_BAR = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_UNIT_USE_ITEM

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['item'] = {'__item_id','item'},
}

EVENT_DATA.ET_UNIT_USE_ITEM = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ITEM_STACK_CHANGED

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['item'] = {'__item_id','item'},
    ['cnt'] = {'__delta_cnt','other'},
}

EVENT_DATA.ET_ITEM_STACK_CHANGED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ITEM_CHARGE_CHANGED

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['item'] = {'__item_id','item'},
    ['cnt'] = {'__delta_cnt','other'},
}

EVENT_DATA.ET_ITEM_CHARGE_CHANGED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ITEM_ON_DESTROY

local arg_data = {  
    ['item_key'] = {'__item_id','other'},
}

EVENT_DATA.ET_ITEM_ON_DESTROY = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ITEM_CREATE_ON_DEST_COLLECTED

local arg_data = {  
    ['item'] = {'__item','item'},
    ['unit'] = {'__unit_id','unit'},
    ['destructible'] = {'__destructible_id','destructible'},
    ['ability'] = {'__ability','skill'}
}

EVENT_DATA.ET_ITEM_CREATE_ON_DEST_COLLECTED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_CS_START

local arg_data = {
    ['ability'] = {'__ability','skill'},
    ['cast'] = {'__ability_runtime_id','other'}
}

EVENT_DATA.ET_ABILITY_CS_START = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_PS_START

local arg_data = {
    ['ability'] = {'__ability','skill'},
    ['cast'] = {'__ability_runtime_id','other'}
}

EVENT_DATA.ET_ABILITY_PS_START = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_PS_END

local arg_data = {
    ['ability'] = {'__ability','skill'},
    ['cast'] = {'__ability_runtime_id','other'}
}

EVENT_DATA.ET_ABILITY_PS_END = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_SP_END

local arg_data = {
    ['ability'] = {'__ability','skill'},
    ['cast'] = {'__ability_runtime_id','other'}
}

EVENT_DATA.ET_ABILITY_SP_END = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_CST_END

local arg_data = {
    ['ability'] = {'__ability','skill'},
    ['cast'] = {'__ability_runtime_id','other'}
}

EVENT_DATA.ET_ABILITY_CST_END = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_BS_END

local arg_data = {
    ['ability'] = {'__ability','skill'},
    ['cast'] = {'__ability_runtime_id','other'}
}

EVENT_DATA.ET_ABILITY_BS_END = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_PS_INTERRUPT

local arg_data = {
    ['ability'] = {'__ability','skill'},
    ['cast'] = {'__ability_runtime_id','other'}
}

EVENT_DATA.ET_ABILITY_PS_INTERRUPT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_SP_INTERRUPT

local arg_data = {
    ['ability'] = {'__ability','skill'},
    ['cast'] = {'__ability_runtime_id','other'}
}

EVENT_DATA.ET_ABILITY_SP_INTERRUPT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_CST_INTERRUPT

local arg_data = {
    ['ability'] = {'__ability','skill'},
    ['cast'] = {'__ability_runtime_id','other'}
}

EVENT_DATA.ET_ABILITY_CST_INTERRUPT = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_END

local arg_data = {
    ['ability'] = {'__ability','skill'},
    ['cast'] = {'__ability_runtime_id','other'}
}

EVENT_DATA.ET_ABILITY_END = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end


---@class EVENT_DATA.ET_ABILITY_OBTAIN

local arg_data = {
    ['ability'] = {'__ability','skill'}
}

EVENT_DATA.ET_ABILITY_OBTAIN = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_LOSE

local arg_data = {
    ['ability'] = {'__ability','skill'}
}

EVENT_DATA.ET_ABILITY_LOSE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_UPGRADE

local arg_data = {
    ['ability'] = {'__ability','skill'}
}

EVENT_DATA.ET_ABILITY_UPGRADE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_CD_END

local arg_data = {
    ['ability'] = {'__ability','skill'}
}

EVENT_DATA.ET_ABILITY_CD_END = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_DISABLE

local arg_data = {
    ['ability'] = {'__ability','skill'}
}

EVENT_DATA.ET_ABILITY_DISABLE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_ENABLE

local arg_data = {
    ['ability'] = {'__ability','skill'}
}

EVENT_DATA.ET_ABILITY_ENABLE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ABILITY_SWITCH

local arg_data = {
    ['ability'] = {'__ability','skill'}
}

EVENT_DATA.ET_ABILITY_SWITCH = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_OBTAIN_MODIFIER

local arg_data = {
    ['modifier'] = {'__modifier','buff'},
    ['owner_unit'] = {'__owner_unit','unit'},
    ['source_unit'] = {'__from_unit_id','unit'},
}

EVENT_DATA.ET_OBTAIN_MODIFIER = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_LOSS_MODIFIER

local arg_data = {
    ['modifier'] = {'__modifier','buff'},
    ['owner_unit'] = {'__owner_unit','unit'},
    ['source_unit'] = {'__from_unit_id','unit'},
}

EVENT_DATA.ET_LOSS_MODIFIER = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_MODIFIER_CYCLE_TRIGGER

local arg_data = {
    ['modifier'] = {'__modifier','buff'},
    ['owner_unit'] = {'__owner_unit','unit'},
    ['source_unit'] = {'__from_unit_id','unit'},
}

EVENT_DATA.ET_MODIFIER_CYCLE_TRIGGER = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_MODIFIER_LAYER_CHANGE

local arg_data = {
    ['modifier'] = {'__modifier','buff'},
    ['cnt'] = {'__layer_change_values','other'},
    ['owner_unit'] = {'__owner_unit','unit'},
    ['source_unit'] = {'__from_unit_id','unit'},
}

EVENT_DATA.ET_MODIFIER_LAYER_CHANGE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_MODIFIER_GET_BEFORE_CREATE

local arg_data = {
    ['modifier'] = {'__modifier','buff'},
    ['owner_unit'] = {'__owner_unit','unit'},
    ['source_unit'] = {'__from_unit_id','unit'},
}

EVENT_DATA.ET_MODIFIER_GET_BEFORE_CREATE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_MODIFIER_BE_COVERED

local arg_data = {
    ['new_modifier'] = {'__new_modifier','buff'},
    ['old_modifier'] = {'__old_modifier','buff'},
    ['owner_unit'] = {'__owner_unit','unit'},
}

EVENT_DATA.ET_MODIFIER_BE_COVERED = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ROLE_HOLD_STORE_ITEM

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['store_item'] = {'__store_key','other'},
}

EVENT_DATA.ET_ROLE_HOLD_STORE_ITEM = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_ROLE_USE_STORE_ITEM_END

local arg_data = {
    ['player'] = {'__role_id','player'},
    ['store_item'] = {'__store_key','other'},
    ['cnt'] = {'__use_cnt','other'}
}

EVENT_DATA.ET_ROLE_USE_STORE_ITEM_END = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_DEST_CREATE_NEW

local arg_data = {
    ['destructible'] = {'__destructible_id','destructible'},
}

EVENT_DATA.ET_DEST_CREATE_NEW = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_DEST_DIE_NEW

local arg_data = {
    ['destructible'] = {'__destructible_id','destructible'},
    ['killer'] = {'__unit_id_of_dest_killer','unit'}
}

EVENT_DATA.ET_DEST_DIE_NEW = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_DEST_REVIVE_NEW

local arg_data = {
    ['destructible'] = {'__destructible_id','destructible'},
}

EVENT_DATA.ET_DEST_REVIVE_NEW = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_DEST_RES_CNT_CHG_NEW

local arg_data = {
    ['destructible'] = {'__destructible_id','destructible'},
    ['cnt'] = {'__res_chg_cnt_in_dest_event','number'}
}

EVENT_DATA.ET_DEST_RES_CNT_CHG_NEW = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_DEST_COLLECTED_NEW
local arg_data = {
    ['destructible'] = {'__destructible_id','destructible'},
    ['unit'] = {'__unit_id_in_dest_event','unit'},
    ['ability'] = {'__ability_in_dest_event','skill'},
    ['cnt'] = {'__role_res_cnt_in_event','number'}
}

EVENT_DATA.ET_DEST_COLLECTED_NEW = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_GET_HURT_NEW
local arg_data = {
    ['destructible'] = {'__destructible_id','destructible'},
    ['unit'] = {'__unit_id_of_hurt_dest','unit'},
    ['damage'] = {'__damage_value_of_hurt_dest','number'}
}

EVENT_DATA.ET_GET_HURT_NEW = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            if type(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])) == "number" then
                return math.abs(enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]]))
            else
                return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
            end
        else 
            return nil
        end 
    end})
    return mytable
end


---@class EVENT_DATA.ET_DEST_DELETE
local arg_data = {
    ['destructible'] = {'__destructible_id','destructible'},
}

EVENT_DATA.ET_DEST_DELETE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end




---******投射物

---@class EVENT_DATA.ET_PRODUCE_PROJECTILE

local arg_data = {
    ['projectile'] = {'projectile','projectile'},
}

EVENT_DATA.ET_PRODUCE_PROJECTILE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end

---@class EVENT_DATA.ET_DEATH_PROJECTILE

local arg_data = {
    ['projectile'] = {'projectile','projectile'},
}

EVENT_DATA.ET_DEATH_PROJECTILE = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end


---@class EVENT_DATA.ET_UNIT_ON_COMMANDET_UNIT_ON_COMMAND

local arg_data = {
    ['unit'] = {'__unit_id','unit'},
    ['cmd_type'] = {'__cmd_type','cmd'},
    ['target_unit'] = {'__target_unit','unit'},
    ['point'] = {'__point','point'},
    ['destructible'] = {'__destructible_id','destructible'},
    ['item'] = {'__item_id','item'},
}

-- (EParams.UNIT_ID, EType.UnitID, "单位"),
-- (EParams.CMD_TYPE, EType.UnitCommand, "接收的命令"),
-- (EParams.TARGET_UNIT, EType.Unit, "目标单位"),
-- (EParams.POINT, EType.Point, "目标点"),
-- (EParams.DESTRUCTIBLE_ID, EType.DestructibleID, "目标可破坏物ID"),
-- (EParams.ITEM_ID, EType.ItemID, "目标物品ID"),
EVENT_DATA.ET_UNIT_ON_COMMAND = function (data)
    local a= {}
    a.data = data
    local mytable = setmetatable(a,
	{__index = function(mytable,key)
        if arg_data[key] then 
            return enum_f[arg_data[key][2]](mytable.data[arg_data[key][1]])
        else 
            return nil
        end 
    end})
    return mytable
end