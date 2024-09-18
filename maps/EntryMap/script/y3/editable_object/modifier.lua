--- File Name : modifier.lua
--- Description: 魔法效果相关逻辑 对应编辑器---魔法效果

local setmetatable = setmetatable
local ipairs = ipairs

---@class modifier
local modifier = {}
modifier.__index = modifier
y3.modifier = modifier
modifier.type = 'modifier'
---所有魔法效果实例
local Modifiers = setmetatable({}, { __mode = 'kv' })
---所有触发器组
local TriggerGroups = {}

---@param group table 物编触发器组
---@param modifier_id number 物编魔法效果id
---初始化物编触发器组
local function trigger_group_init(group, modifier_id)
    group.add_trigger = function(event_name, action)
        -- local enum, params = event_manager.get_enum_and_params(event_name, event_enum.modifier)
        local trigger_id = y3.trigger.get_trigger_id()
        local py_trigger = new_modifier_trigger(modifier_id, trigger_id, event_name, event_name, true)
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

---@param modifier_id number 物编魔法效果id
---@return trigger_group 触发器组
---按照道具id创建道具触发器组
function modifier.create_modifier_trigger_group(modifier_id)
    if not TriggerGroups[modifier_id] then
        TriggerGroups[modifier_id] = {}
        trigger_group_init(TriggerGroups[modifier_id], modifier_id)
    end
    return TriggerGroups[modifier_id]
end

---@param  py_modifier table py层的魔法效果实例
---@return table 返回在lua层初始化后的lua层魔法效果实例
---通过py层的魔法效果实例获取lua层的魔法效果实例
function modifier.get_lua_modifier_from_py(py_modifier)
    if not py_modifier then
        return
    end
    local py = py_obj.new(py_modifier)
    local id = py_modifier:api_get_modifier_unique_id()
    if not Modifiers[id] then
        local new_modifier = {}
        setmetatable(new_modifier, modifier)
        new_modifier.base = py
        new_modifier.id = id
        Modifiers[id] = new_modifier
    end
    return Modifiers[id]
end


---@param tag string 标签
---是否具有标签
function modifier:has_tag(tag)
    return global_api.has_tag(self.base(), tag)
end

---@return boolean is_visible 是否可见
---魔法效果的图标是否可见
function modifier:icon_is_visible()
    return self.base():api_get_icon_is_visible()
end

---移除
function modifier:remove()
    self.base():api_remove()
end

---@return boolean is_exist 是否存在
---是否存在
function modifier:is_destory()
    return  game_api.modifier_is_exist(self.base())
end

---@param name string 名字
---设置魔法效果的名称
function modifier:set_name(name)
    self.base():api_set_buff_str_attr("name_str", name)
end

---@param description string 描述
---设置魔法效果对象的描述
function modifier:set_description(description)
    self.base():api_set_buff_str_attr("description", description)
end

---@param time number 剩余持续时间
---设置剩余持续时间
function modifier:set_time(time)
    self.base():api_set_buff_residue_time(Fix32(time))
end

---@param time number 剩余持续时间
---增加剩余持续时间
function modifier:add_time(time)
    self.base():api_add_buff_residue_time(Fix32(time))
end

---@param stack number 层数
---设置堆叠层数
function modifier:set_stack(stack)
    self.base():api_set_buff_layer(stack)
end

---@param stack number 层数
---增加堆叠层数
function modifier:add_stack(stack)
    self.base():api_add_buff_layer(stack)
end

---@param value number 护盾值
---设置护盾值
function modifier:set_shield(value)
    self.base():api_set_float_shield("cur_properties_shield", Fix32(value))
end

---@param value number 护盾值
---增加护盾值
function modifier:add_shield(value)
    self.base():api_add_float_shield("cur_properties_shield", Fix32(value))
end

---@return number stack 层数
---获取魔法效果的堆叠层数
function modifier:get_stack()
    return self.base():api_get_modifier_layer()
end

---@return number time 剩余持续时间
---获取魔法效果的剩余持续时间
function modifier:get_time()
    return self.base():api_get_residue_time()
end

---@return number type 魔法效果类型 
---获取魔法效果类型
function modifier:get_modifier_type()
    return self.base():api_get_modifier_type("modifier_type")
end

--TODO:需要确认这里的硬性类型在lua中怎么表示
---@return number type 魔法效果影响类型  
---获取魔法效果影响类型  
function modifier:get_modifier_effect_type()
    return self.base():api_get_modifier_effect_type("modifier_effect")
end

---@return number stack 层数
---获取魔法效果的最大堆叠层数
function modifier:get_max_stack()
    return self.base():api_get_int_attr("layer_max")
end

---@return number shield 护盾值
---获取魔法效果的护盾
function modifier:get_shield()
    return self.base():api_get_float_attr("cur_properties_shield")
end

---@return modifier aura 所属光环
---获取所属光环
function modifier:get_aura()
    local py_modifier = self.base():api_get_halo_modifier_instance()
    return y3.modifier.get_lua_item_from_py(py_modifier)
end

---@return number time 循环周期
---获取魔法效果循环周期
function modifier:get_cycle_time()
    return self.base():api_get_cycle_time()
end

---@return number duration 持续时间
---魔法效果的已持续时间
function modifier:get_passed_time()
    return self.base():api_get_passed_time()
end

---@return number type 光环效果类型
---获取魔法效果的光环效果类型
function modifier:get_modifier_aura_effect_type()
    return self.base():api_get_sub_halo_modifier_key()
end

---@return number range 光环范围
---获取魔法效果的光环范围
function modifier:get_modifier_aura_range()
    return self.base():api_get_halo_inf_rng()
end

---@return unit provider 施加者
---获取魔法效果的施加者
function modifier:get_source()
    local py_unit = self.base():api_get_releaser()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return unit receiver 携带者
---获取魔法效果的携带者
function modifier:get_owner()
    local py_unit = self.base():api_get_owner()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return string name 名字
---获取魔法效果对象的名称
function modifier:get_name()
    return self.base():api_get_str_attr("name_str")
end

---@return string description 描述
---获取魔法效果对象的描述
function modifier:get_description()
    return self.base():api_get_str_attr("description")
end

---@return number level 等级
---获取等级
function modifier:get_level()
    return self.base():api_get_modifier_level()
end

---@param modifier_type number 类型
---@return boolean is_visible 是否可见
---魔法效果类型的图标是否可见
function modifier.modifier_type_icon_is_visible(modifier_type)
    return game_api.is_show_on_ui_by_buff_type(modifier_type)
end

---@param modifier modifier 魔法效果
---@return number type 类别
---获得魔法效果的类别
function modifier.get_type_of_modifier_entity(modifier)
    return game_api.get_type_of_modifier_entity(modifier.base())
end

---@param modifier_type number 类型
---@return string description 描述
---获取魔法效果类型的描述
function modifier.get_modifier_type_description(modifier_type)
    return game_api.get_modifier_desc_by_type(modifier_type)
end

---@param modifier_type number 类型
---@return number 图片id
---获取魔法效果类型的icon图标的图片
function modifier.get_image_of_modifier_type_icon(modifier_type)
    return game_api.get_icon_id_by_buff_type(modifier_type)
end


---@param object projectile|modifier 投射物或魔法效果 
---@return ability ability 投射物或魔法效果的关联技能
---获得关联技能
function modifier:get_ability()
    local py_ability = globalapi.get_related_ability(self.base())
    if py_ability then
        return y3.ability.get_lua_ability_from_py(py_ability)
    end
    return nil
end

---@param range number 影响范围
---增加魔法效果光环影响范围
function modifier:add_influence_range(range)
    self.base():api_add_modifier_halo_influence_rng(range)
end

---@param range number 影响范围
---设置魔法效果光环影响范围
function modifier:set_influence_range(range)
    self.base():api_set_modifier_halo_influence_rng(range)
end

---@param img number 影响范围
---设置魔法效果图标
function modifier:set_icon(img)
    self.base():api_set_modifier_icon(img)
end

---@param new_cycle_time number 循环周期
---设置魔法效果循环周期
function modifier:set_cycle_time(new_cycle_time)
    self.base():api_set_cycle_time(Fix32(new_cycle_time))
end