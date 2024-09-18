--- File Name : destructible.lua
--- Description: 可破坏物

local setmetatable = setmetatable
---@class destructible
local destructible = {}
destructible.__index = destructible
y3.destructible = destructible
destructible.type = 'destructible'
---所有物品实例
local Destructibles = setmetatable({}, { __mode = 'kv' })
---所有触发器组
local TriggerGroups = {}

---@param scene_id number 场景Id
---@return item lua层item
---根据场景id得到item实例
function y3.get_destructible_by_scene_id(scene_id)
    local py_destructible = game_api.get_dest_by_id(scene_id)
    return y3.destructible.get_lua_destructible_from_py(py_destructible)
end

---@param group table 物编触发器组
---@param destructible_id number 物编平台道具id
---初始化物编触发器组
local function trigger_group_init(group, destructible_id)
    group.add_trigger = function(event_name, action)
        -- local enum, params = event_manager.get_enum_and_params(event_name, event_enum.destructible)
        local trigger_id = y3.trigger.get_trigger_id()
        local py_trigger = new_destructible_trigger(destructible_id, trigger_id, event_name, event_name, true)
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

---@param destructible_id number 物编道具id
---@return trigger_group 触发器组
---按照道具id创建道具触发器组
function destructible.create_destructible_trigger_group(destructible_id)
    if not TriggerGroups[destructible_id] then
        TriggerGroups[destructible_id] = {}
        trigger_group_init(TriggerGroups[destructible_id], destructible_id)
    end
    return TriggerGroups[destructible_id]
end

---@param  py_destructible table py层实例
---@return table 返回在lua层初始化后的lua层实例
---通过py层的技能实例获取lua层的道具实例
function destructible.get_lua_destructible_from_py(py_destructible)
    if not py_destructible then
        return
    end
    --TODO:获取id的api不知道是不是这个，要再确认
    local id 
    if type(py_destructible) == 'number' then
        id = py_destructible
        py_destructible = game_api.get_dest_by_id(py_destructible)
    else
        id = py_destructible.api_get_id()
    end
    local py = py_obj.new(py_destructible)
    if not Destructibles[id] then
        local new_destructible = {}
        setmetatable(new_destructible, destructible)
        new_destructible.base = py
        new_destructible.id = id
        Destructibles[id] = new_destructible
    end
    return Destructibles[id]
end

---@param event_name string 事件名
---@param action function 事件触发时执行的方法
---添加触发器
function destructible:add_trigger(event_name, action)
    local enum, params = event_manager.get_enum_and_params(event_name, event_enum.destructible)
    local trigger_id = y3.get_trigger_id()
    local py_trigger = new_global_trigger(trigger_id, event_name, enum, true)
    py_trigger.event.get_target = function(trigger, actor)
        return self.base()
    end
    py_trigger.event.target_type = "Unit"
    function py_trigger.on_event(trigger, event, actor, data)
        --local lua_data = event_manager.get_lua_params(params, data)
        action(data)
    end
end


---@return boolean is_exist 是否存在
---是否存在
function destructible:is_destory()
    return  game_api.destructible_is_exist(self.base())
end

---@return boolean is_lockable 能否被选中
---可破坏物能否被技能指示器选中
function destructible:is_lockable_by_ability()
    return self.base():api_is_ability_target()
end

---@return boolean is_attackable 能否被攻击
---可破坏物能否被攻击
function destructible:is_attackable()
    return self.base():api_is_attacked()
end

---@return boolean is_selectable 能否被选中
---可破坏物能否被选中
function destructible:is_selectable()
    return self.base():api_is_selected()
end

---@return boolean is_selectable 能否被选中
---可破坏物能否被采集
function destructible:is_collectable()
    return self.base():api_is_collected()
end

---@return boolean is_visible 是否可见
---可破坏物是否可见
function destructible:is_visible()
    return self.base():api_is_visible()
end

---@return boolean is_alive 是否存活
---可破坏物是否存活
function destructible:is_alive()
    return self.base():api_is_alive()
end

---@param tag string 标签
---@return boolean is_has_tag 是否具有标签
---是否具有标签
function destructible:has_tag(tag)
    return global_api.has_tag(self.base(), tag)
end

---@param killer_unit unit 凶手
---杀死可破坏物
function destructible:destroy(killer_unit)
    self.base():api_kill(killer_unit.base())
end

---@param killer_unit unit 凶手
---杀死可破坏物
function destructible:kill(killer_unit)
    self.base():api_kill(killer_unit.base())
end

---复活可破坏物
function destructible:resurrect()
    self.base():api_revivie_new()
end

---删除可破坏物
function destructible:remove()
    self.base():api_delete()
end

---复活可破坏物
function destructible:reborn()
    self.base():api_revivie_new()
end

---@param point point 目标点
---移动到点
function destructible:set_point(point)
    self.base():api_transmit(point.base())
end

---@param value number 生命值
---设置生命值
function destructible:set_hp(value)
    self.base():api_set_hp(Fix32(value))
end

---@param value number 生命值
---增加当前生命值
function destructible:add_hp(value)
    self.base():api_add_hp_cur_value(Fix32(value))
end

---@param value number 生命值
---设置最大生命值
function destructible:set_max_hp(value)
    self.base():api_set_max_hp(Fix32(value))
end

---@param value number 生命值
---增加最大生命值
function destructible:add_max_hp(value)
    self.base():api_add_hp_max_value(Fix32(value))
end

---@param value number 资源数
---设置当前资源数
function destructible:set_resource(value)
    self.base():api_set_cur_source_nums(Fix32(value))
end

---@param value number 资源数
---增加当前资源数
function destructible:add_resource(value)
    self.base():api_add_sp_cur_value(Fix32(value))
end

---@param value number 资源数
---设置最大资源数
function destructible:set_max_resource(value)
    self.base():api_set_max_source_nums(Fix32(value))
end

---@param value number 资源数
---增加最大资源数
function destructible:add_max_resource(value)
    self.base():api_add_sp_max_value(Fix32(value))
end

---@param name string 名字
---设置名称
function destructible:set_name(name)
    self.base():api_set_name(name)
end

---@param description string 描述
---设置描述
function destructible:set_description(description)
    self.base():api_set_str_attr("description", description)
end

---@param x number x轴缩放
---@param y number y轴缩放
---@param z number z轴缩放
---设置缩放
function destructible:set_scale(x, y, z)
    self.base():api_set_scale(Fix32(x), Fix32(y), Fix32(z))
end

---@param angle number 朝向角度
---设置朝向
function destructible:set_rotation(angle)
    self.base():api_set_face_angle(Fix32(angle))
end

---@param height number 高度
---设置高度
function destructible:set_height(height)
    self.base():api_set_height_offset(Fix32(height))
end

---@param height number 高度
---增加高度
function destructible:add_height(height)
    self.base():api_add_height_offset(Fix32(height))
end

---@param is_lockable boolean 能否被技能指示器锁定
---设置能否被技能指示器锁定
function destructible:set_lockable_by_ability(is_lockable)
    self.base():api_set_dest_is_ability_target(is_lockable)
end

---@param is_attackable boolean 能否被攻击
---设置能否被攻击
function destructible:set_attackable(is_attackable)
    self.base():api_set_dest_is_attacked(is_attackable)
end

---@param is_selectable boolean 能否被选中
---设置能否被选中
function destructible:set_selectable(is_selectable)
    self.base():api_set_dest_is_selected(is_selectable)
end

---@param is_gatherable boolean 能否被采集
---设置能否被采集
function destructible:set_gatherable(is_gatherable)
    self.base():api_set_dest_is_collected(is_gatherable)
end

---@param tag string 标签
---增加标签
function destructible:add_tag(tag)
    self.base():api_add_tag(tag)
end

---@param tag string 标签
---移除标签
function destructible:remove_tag(tag)
    self.base():api_remove_tag(tag)
end

---@param anim_name string 动画名字
---@param start_time number 开始时间
---@param end_time number 结束时间
---@param is_loop boolean 是否循环
---@param speed number 速度
---播放动画
function destructible:play_animation(anim_name, start_time, end_time, is_loop, speed)
    self.base():api_play_animation(anim_name, Fix32(start_time), Fix32(end_time), is_loop, Fix32(speed))
end

---@param anim_name string 动画名字
---停止动画
function destructible:stop_animation(anim_name)
    self.base():api_stop_animation(anim_name)
end

---@param model_id number 模型id
---替换模型
function destructible:replace_model(model_id)
    self.base():api_replace_model(model_id)
end

---@param model_id number 模型id
---取消替换模型
function destructible:cancel_replace_model(model_id)
    self.base():api_cancel_replace_model(model_id)
end

---@param is_visible boolean 是否显示
---显示/隐藏 
function destructible:set_visible(is_visible)
    self.base():api_show_hide(is_visible)
end

---@return number type 可破坏物类型
---获取可破坏物类型
function destructible:get_destructible_type()
    return game_api.get_dest_type(self.base())
end

---@return string name 可破坏物的名称
---获取可破坏物的名称
function destructible:get_name()
    return self.base():api_get_str_attr("name")
end

---@return string description 描述
---获取可破坏物描述
function destructible:get_description()
    return self.base():api_get_str_attr("description")
end

---@return number cur_hp 生命值
---获取可破坏物的生命值
function destructible:get_hp()
    return self.base():api_get_float_attr("hp_cur")
end

---@return string source_name 资源名称
---获取可破坏物的资源名称
function destructible:get_resource_name()
    return self.base():api_get_str_attr("source_desc")
end

---@return number hp 可破坏物的生命值
---获取可破坏物的生命值
function destructible:get_max_hp()
    return self.base():api_get_float_attr("hp_max")
end

---@return number source_number 当前资源数
---获取可破坏物的当前资源数
function destructible:get_resource()
    return self.base():api_get_dest_cur_source_nums()
end

---@return number max_number 最大资源数
---获取可破坏物的最大资源数
function destructible:get_max_resource()
    return self.base():api_get_dest_max_source_nums()
end

---@return number resource_type 玩家属性
---获取可破坏物的玩家属性
function destructible:get_resource_type()
    return self.base():api_get_role_res_of_dest()
end

---@return number item_type 物品类型
---获取可破坏物的物品类型
function destructible:get_item_type()
    return self.base():api_get_item_type_of_dest()
end

---@return number model 模型id
---获取可破坏物的模型
function destructible:get_model()
    return self.base():api_get_dest_model()
end

---@return number height 高度
---获取可破坏物的高度
function destructible:get_height()
    return self.base():api_get_dest_height_offset()
end

---@return number rotation 面向角度
---获取可破坏物的面向角度
function destructible:get_rotation()
    return self.base():api_get_dest_face_angle()
end

---@return point point 可破坏物的位置
---获取可破坏物对象的位置
function destructible:get_position()
    local py_point = self.base():api_get_position()
    return y3.get_lua_point_from_py(py_point)
end

--------------------------------------------类的方法--------------------------------------------

---@param type_id number 可破坏物类型id
---@param point point 创建到点
---@param angle number 面向角度
---@param scale_x number 缩放x
---@param scale_y number 缩放y
---@param scale_z number 缩放z
---@param height number 高度
---@return destructible destructible 可破坏物
---创建可破坏物
function destructible.create_destructible(type_id, point, angle, scale_x, scale_y, scale_z, height)
    if not scale_x then scale_x = 1 end
    if not scale_y then scale_y = 1 end
    if not scale_z then scale_z = 1 end
    if not height then height = 0 end
    local py_destructible = game_api.create_destructible_new(type_id, point.base(), Fix32(angle), Fix32(scale_x), Fix32(scale_y), Fix32(scale_z), Fix32(height))

    return y3.destructible.get_lua_destructible_from_py(py_destructible)
    --return 
end

---@param type number 类型id
---@return string name 名称
---获取可破坏物类型的名称
function destructible.get_name_by_type(type)
    return game_api.get_dest_name_by_type(type)
end

---@param type number 类型id
---@return string description 描述
---获取可破坏物类型的描述
function destructible.get_description_by_type(type)
    return game_api.get_dest_desc_by_type(type)
end

---@param type number 类型id
---@return number model 模型id
---获取可破坏物类型的模型
function destructible.get_model_by_type(type)
    return game_api.get_model_key_of_dest_key(type)
end

---@param area area 区域对象
---@return table model 模型id
---遍历区域中的所有可破坏物
function destructible.pick(area)
    local lua_table = {}
    local py_list = game_api.get_all_dest_in_area(area.base())
    for i = 0, python_len(py_list)-1 do
        local iter_destructible = python_index(py_list,i)
        table.insert(lua_table,y3.destructible.get_lua_destructible_from_py(iter_destructible))
    end
    return lua_table
end

---@param point point 点
---@param shape py_shape 区域
---@return table destructible_list 可破坏物列表
---获取不同形状范围内的可破坏物列表
function destructible.pick_des_by_shape(point,shape)
    local py_list = game_api.get_all_dest_in_shapes(point.base(),shape)
    local lua_table = {}
    for i = 0, python_len(py_list)-1 do
        local iter_destructible = python_index(py_list,i)
        table.insert(lua_table,y3.destructible.get_lua_destructible_from_py(iter_destructible))
    end
    return lua_table
end
