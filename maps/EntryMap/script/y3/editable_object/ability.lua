--- File Name : ability.lua
--- Description: 技能相关逻辑 对应编辑器---技能

local setmetatable = setmetatable
local ipairs = ipairs


---@class ability
local ability = {}
ability.__index = ability
y3.ability = ability

---所有技能实例
local Abilities = {}
---所有触发器组
local TriggerGroups = {}

---@param group table 物编触发器组
---@param ability_id number 物编技能id
---初始化物编触发器组
local function trigger_group_init(group, ability_id)
    group.add_trigger = function(event_name, action)
        local trigger_id = y3.trigger.get_trigger_id()
        local py_trigger = new_ability_trigger(ability_id, trigger_id, event_name, event_name, true)
        function py_trigger.on_event(trigger, event, actor, data)
            --local lua_data = event_manager.get_lua_params(params, data)
            if EVENT_DATA[event_name] then
                action(EVENT_DATA[event_name](data))
            else
                action(data)
            end
        end
    end
end


---@param ability_id number 物编技能id
---@return trigger_group trigger_group 触发器组
---按照技能id创建技能触发器组
function ability.create_ability_trigger_group(ability_id)
    if not TriggerGroups[ability_id] then
        TriggerGroups[ability_id] = {}
        trigger_group_init(TriggerGroups[ability_id], ability_id)
    end
    return TriggerGroups[ability_id]
end


---@param  py_ability table py层的技能实例
---@return ability ability 返回在lua层初始化后的lua层技能实例
---通过py层的技能实例获取lua层的技能实例
function ability.get_lua_ability_from_py(py_ability)
    if not py_ability then
        return
    end
    if py_ability:api_is_destroyed() then 
        return nil 
    end
    local py = py_obj.new(py_ability)
    local data = {}
    local id = py_ability:api_get_ability_id()
    local owner = py_ability:api_get_owner():api_get_id()
    local seq_id = py_ability:api_get_ability_seq()
    if Abilities[owner] then
        if Abilities[owner][seq_id] then
            return Abilities[owner][seq_id]
        end
    else
        Abilities[owner] = {}
    end
    local skill = setmetatable(data, ability)
    skill.base = py
    skill.id = id
    Abilities[owner][seq_id] = skill
    -- skill:add_trigger("Casting stops", function()
        
    --     Abilities[id] = nil
    -- end)
    return Abilities[owner][seq_id]
end


---@return boolean is_influenced 是否受冷却缩减影响
---是否受冷却缩减影响
function ability:is_cd_reduce()
    return self.base():api_get_influenced_by_cd_reduce()
end

---@return boolean is_cost 消耗生命是否会死亡
---消耗生命是否会死亡
function ability:is_cost_hp_can_die()
    return self.base():api_get_cost_hp_can_die()
end


---@return boolean is_can_cast 生命不足是否可以释放
---生命不足是否可以释放
function ability:is_can_cast_when_hp_insufficient()
    return self.base():api_get_can_cast_when_hp_insufficient()
end


---@param tag string 标签
---是否具有标签
function ability:has_tag(tag)
    return globalapi.has_tag(self.base(),tag)
end

---启用技能
function ability:enable()
    self.base():api_enable()
end

---禁用技能
function ability:disable()
    self.base():api_disable()
end

---进入冷却
function ability:restart_cd()
    self.base():api_restart_cd()
end

---完成冷却
function ability:complete_cd()
    self.base():api_immediately_clear_cd()
end

---移除技能
function ability:remove()
    self.base():api_remove()
end

---@param level number 等级
---设置技能等级
function ability:set_level(level)
    self.base():api_set_level(Fix32(level))
end


---@param value number 冷却
---增加冷却时间
function ability:add_cd(value)
    self.base():api_change_ability_cd_cold_down(Fix32(value))
end

---@param value number 等级
---设置充能层数
function ability:set_stack(value)
    self.base():api_set_ability_stack_count(value)
end

function ability:get_name()
    return self.base():api_get_name()
end


---@param key string 属性key                  
---@param value number 属性值
---设置实数属性
function ability:set_float_attr(key, value)
    self.base():api_set_float_attr(key, Fix32(value))
end

---@param key string 属性key                   
---@param value number 属性值
---设置整数属性
function ability:set_int_attr(key, value)
    self.base():api_set_int_attr(key, Fix32(value))
end


---@param value number 剩余冷却时间
---设置剩余冷却时间
function ability:set_cd(value)
    self.base():api_set_ability_cd(Fix32(value))
end

---@param value number 等级
---增加技能等级
function ability:add_level(value)
    self.base():api_add_level(Fix32(value))
end


---@param value number 层数
---增加技能充能层数
function ability:add_stack(value)
    self.base():api_add_ability_stack_count(value)
end

---@param value number 剩余冷却时间
---增加技能剩余冷却时间
function ability:add_remaining_cd(value)
    self.base():api_add_ability_cd(Fix32(value))
end

---@param key string 属性key                    
---@param value number 属性值
---增加实数属性
function ability:add_float_attr(key, value)
    self.base():api_add_float_attr(key, Fix32(value))
end

---@param key string 属性key             
---@param value number 属性值
---增加整数属性
function ability:add_int_attr(key, value)
    self.base():api_add_int_attr(key, Fix32(value))
end

---@param name string 技能名字
---设置技能名字
function ability:set_name(name)
    self.base():api_set_name(name)
end

---@param des string 描述
---设置技能描述
function ability:set_description(des)
    self.base():api_set_str_attr("desc", des)
end

---学习技能
function ability:learn()
    self.base():api_learn_ability()
end

---@param value number 剩余充能时间
---设置技能剩余充能时间
function ability:set_charge_time(value)
    self.base():api_set_ability_cur_stack_cd(Fix32(value))
end

---@param value number 施法范围
---设置技能施法范围
function ability:set_range(value)
    self.base():api_set_ability_cast_range(Fix32(value))
end

---@return value number 施法范围
---设置技能施法范围
function ability:get_range()
    return self.base():api_get_ability_cast_range()
end


---@param key number 属性key
---@param value number 属性值
---设置技能玩家属性消耗
function ability:set_player_attr_cost(key, value)
    self.base():api_set_ability_player_attr_cost(key, Fix32(value))
end

---@param key number 属性key
---@param value number 属性值
---增加技能玩家属性消耗
function ability:add_player_attr_cost(key, value)
    self.base():api_add_ability_player_attr_cost(key, Fix32(value))
end

---@param is_influenced boolean 属性key
---设置技能是否受冷却缩减的影响
function ability:set_cd_reduce(is_influenced)
    self.base():api_set_influenced_by_cd_reduce(is_influenced)
end

---@param is_can_die boolean 是否会死亡
---设置消耗生命是否会死亡
function ability:set_is_cost_hp_can_die(is_can_die)
    self.base():api_set_cost_hp_can_die(is_can_die)
end

---@param is_can_cast boolean 是否可以释放
---设置生命不足时是否可以释放技能
function ability:set_can_cast_when_hp_insufficient(is_can_cast)
    self.base():api_set_can_cast_when_hp_insufficient(is_can_cast)
end

---@param value number 半径
---设置扇形指示器半径
function ability:set_sector_indicator_radius(value)
    self.base():api_set_ability_sector_radius(Fix32(value))
end

---@param value number 角度
---设置扇形指示器夹角
function ability:set_indicator_angle(value)
    self.base():api_set_ability_sector_angle(Fix32(value))
end

---@param value number 长度
---设置箭头/多段指示器长度
function ability:set_indicator_length(value)
    self.base():api_set_ability_arrow_length(Fix32(value))
end

---@param value number 宽度
---设置箭头/多段指示器宽度
function ability:set_indicator_width(value)
    self.base():api_set_ability_arrow_width(Fix32(value))
end


---@param value number 半径
---设置箭圆形指示器半径
function ability:set_indicator_radius(value)
    self.base():api_set_ability_circle_radius(Fix32(value))
end

---@param type integer 技能指示器类型
---设置技能指示器类型
function ability:set_indicator_type(type)
    self.base():api_set_ability_pointer_type(type)
end

---获取技能当前剩余充能时间
function ability:get_charge_time()
    return self.base():api_get_stack_cd_left_time():float()
end

---@return string type 技能种类
---获取技能种类 见AbilityTypeId
function ability:get_type()
    return AbilityTypeId[self.base():api_get_type()]
end

---@return number ability_id 技能类型id(物编id)
---获取技能类型id(物编id)
function ability:get_ability_type()
    return self.base():api_get_ability_id()
end

---@return number index 技能所在技能位
---获取技能所在技能位
function ability:get_slot()
    return self.base():api_get_ability_index()
end

---@param key string 属性key
---@return number cost 玩家属性值
---获取技能消耗的玩家属性值
function ability:get_player_attr_cost(key)
    return self.base():api_get_ability_player_attr_cost(key):float()
end

---@return string type 技能释放类型
---获取技能释放类型 AbilityCastType
function ability:get_cast_type()
    return self.base():api_get_ability_cast_type()
end

---@param key string 键值key
---@return number value 值
---获取技能公式类型的kv
function ability:get_formula_kv(key)
    return self.base():api_calc_ability_formula_kv(key):float()
end

---@param key string 键值key
---@return number value 值
---获取实数属性
function ability:get_float_attr(key)
    return self.base():api_get_float_attr(key):float()
end

---@param key string 键值key
---@return number value 值
---获取整数属性
function ability:get_int_attr(key)
    return self.base():api_get_int_attr(key)
end

---@param key string 键值key
---@return string value 值
---获取字符串属性
function ability:get_string_attr(key)
    return self.base():api_get_str_attr(key)
end

---@return unit owner 技能拥有者
---获取技能的拥有者
function ability:get_owner()
    local py_unit = self.base():api_get_owner()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return number time 当前冷却时间
---获取当前冷却时间
function ability:get_cd()
    return self.base():api_get_cd_left_time():float()
end

---@return boolean is_exist 是否存在
---是否存在
function ability:is_destory()
    return  game_api.ability_is_exist(self.base())
end

function ability:get_target(cast)
    local u = gameapi.get_target_unit_in_ability(self.base(),cast)
    if u then
        return y3.unit.get_lua_unit_from_py(u)
    end
    local dest = gameapi.get_target_dest_in_ability(self.base(), cast)
    if dest then
        return y3.destructible.get_lua_destructible_from_py(dest)
    end
    local item = gameapi.get_target_item_in_ability(self.base(),cast)
    if item then
        return y3.item.get_lua_item_from_py(item)
    end
    local p = self.base():api_get_release_position(cast)
    if p then
        return y3.get_lua_point_from_py(p)
    end
end

function ability:get_angle(cast)
    local angle = self.base():api_get_release_direction(cast)
    if angle then
        return angle
    end
end

---@param data table 触发器回调函数中的data
---@return item target_item 目标物品  
---技能选取的目标物品  
function ability:ability_selected_target_item(data)
    local py_item = gameapi.get_target_item_in_ability(self.base(), data['__ability_runtime_id'])
    return y3.item.get_lua_item_from_py(py_item)
end

---@param data table 触发器回调函数中的data
---@return unit target_unit 目标单位  
---技能选取的目标单位  
function ability:ability_selected_target_unit(data)
    local py_unit = gameapi.get_target_unit_in_ability(self.base(), data['__ability_runtime_id'])
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param data table 触发器回调函数中的data
---@return destructible destructible 目标可破坏物
---技能选取的目标可破坏物
function ability:ability_selected_destructible(data)
    local py_destructible = gameapi.get_target_dest_in_ability(self.base(), data['__ability_runtime_id'])
    return y3.destructible.get_lua_destructible_from_py(py_destructible)
end

---@param data table 触发器回调函数中的data
---@return point point 选取到的点
---技能选取到的点
function ability:selected_location_by_ability(data)
    local py_point = self.base():api_get_release_position(data['__ability_runtime_id'])
    return y3.get_lua_point_from_py(py_point)
end

---@param data table 触发器回调函数中的data
---@return number direction 释放方向 
---获取技能释放方向 
function ability:get_ability_cast_direction(data)
    return self.base():api_get_release_direction(data['__ability_runtime_id'])
end

---@param player player 玩家
---@param ability ability 技能
---显示技能指示器
function ability:show_indicator(player)
    game_api.create_preview_skill_pointer(player.base(), self.base())
end

--------------------------------------------------------类的方法--------------------------------------------------------



---@param data table 触发器回调函数中的data
---@return ability ability 事件中的技能 
---获取事件中的技能 
function ability.get_ability_by_unit_and_seq(data)
    local py_ability = gameapi.api_get_ability_by_unit_and_seq(data['__unit_id'], data['__ability_seq'])
    return y3.ability.get_lua_ability_from_py(py_ability)
end

---@param player player 玩家
---@param type_id number 技能类型id (物编id)
---@return boolean is_meet 技能类型前置条件是否满足
---检查技能类型前置条件
function ability.check_ability_key_precondition(player, type_id)
    return game_api.check_ability_key_precondition(player.base(), type_id)
end

---@param type_id number 技能类型id (物编id)
---@return boolean is_influenced 技能类型是否受冷却缩减影响
---技能类型是否受冷却缩减影响
function ability.is_ability_type_influenced_by_cd_reduce(type_id)
    return game_api.api_get_influenced_by_cd_reduce(type_id)
end

---@param type_id number 技能类型id (物编id)
---@param key string 键值key
---@return number value 值
---获取技能类型实数属性
function ability.get_ability_type_float_attr(type_id,key)
    return game_api.get_ability_conf_float_attr(type_id,key):float()
end

---@param type_id number 技能类型id (物编id)
---@param key string 键值key
---@return number value 值
---获取技能类型整数属性
function ability.get_ability_type_int_attr(type_id,key)
    return game_api.get_ability_conf_int_attr(type_id,key)
end


---@param player player 玩家
---@param state boolean 状态 开/关
---设置玩家的普攻预览状态
function ability.set_normal_attack_preview_state(player, state)
    game_api.set_preview_common_atk_range(player.base(), state)
end

---@param player player 玩家
---@param state boolean 状态 开/关
---设置玩家的指示器在智能施法时是否显示
function ability.set_smart_cast_with_indicator(player, state)
    game_api.set_smart_cast_with_pointer(player.base(), state)
end

---@param player player 玩家
---关闭技能指示器
function ability.hide_indicator(player)
    game_api.clear_preview_skill_pointer(player.base())
end

---@return number id 图片ID
---获取技能类型的icon图标的图片ID
function ability.get_icon(type_id)
    return game_api.get_icon_id_by_ability_type(type_id)
end

---@param enable boolean 开关
---开关自动施法
function ability:set_autocast(enable)
    self.base():api_set_autocast_enabled(enable)
end

---@param ability_id number 技能类型id(物编id)
---@param attr_name string 属性名称
---@param level number 技能等级
---@param stack_count number 技能层数
---@param unit_hp_max number 单位最大生命
---@param unit_hp_cur number 单位当前生命
---@return number value 值
---获取技能类型公式属性
function ability.get_ability_type_formula_attr(ability_id, attr_name, level, stack_count, unit_hp_max, unit_hp_cur)
    return game_api.get_ability_conf_formula_attr(ability_id, attr_name, level, stack_count, unit_hp_max, unit_hp_cur):float()
end

---@param type_id number 技能类型id (物编id)
---@param key string 键值key
---@return string str 值
---获取技能类型字符串属性
function ability.get_ability_type_str_attr(type_id,key)
    return game_api.get_ability_conf_str_attr(type_id,key)
end

---@param icon_id integer 图片id
---设置技能图标
function ability:set_icon(icon_id)
    self.base():api_set_ability_icon(icon_id)
end

---@param angle number 角度
---设置技能的建造朝向
function ability:set_build_rotate(angle)
    self.base():api_set_ability_build_rotate(Fix32(angle))
end

---获取技能的指示器类型
function ability:get_skill_pointer()
    return self.base():api_get_ability_skill_pointer()
end

---获取技能类型的指示器类型
function ability.get_skill_type_pointer(name)
    return game_api.get_ability_key_skill_pointer(name)
end

---@param ability_key number 技能类型
---获取技能类型的前置条件列表
function ability.get_ability_precondition(ability_key,data)
    data[const.IterKey.ITER_PRE_CONDITION] = game_api.get_ability_key_precondition_list(ability_key)
    local lua_table = {}
    for i = 0, python_len(data[const.IterKey.ITER_PRE_CONDITION])-1 do
        local key = python_index(py_list,i)
        table.insert(lua_table,key)
    end
    return lua_table
end

---@return number level 等级
function ability:get_unit_upgrade_level()
    return self.base():api_get_ability_nearest_upgradable_unit_level()
end

---@return integer id 技能id
---获取技能全局唯一ID
function ability:get_id()
    return self.base():api_get_ability_global_id()
end

---@return integer id 技能id
---当前技能是否可以自动施法
function ability:is_autocast()
    return self.base():api_is_autocast_enabled()
end