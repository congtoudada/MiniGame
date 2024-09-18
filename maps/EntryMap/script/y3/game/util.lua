--- File Name : util.lua
--- Created By : 
--- Description: 工具类



---@param data table 触发器回调函数中的data
---@param const string data枚举
---@param type string lua对象类型
---@param extra_type integer 额外类型参数
---@return table obj lua对象
---从data中获取lua对象,若不填type则不返回lua对象
function y3.get_obj_from_data(data, const, type, extra_type)
    local obj
    if const and type and data[const] then
        if type == 'ability' then
            obj = y3.ability.get_lua_ability_from_py(data[const])
        elseif  type == 'destructible' then
            obj = y3.destructible.get_lua_destructible_from_py(data[const])
        elseif  type == 'item' then
            obj = y3.item.get_lua_item_from_py(data[const])
        elseif  type == 'modifier' then
            obj = y3.modifier.get_lua_modifier_from_py(data[const])
        elseif  type == 'projectile' then
            obj = y3.projectile.get_lua_projectile_from_py(data[const])
        elseif  type == 'purchase' then
            obj = y3.purchase.get_lua_purchase_from_py(data[const])
        elseif  type == 'unit' then
            obj = y3.unit.get_lua_unit_from_py(data[const])
        elseif  type == 'beam' then
            obj = y3.beam.create_lua_beam_by_py(data[const])
        elseif type == 'player' then
            obj = y3.create_lua_player_from_py(data[const])
        elseif type == 'area' then
            obj = y3.area.get_lua_area_from_py(data[const],extra_type)            
        elseif type == 'path' then
            obj = y3.path.get_lua_path_from_py(data[const])
        elseif type == 'point' then
            obj = y3.get_lua_point_from_py(data[const])
        end
    else
        obj = data[const]
    end
    return obj
end

---@param conditions table 条件列表
---@return boolean 是否所有条件成立
---所有条件成立
function y3.all_conditions_succeed(conditions)
    local result = true
    for i, v in ipairs(conditions) do
        result = result and v
    end
    return result
end

---@param conditions table 条件列表
---@return boolean 是否任一条件成立
---任一条件成立
function y3.any_conditions_succeed(conditions)
    local result = false
    for i, v in ipairs(conditions) do
        result = result or v
    end
    return result
end

---@param conditions table 条件列表
---@return boolean 是否所有条件不成立
---所有条件不成立
function y3.all_conditions_failed(conditions)
    local result = false
    for i, v in ipairs(conditions) do
        result = result or v
    end
    result = not result
    return result
end

---@param _obj table 物体
---@param _mat string 材质
---@param arg1 number 参数1
---@param arg2 number 参数2
---@param arg3 number 参数3
---@param arg4 number 参数4
---@param arg4 number 参数5
---设置物体的材质
function y3.set_material_param(_obj, _mat, arg1, arg2, arg3, arg4, arg5)
    game_api.set_material_param(_obj, _mat, Fix32(arg1), Fix32(arg2), Fix32(arg3), Fix32(arg4), Fix32(arg5))
end

---@param _ins string 键
---@param _value string|number|table 值
---清除实例的键值
function y3.remove_kv(_ins, _value)
    global_api.api_remove_kv(_ins, _value)
end


---@param _ins string 键
---清空键值
function y3.clear_kv(_ins)
    global_api.api_clear_kv(_ins)
end


---@param _id number 单位id
---@param _value string|number|table 值
---清除单位类型键值
function y3.remove_unit_kv(_id, _value)
    game_api.del_unit_key_kv(_id, _value)
end

---@param _id number 物品id
---@param _value string|number|table 值
---清除物品类型键值
function y3.remove_item_kv(_id, _value)
    game_api.del_item_key_kv(_id, _value)
end

---@param _id number 技能id
---@param _value string|number|table 值
---清除技能类型键值
function y3.remove_ability_kv(_id, _value)
    game_api.del_ability_key_kv(_id, _value)
end

---@param _id number id
---@param _value string|number|table 值
---清除可破坏物\科技\投射物\魔法效果\类型键值
function y3.remove_prefab_kv(_id, _value, _miss)
    game_api.del_prefab_key_kv(_id, _value, _miss)
end

---@param _id number id
---@param _value string|number|table 值
---清除单位类型键值
function y3.remove_unit_kv(_id, _value)
    game_api.del_unit_key_kv(_id, _value)
end

---@param _obj table 要清楚的单位
---清除标签
function y3.cleartag(_obj)
    global_api.api_clear_tag(_obj and _obj.base() or nil)
end

-- --注销动态触发器
-- function y3.remove_dynamic_trigger(trigger)
--     y3.unreg_actor_trigger(actor,trigger)
-- end

---创建随机池
function y3.create_random_pool()
    return game_api.create_random_pool()
end

---@param pool table 随机池
---@param integer number 指定的整数
---@param weight number 权重
---设置随机池指定整数权重
function y3.set_weight_of_specified_integer(pool, integer, weight)
    game_api.set_random_pool_value(pool, integer, weight)
end

---@param pool table 随机池
---@param integer number 要移除的整数
---随机池移除指定整数
function y3.remove_specified_integer(pool, integer)
    game_api.remove_random_pool_value(pool, integer)
end

---遍历随机池
function y3.pick_random_pool(random_pool)
    local lua_table = {}
    local py_list = random_pool
    for i = 0, python_len(py_list)-1 do
        local iter = python_index(py_list,i)
        table.insert(lua_table,iter)
    end
    return lua_table
end

---@param player player 玩家
---@param msg string 消息
---@param is_language boolean 是否支持语言环境
---向玩家提示
function y3.display_info_to_player(player, msg, is_language)
    game_api.show_msg_to_role(player.base(), msg, is_language)
end

---@param pool table 随机池
---@param integer number 指定的整数
---@param weight number 权重
---随机池增加指定整数权重
function y3.increase_weight_of_specified_integer(pool, integer, weight)
    game_api.increase_random_pool_value(pool, integer, weight)
end

---@param str_list table 字符串数组
---@param str1 string 字符串1
---@param str2 string 字符串2
---分割字符串数组
function y3.separate_string(str_list, str1, str2)
    game_api.set_trigger_str_list_by_split(str_list, nil, str1, str2)
end

---@param id number 阵营id
---获得阵营
function y3.get_camp_by_camp_id(id)
    return game_api.get_camp_by_camp_id(id)
end

---@param _str string 字符串
---string类型转bool
function y3.stringtobool(_str)
    global_api.str_to_bool(_str)
end

---@param _dis number 距离
---设置阴影距离
function y3.set_cascaded_shadow_distance(_dis)
    game_api.set_cascaded_shadow_distance(Fix32(_dis))
end

---@param timer timer 计时器
---删除计时器
function y3.remove_timer(timer)
    game_api.delete_timer(timer.base())
end

---@param timer timer 计时器
function y3.pause_timer(timer)
    game_api.pause_timer(timer.base())
end

---@param timer timer 计时器
---恢复计时器
function y3.resume_timer(timer)
    game_api.resume_timer(timer.base())
end

---@param _str string 字符串
---@return number length 长度
---获取字符串长度
function y3.get_str_length(_str)
    return global_api.length_of_str(_str)
end

---@param _str1 string 字符串1
---@param _str2 string 字符串2
---@return number index 索引
---目标字符在字符串中的索引
function y3.pos_in_str(_str1, _str2)
    return global_api.pos_in_str(_str1, _str2)
end

---@param _techid number 科技id
---@return number level 最大等级
---获取科技最大等级
function y3.get_tech_max_level(_techid)
    return game_api.get_tech_max_level(_techid)
end

---@param _player player 玩家
---@return number pos_x 坐标x
---获取玩家的鼠标屏幕坐标X
function y3.get_player_ui_pos_x(_player)
    return game_api.get_player_ui_pos_x(_player.base())
end

---@param _player player 玩家
---@return number pos_y 坐标y
---获取玩家的鼠标屏幕坐标y
function y3.get_player_ui_pos_y(_player)
    return game_api.get_player_ui_pos_y(_player.base())
end

---@param _player player 玩家
---@return point point 坐标
---获取玩家的鼠标坐标
function y3.get_player_pointing_pos(_player)
    local py_point = game_api.get_player_pointing_pos(_player.base())
    return y3.get_lua_point_from_py(py_point)
end

---@param _ins table 目标
---@return point point 点
---获取投射物\物品\单位\可破坏物所在点
function y3.get_instance_location_point(_ins)
    local py_point = _ins.api_get_position()
    return y3.get_lua_point_from_py(py_point)
end

---@param _arg player|unit 玩家或单位
---@return number camp 队伍
---获取玩家\单位所在队伍
function y3.get_team(_arg)
    return _arg.api_get_camp()
end

---@param _str string 字符串
---@return number 单位命令类型
---字符串转单位命令类型
function y3.str_to_unit_command_type(_str)
    return global_api.str_to_unit_command_type(_str)
end

---@param _str string 字符串
---@return point point 点
---字符串转点
function y3.str_to_point(_str)
    local py_point = global_api.str_to_vector3(_str)
    return y3.get_lua_point_from_py(py_point)
end

---@param _str string 字符串
---@return number type 技能释放类型
---字符串转技能释放类型
function y3.str_to_ability_cast_type(_str)
    return global_api.str_to_ability_cast_type(_str)
end

---@param _str string 字符串
---@return beam beam 链接特效
---字符串转链接特效
function y3.str_to_link_sfx_key(_str)
    return game_api.str_to_link_sfx_key(_str)
end

---@param _str string 字符串
---@return number relation 玩家关系
---字符串转玩家关系
function y3.str_to_role_relation(_str)
    return global_api.str_to_role_relation(_str)
end

---@param _str string 字符串
---@return number relation 单位分类
---字符串转单位分类
function y3.str_to_unit_type(_str)
    return global_api.str_to_unit_type(_str)
end

---@param _str string 字符串
---@return number relation 单位类型
---字符串转单位类型
function y3.str_to_unit_key(_str)
    return game_api.str_to_unit_key(_str)
end

---@param _str string 字符串
---@return string attr 单位属性
---字符串转单位属性
function y3.str_to_unit_name(_str)
    return game_api.str_to_unit_attr(_str)
end

---@param _str string 字符串
---@return number type 物品类型
---字符串转物品类型
function y3.str_to_item_key(_str)
    return game_api.str_to_item_key(_str)
end

---@param _str string 字符串
---@return string player_attr 玩家属性
---字符串转玩家属性
function y3.str_to_role_res(_str)
    return game_api.str_to_role_res(_str)
end

---@param _str string 字符串
---@return number player_status 玩家状态
---字符串转玩家状态
function y3.str_to_role_status(_str)
    return global_api.role_status_to_str(_str)
end

---@param _str string 字符串
---@return number player_type 玩家控制状态
---字符串转玩家控制状态
function y3.str_to_role_type(_str)
    return global_api.str_to_role_type(_str)
end

---@param _str string 字符串
---@return number ability_key 技能类型
---字符串转技能类型
function y3.str_to_ability_key(_str)
    return game_api.str_to_ability_key(_str)
end

---@param _str string 字符串
---@return number ability_type 技能槽位类型
---字符串转技能槽位类型
function y3.str_to_ability_type(_str)
    return global_api.str_to_ability_type(_str)
end

---@param _str string 字符串
---@return number dest_key 可破坏物类型
---字符串转可破坏物类型
function y3.str_to_dest_key(_str)
    return game_api.str_to_dest_key(_str)
end

---@param _str string 字符串
---@return number project_key 投射物类型
---字符串转投射物类型
function y3.str_to_project_key(_str)
    return game_api.str_to_project_key(_str)
end

---@param _str string 字符串
---@return particle particle 特效 
---字符串转特效
function y3.str_to_particle_sfx_key(_str)
    return game_api.str_to_particle_sfx_key(_str)
end

---@param _str string 字符串
---@return number tech_key 科技类型
---字符串转科技类型
function y3.str_to_tech_key(_str)
    return game_api.str_to_tech_key(_str)
end

---@param _str string 字符串
---@return number model_key 模型类型
---字符串转模型类型
function y3.str_to_model_key(_str)
    return game_api.str_to_model_key(_str)
end

---@param _str string 字符串
---@return number modifier_key 魔法效果类型
---字符串转魔法效果类型
function y3.str_to_modifier_key(_str)
    return game_api.str_to_modifier_key(_str)
end

---@param _str string 字符串
---@return number modifier_effect_type 魔法效果影响类型
---字符串转魔法效果影响类型
function y3.str_to_modifier_effect_type(_str)
    return global_api.str_to_modifier_effect_type(_str)
end

---@param _str string 字符串
---@return number modifier_type 魔法效果类别
---字符串转魔法效果类别
function y3.str_to_modifier_type(_str)
    return global_api.str_to_modifier_type(_str)
end

---@param _str string 字符串
---@return number camp 阵营
---字符串转阵营
function y3.str_to_camp(_str)
    return game_api.str_to_camp(_str)
end

---@param _str string 字符串
---@return number keyboard_key 键盘按键
---字符串转键盘按键
function y3.str_to_keyboard_key(_str)
    return global_api.str_to_keyboard_key(_str)
end

---@param _str string 字符串
---@return number mouse_key 鼠标按键
---字符串转鼠标按键
function y3.str_to_mouse_key(_str)
    return global_api.str_to_mouse_key(_str)
end

---@param _str string 字符串
---@return number mouse_key 鼠标滚轮
---字符串转鼠标滚轮
function y3.str_to_mouse_wheel(_str)
    return global_api.str_to_mouse_wheel(_str)
end

---@param _str string 字符串
---@return number store_key 平台道具类型
---字符串转平台道具类型
function y3.str_to_store_key(_str)
    return game_api.str_to_store_key(_str)
end

---@param _str string 字符串
---@return number damage_type 伤害类型
---字符串转伤害类型
function y3.str_to_damage_type(_str)
    return global_api.str_to_damage_type(_str)
end

---@param _str string 字符串
---@return string unit_attr_type 单位属性类型
---字符串转单位属性类型
function y3.str_to_unit_attr_type(_str)
    return global_api.str_to_unit_attr_type(_str)
end

---@param _str string 字符串
---@return number audio_key 声音类型
---字符串转声音类型
function y3.str_to_audio_key(_str)
    return game_api.str_to_audio_key(_str)
end

---@return number texture
---根据图片ID获取图片
function y3.get_icon_id(id)
    return game_api.get_texture_by_icon_id(id)
end

---@param point point 点
---@param range number 范围
---@return number unit_command 移动命令
---移动
function y3.move_to_pos(point, range)
    return game_api.create_unit_command_move_to_pos(point.base(), Fix32(range))
end

---@return number unit_command 停止命令
---停止
function y3.stop()
    return game_api.create_unit_command_stop()
end

---@param point point 点
---@return number unit_command 驻守命令
---驻守
function y3.garrison(point)
    return game_api.create_unit_command_hold(point.base())
end

---@param point point 点
---@param range number 范围
---@return number unit_command 攻击移动命令
---攻击移动
function y3.attack_move(point, range)
    return game_api.create_unit_command_attack_move(point.base(), Fix32(range))
end

---@param unit unit 目标单位
---@param range number 范围
---@return number unit_command 攻击目标命令
---攻击目标
function y3.attack_target(unit, range)
    return game_api.create_unit_command_attack_target(unit.base(), Fix32(range))
end

---@param path path 路径
---@param patrol_mode number 移动模式
---@param is_attack boolean 攻击模式
---@param nearby_start_point boolean 就近选择起始点
---@param is_deviate_return boolean 偏离后就近返回
---@return number unit_command 沿路径移动命令
---沿路径移动
function y3.move_along_path(path, patrol_mode, is_attack, nearby_start_point, is_deviate_return)
    return game_api.create_unit_command_move_along_road(path.base(), patrol_mode, is_attack, nearby_start_point, is_deviate_return)
end

---@param ability ability 技能
---@param point1 point 目标点
---@param point2 point 目标点
---@param unit unit 目标单位
---@param item item 目标物品
---@param dest destructible 目标可破坏物
---@return number unit_command 释放技能命令
---释放技能
function y3.cast_ability(ability, point1, point2,  unit, item, dest)
    local point1_base
    local point2_base
    local unit_base
    local item_base
    local dest_base
    if point1 then
        point1_base = point1.base()
    end
    if point2 then
        point2_base = point2.base()
    end
    if unit then
        unit_base = unit.base()
    end
    if item then
        item_base = item.base()
    end
    if dest then
        dest_base = dest.base()
    end
    return game_api.create_unit_command_use_skill(ability.base(),point1_base, point2_base, unit_base, item_base, dest_base)
end

---@param item item 物品
---@return number unit_command 拾取物品命令
---拾取物品
function y3.pick_up_item(item)
    return game_api.create_unit_command_pick_item(item.base())
end

---@param item item 物品
---@param point point 点
---@return number unit_command 丢弃物品命令
---丢弃物品
function y3.discard_item(item, point)
    return game_api.create_unit_command_drop_item(item.base(), point.base())
end

---@param item item 物品
---@param unit unit 单位
---@return number unit_command 给予物品命令
---给予物品
function y3.give_item(item, unit)
    return game_api.create_unit_command_transfer_item(item.base(), unit.base())
end

---@param item item 物品
---@param point1 point 目标点
---@param point2 point 目标点
---@param unit unit 目标单位
---@param target_item item 目标物品
---@param dest destructible 目标可破坏物
---@return number unit_command 使用物品命令
---使用物品
function y3.use_item(item, point1, point2, unit, target_item, dest)
    local point1_base
    local point2_base
    local unit_base
    local item_base
    local dest_base
    if point1 then
        point1_base = point1.base()
    end
    if point2 then
        point2_base = point2.base()
    end
    if unit then
        unit_base = unit.base()
    end
    if item then
        item_base = target_item.base()
    end
    if dest then
        dest_base = dest.base()
    end
    return game_api.create_unit_command_use_item(item.base(), point1_base, point2_base, unit_base, item_base,dest_base)
end

---@param unit unit 单位
---@return number unit_command 跟随命令
---@param interval number 间隔
---@param ner_offset number 跟随距离
---@param far_offset number 重新跟随距离
---跟随
function y3.follow(unit, interval, ner_offset, far_offset)
    return game_api.create_unit_command_follow(unit.base(),Fix32(interval), Fix32(ner_offset), Fix32(far_offset))
end

---@return number unit_command 空命令
---空命令
function y3.empty()
    return game_api.create_unit_command_empty()
end

---@param point point 点
---@param terrain_type integer 纹理类型
---@param range number 范围
---@param area_type number 形状
---设置某点的地形纹理
function y3.set_terrain_texture_at_a_specified_point(point, terrain_type, range, area_type)
    game_api.modify_point_texture(point.base(), terrain_type, range, area_type)
end

---获取纹理类型
function y3.get_texture_by_point(point)
    return game_api.get_point_texture(point.base())
end

---@param area area 区域
---@param terrain_type number 纹理类型
---@param target_terrain_type number 纹理类型
---替换区域内的指定地形纹理
function y3.replace_specified_terrain_texture_in_region(area, terrain_type, target_terrain_type)
    game_api.replace_point_texture(area.base(), terrain_type, target_terrain_type)
end

---@param area area 区域
---@param weather number 天气
---设置区域天气
function y3.set_region_weather(area, weather)
    game_api.update_area_weather(area.base(), weather)
end

---@param weather number 天气
---设置全局天气
function y3.set_global_weather(weather)
    game_api.update_global_weather(weather)
end

---@param player player 玩家
---@param filter number 滤镜效果
---设置玩家的滤镜效果
function y3.set_player_filter_effect(player, filter)
    game_api.set_role_color_grading(player.base(), filter)
end

---@param player player 玩家
---@param is_visible boolean 显示/隐藏
---显示/隐藏玩家地表纹理
function y3.display_player_terrain_texture(player, is_visible)
    game_api.set_local_terrain_visible(player.base(), is_visible)
end

---@param player player 玩家
---@param is_enable boolean 开关
---设置暗角开关
function y3.enable_vignetting(player, is_enable)
    player.base():set_role_vignetting_enable(is_enable)
end

---@param player player 玩家
---@param size number 大小
---设置暗角大小
function y3.set_vignetting_size(player, size)
    player.base():set_role_vignetting_size(Fix32(size))
end

---@param player player 玩家
---@param circle_time number 呼吸周期
---设置暗角呼吸周期
function y3.set_vignetting_breathing_period(player, circle_time)
    player.base():set_role_vignetting_breath_rate(Fix32(circle_time))
end

---@param player player 玩家
---@param range number 幅度
---设置暗角变化幅度
function y3.set_vignetting_changing_amplitude(player, range)
    player.base():set_role_vignetting_change_range(Fix32(range))
end

---@param player player 玩家
---@param red number 颜色r
---@param green number 颜色g
---@param blue number 颜色b
---@param time number 过渡时间
---设置暗角颜色
function y3.set_vignetting_color(player, red, green, blue, alpha)
    player.base():set_role_vignetting_color(red, green, blue, alpha)
end

---@param fog table 局部雾
---@param direction number 朝向
---@param pos_x number 位置x
---@param pos_y number 位置y
---@param pos_z number 位置z
---@param scale_x number 缩放x
---@param scale_y number 缩放y
---@param scale_z number 缩放z
---@param red number 颜色r
---@param green number 颜色g
---@param blue number 颜色b
---@param concentration number 浓度
---@param speed number 流速
---设置雾效属性
function y3.set_fog_attribute(fog, direction, pos_x, pos_y, pos_z, scale_x, scale_y, scale_z, red, green, blue, concentration, speed)
    game_api.set_fog_attr(fog, 4095, Fix32(direction or 0), Fix32(pos_x or 0), Fix32(pos_y or 0), Fix32(pos_z or 0), Fix32(scale_x or 0), Fix32(scale_y or 0), Fix32(scale_z or 0), Fix32(red or 0), Fix32(green or 0), Fix32(blue or 0), Fix32(concentration or 0), Fix32(speed or 0))
end

---@param fog table 局部雾
---@param attr string 朝向
---@param value number 位置x
---设置雾效属性(新)
function y3.set_fog_attr(fog,attr,value)
    game_api.set_fog_attr_new(fog,attr,Fix32(value))
end

---@param distance number 距离
---设置阴影距离
function y3.set_cascaded_shadow_distanc(distance)
    game_api.set_cascaded_shadow_distance(Fix32(distance))
end

---@param is_enable boolean 开关
---开关级联阴影
function y3.set_cascaded_shadow_enable(is_enable)
    game_api.set_cascaded_shadow_enable(is_enable)
end

---@param player player 玩家
---@param processing number 画风
---@param color_r Int 颜色R
---@param color_g Int 颜色G
---@param color_b Int 颜色B
---@param depth_scale float 描边
---@param intensity float 强度
---为玩家切换画风
function y3.set_post_effect(player, processing, color_r, color_g, color_b, depth_scale, intensity)
    game_api.set_post_effect(player.base(), processing, color_r, color_g, color_b, depth_scale, intensity)
end

---@param table table 表
---@param key string 键   
---@param value string|number|boolean 值
---设置一维表的值
function y3.set_table_value(table, key,value)
    table[key] = value
end

---@param table table 表
---@param value string|number|boolean 值
---@param key string 键   
---@param field string 键   
---设置多维表的值
function y3.set_table_value_multi(table, key, value, field)
    game_api.set_table_value(table, value,key,  field, "", "", "", "")
end

---@param table table 表
---@param value string|number|boolean 值
---@param index number 位置
---向表中插入值
function y3.insert_table_value(table, value, index)
    game_api.insert_table_value(table, value, "", index)
end

---@param table table 表
---@param index number 位置
---删除一维表的第N个值
function y3.remove_nth_table_value(table, index)
    game_api.remove_table_value_n(table, index)
end

---@param table table 表
---遍历表
function y3.pick_table(table)
    return game_api.table_iterator(table)
end

---@param table table 表
---遍历表（保序）
function y3.pick_table_ordered(table)
    game_api.ordered_table_iterator(table)
end

---@param table table 表
---打印表
function y3.dump_table(table)
    game_api.dump_table(table)
end

---@return table table 空表
---创建空的表
function y3.new_empty_table()
    return game_api.get_new_table()
end

-- --当前表遍历到的字符串索引
-- ---@return 
-- function y3.string_index_picked_in_the_current_table()

-- end


---@param table table 表
---@return table table 表
---复制表
function y3.copy_table(table)
    return game_api.get_copy_of_table(table)
end

-- --当前表遍历到的整数索引
-- ---@return 
-- function y3.integer_index_picked_in_the_current_table()
--     y3.get_iter_table_key_int(data['__ITER_TABLE_ITEM'])
-- end


---@param table table 表
---@return number 长度
---表的长度
function y3.table_length(table)
    return game_api.get_table_length(table)
end

---@param tech_id number 科技id
---@return number level 最大等级
---获取科技最大等级
function y3.get_max_tech_level(tech_id)
    return game_api.get_tech_max_level(tech_id)
end

---@param tech_id number 科技
---@param index number 等级
---@return number texture 图标id
---获取科技图标
function y3.get_tech_icon(tech_id, index)
    return game_api.api_get_tech_icon(tech_id, index)
end

---@param tech number 科技
---@return number tech_key 科技类型
---获取事件中的科技类型
function y3.get_tech_type_from_event(tech)
    return game_api.get_tech_name_by_type(tech)
end

---@param tech_id number 科技类型
---@return string description 描述
---获取科技类型的描述
function y3.get_tech_type_description(tech_id)
    return game_api.get_tech_desc_by_type(tech_id)
end

---@param tech_id number 科技类型
---@return string name 名称
---获取科技类型的名称
function y3.get_tech_type_name(tech_id)
    return game_api.get_tech_name_by_type(tech_id)
end

---@param player player 玩家
---@param result number 结果
---@param is_show boolean 是否展示界面
---结束玩家游戏
function y3.end_player_game(player, result, is_show)
    game_api.set_melee_result_by_role(player.base(), result, is_show, false, 0, false)
end

---暂停游戏
function y3.pause_game()
    game_api.pause_game()
end

---@param is_quick_reset boolean 快速重置
---开始新一轮游戏
function y3.start_new_round_of_game(is_quick_reset)
    game_api.request_new_round(is_quick_reset or true)
end

---开启软暂停
function y3.enable_soft_pause()
    game_api.api_soft_pause_game()
end

---恢复软暂停
function y3.resume_soft_pause()
    game_api.api_soft_resume_game()
end

---@param attack_type number 攻击类型
---@param armor_type number 护甲类型
---@param ratio number 系数
---设置伤害系数
function y3.set_damage_factor(attack_type, armor_type, ratio)
    game_api.set_damage_ratio(attack_type, armor_type, Fix32(ratio))
end

---@param primary_attribute number 一级属性
---@param secondary_attr number 二级属性
---@param value number 属性值
---设置复合属性
function y3.set_compound_attributes(primary_attribute, secondary_attr, value)
    game_api.set_slave_coeff(primary_attribute, secondary_attr, Fix32(value))
end

---@param speed number 速度
---设置游戏时间的流逝速度
function y3.set_game_time_elapsing_rate(speed)
    game_api.set_day_and_night_time_speed(Fix32(speed))
end

---@param time number 时间
---设置游戏时间
function y3.set_game_time(time)
    game_api.set_day_and_night_time(Fix32(time))
end

---@param time number 时间
---@param dur number 持续时间
---创建人造时间
function y3.create_artificial_time(time, dur)
    game_api.create_day_and_night_human_time(Fix32(time), Fix32(dur))
end

---@param seed number 随机种子
---设置随机数种子
function y3.set_random_seed(seed)
    game_api.set_random_seed(seed)
end

---@param is_on boolean 开关
---开关时间流逝
function y3.toggle_time_elapsing_is_on(is_on)
    game_api.open_or_close_time_speed(is_on)
end

---@param is_on boolean 开关
---@param point point 点
---开关目标点的草丛
function y3.toggle_target_point_grassland_is_on(is_on, point)
    game_api.set_grass_enable_by_pos(is_on, point.base())
end

-- --请求服务器时间
-- function y3.()

-- end


---@return number game_mode 游戏模式
---获取当前游戏模式
function y3.get_current_game_mode()
    return game_api.get_game_mode()
end

---@return number language_type 语言环境
---获取本地语言环境
function y3.get_local_language_environment()
    return global_api.get_client_language_type()
end

---@return number time  时间
---游戏已运行的时间
function y3.current_game_run_time()
    return game_api.get_cur_game_time():float()
end

---@return number time 时间
---获取游戏当前时间
function y3.get_current_game_time()
    return game_api.get_cur_day_and_night_time():float()
end

---@param attack_type number 攻击类型
---@param area_type number 护甲类型
---@return number factor 伤害系数
---获取伤害系数
function y3.get_damage_factor(attack_type, area_type)
    return game_api.get_damage_ratio(attack_type, area_type)
end

---@param primary_attribute number 一级属性
---@param secondary_attr number 二级属性
---@return number coefficient 系数
---获取三维属性的影响系数
function y3.get_coefficient(primary_attribute, secondary_attr)
    return game_api.get_slave_coeff(primary_attribute, secondary_attr)
end

---@return number start_mode 游戏环境
---获取本局游戏环境
function y3.get_game_environment_of_current_round()
    return game_api.api_get_start_mode()
end

---@param name string 存档名
---@return string archive 存档
---获取全局存档
function y3.get_global_archive(name)
    return game_api.get_global_map_archive(name)
end

---@param file string 存档
---@param index number 序号
---@return string value 存档值
---获取整数存档排行榜玩家存档值
function y3.get_archive_rank_player_archive_value(file, index)
    return game_api.get_archive_rank_player_archive_value(file, index)
end

---@return boolean is_open 是否开启
---是否开启三维属性
function y3.if_pri_attr_state_open()
    return game_api.api_if_pri_attr_state_open()
end

---@return projectile projectile 投射物 
---获取运动器绑定投射物 
function y3.get_mover_bound_projectiles()
    local py_projectile = game_api.get_projectile_by_id(data['mover_owner_projectile'])
    return projectile.get_lua_projectile_from_py(py_projectile)
end

---@return number level 等级
---获取科技变化的等级
function y3.get_tech_changed_level()
    return game_api.get_last_changed_tech()
end

---@param data table 触发器回调函数中的data
---@return modifier modifier 魔法效果
---触发魔法效果
function y3.trigger_modifier(data)
    local py_modifier = data['__modifier']
    return y3.modifier.get_lua_item_from_py(py_modifier)
end

---@return number tech 科技
---被研究科技  
function y3.tech_researched()
    return
end

---@param data table 触发器回调函数中的data
---@return unit unit 事件中的单位
---获取事件中的单位  
function y3.get_unit_in_event(data)
    local py_unit = game_api.get_unit_by_id(data['__unit_id'])
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param data table 触发器回调函数中的data
---@return unit unit 魔法效果携带者
---魔法效果携带者
function y3.modifier_receiver(data)
    local py_unit = data['__owner_unit']
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param ability ability 技能
---@return unit unit 拥有者
---获取技能的拥有者
function y3.get_ability_owner(ability)
    local py_unit = ability.base.api_get_owner()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param modifier modifier 魔法效果
---@return unit provider 施加者
---魔法效果施加者
function y3.modifier_provider(modifier)
    local py_unit = modifier.base.api_get_releaser()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param ability ability 技能
---@param data table 触发器回调函数中的data
---@return item item 目标物品
---技能选取的目标物品
function y3.ability_selected_target_item(ability, data)
    local py_item = game_api.get_target_item_in_ability(ability.base(), data['__ability_runtime_id'])
    return y3.item.get_lua_item_from_py(py_item)
end

---@return modifier modifier 魔法效果
---遍历到的魔法效果
function y3.picked_modifier()
    local py_modifier = data['modifier_iter']
    return y3.modifier.get_lua_item_from_py(py_modifier)
end

---@param data table 触发器回调函数中的data
---@return player player 玩家
---触发当前事件的玩家
function y3.player_that_triggered_current_event(data)
    return game_api.get_role_by_role_id(data['__role_id'])
end

---@param data table 触发器回调函数中的data
---@return projectile projectile 投射物   
---触发当前事件的投射物
function y3.projectile_that_triggered_current_event(data)
    local py_projectile = data['projectile']
    return y3.projectile.get_lua_projectile_from_py(py_projectile)
end

--单位失去科技  --未处理
-- ---@return TECH_KEY
-- function y3.unit_loses_tech()
--     return y3.get_unit_by_id(1).api_remove_tech(201385996)
-- end


---@param ability ability 技能
---@param data table 触发器回调函数中的data
---@return unit unit 目标单位  
---技能选取的目标单位  
function y3.ability_selected_target_unit(ability, data)
    local py_unit = game_api.get_target_unit_in_ability(ability.base(), data['__ability_runtime_id'])
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param data table 触发器回调函数中的data
---@return number 变化值
---获取魔法效果层数变化值
function y3.get_modifier_stack_changed_value(data)
    return data['__layer_change_values']
end

---@return modifier modifier 魔法效果
---已有的魔法效果
function y3.existing_modifier()
    return
end

---@return number tech_key 科技
---等级升降的科技
function y3.tech_upgraded_or_downgraded()
    return game_api.get_last_operated_tech()
end

---@return item item 物品
---遍历物品组时选中的物品
function y3.item_selected_in_picking_item_group()
    return
end

---@return modifier modifier 魔法效果 
---新增的魔法效果 
function y3.new_modifier()
    return
end

---@return number tech_key 等级变化的科技
---等级变化的科技
function y3.level_changed_tech()
    return game_api.get_last_changed_tech()
end

---@param data table 触发器回调函数中的data
---@return unit unit 单位
---获取承受伤害（治疗）的单位
function y3.get_damage_or_healing_target_unit(data)
    local py_unit = data['__target_unit']
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return unit unit 单位
---获取单位组中遍历到的单位
function y3.picked_unit_in_unit_group()
    return
end

---@param data table 触发器回调函数中的data
---@return unit unit 单位
---获取凶手单位
function y3.get_killer_unit(data)
    local py_unit = data['__source_unit']
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return projectile projectile 投射物
---获取遍历到的投射物
function y3.get_picked_projectile()
    return
end

---@param data table 触发器回调函数中的data
---@return unit unit 单位
---获取死亡单位
function y3.get_dead_unit(data)
    local py_unit = data['__target_unit']
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param data table 触发器回调函数中的data
---@return unit unit 单位
---获取施加伤害（治疗）的单位
function y3.Get_Damage_or_Healing_Source_Unit(data)
    local py_unit = data['__source_unit']
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return unit unit 单位
---获得物品单位
function y3.unit_to_gain_item()
    local py_unit = game_api.get_last_add_item_unit()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return unit unit 单位
---失去物品单位
function y3.unit_to_lose_item()
    local py_unit = game_api.get_last_remove_item_unit()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return unit unit 单位
---使用物品单位
function y3.unit_to_use_item()
    local py_unit = game_api.get_last_use_item_unit()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return unit unit 单位
---堆叠层数变化物品的持有者
function y3.unit_to_change_stacks()
    local py_unit = game_api.get_last_change_item_stack_unit()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return unit unit 单位
---最后进行合成操作的单位
function y3.unit_to_undergo_composition()
    return
end

---@return unit unit 单位
---获取即将获得魔法效果单位
function y3.get_unit_about_to_gain_modifier(modifier)
    local py_unit = modifier.base.api_get_will_modifier_unit()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return unit unit 单位
---最后进行购买操作的单位
function y3.last_unit_to_make_purchase()
    local py_unit = ''
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return unit unit 单位
---最后进行出售操作的单位
function y3.last_unit_to_make_sale()
    local py_unit = game_api.get_last_seller_unit()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return unit unit 单位
---研究科技的单位   
function y3.unit_to_research_tech()
    return
end

---@return unit unit 单位
---获得科技的单位  
function y3.unit_to_gain_tech()
    return
end

---@return unit unit 单位
---失去科技单位 
function y3.unit_to_lose_tech()
    return
end

---@param data table 触发器回调函数中的data
---@return number index 索引   
---获取当前数组索引  
function y3.get_current_array_index(data)
    return data['__iter_index']
end

---@param data table 触发器回调函数中的data
---@return ability ability 技能
---触发当前事件的技能
function y3.ability_that_triggered_current_event(data)
    local py_ability = game_api.get_ability_by_id(data['__ability'])
    return y3.ability.get_lua_ability_from_py(py_ability)
end

---@return ability ability 技能
---遍历到的技能
function y3.picked_ability()
    return
end

---@param ability ability 技能
---@param data table 触发器回调函数中的data
---@return destructible destructible 可破坏物
---技能选取的目标可破坏物
function y3.ability_selected_destructible(ability, data)
    local py_destructible = game_api.get_target_dest_in_ability(ability.base(), data['__ability_runtime_id'])
    return y3.destructible.get_lua_destructible_from_py(py_destructible)
end

---@return destructible destructible 可破坏物
---遍历到的可破坏物 
function y3.picked_destructible()
    return
end

---@param data table 触发器回调函数中的data
---@return destructible destructible 可破坏物
---事件中的可破坏物  
function y3.destructible_in_event(data)
    local py_destructible = game_api.get_dest_by_id(data['__destructible_id'])
    return y3.destructible.get_lua_destructible_from_py(py_destructible)
end

---@param data table 触发器回调函数中的data
---@return number value 伤害数值
---触发当前事件的伤害的数值  
function y3.damage_value_that_triggered_current_event(data)
    return game_api.get_hurt_damage(data['__damage'])
end

---@param data table 触发器回调函数中的data
---@return item item 物品
---触发当前事件的物品
function y3.item_that_triggered_current_event(data)
    local py_item = game_api.get_item(data['__item_id'])
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item item 物品
---单位获得物品
function y3.unit_gains_item()
    local py_item = game_api.get_last_add_item()
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item item 物品
---单位失去物品
function y3.unit_loses_item()
    local py_item = game_api.get_last_remove_item()
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item item 物品
---单位使用物品
function y3.unit_uses_item()
    local py_item = game_api.get_last_use_item()
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item item 物品
---堆叠层数变化物品
function y3.item_whose_stack_changed()
    local py_item = game_api.get_last_stack_changed_item()
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item item 物品
---充能变化物品
function y3.item_whose_charge_changed()
    local py_item = game_api.get_last_stack_changed_item()
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item item 物品
---购买物品
function y3.item_purchased()
    local py_item = game_api.get_last_buy_shop_item()
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item item 物品
---出售物品
function y3.item_sold()
    local py_item = game_api.get_last_sell_shop_item()
    return y3.item.get_lua_item_from_py(py_item)
end

---@return modifier modifier 魔法效果
---即将获得魔法效果类型
function y3.about_to_gain_modifier_type()
    return
end

---@return player player 玩家
---遍历到的玩家 
function y3.picked_player()
    return
end

---@param ability ability 技能
---@param data table 触发器回调函数中的data
---@return point point 点
---技能选取到的点
function y3.selected_location_by_ability(ability, data)
    local py_point = ability.base:api_get_release_position(data['__ability_runtime_id'])
    return y3.get_lua_point_from_py(py_point)
end

---@return area area 矩形区域
---遍历到的矩形区域
function y3.picked_rectangle()
    return
end

---@return area area 矩形区域
---遍历到的圆形区域
function y3.picked_circle()
    return
end

---@param data table 触发器回调函数中的data
---@return string string 字符串
---事件中的字符串
function y3.string_in_event(data)
    return data['__str1']
end

---@return unit unit 单位
---运动器碰撞单位
function y3.mover_collision_unit()
    local py_unit = game_api.get_mover_collide_unit()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param data table 触发器回调函数中的data
---@return unit unit 单位
---获取可破坏物事件中的单位
function y3.get_unit_in_destructible_event(data)
    local py_unit = game_api.get_unit_by_id(data['__unit_id_of_hurt_dest'])
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return path path 路径  
---遍历时选中的路径  
function y3.path_selected_in_picking()
    return
end

---@return number value 当前循环值
---获取当前循环
function y3.get_current_loop()
    return
end

---@param data table 触发器回调函数中的data
---@return number damage_type
---获取当前伤害类型  
function y3.get_current_damage_type(data)
    return data['__damage_type']
end

---@param data table 触发器回调函数中的data
---@return number role_res_key
---事件中的玩家资源类型
function y3.player_resource_type_involved_in_the_event(data)
    return data['__res_key']
end

---@param data table 触发器回调函数中的data
---@return unit_group unit_group 单位组
---事件中的单位组
function y3.unit_group_involved_in_the_event(data)
    local py_unit_group = data.unit_group
    return y3.unit_group.create_lua_unit_group_from_py(py_unit_group)
end

---@param data table 触发器回调函数中的data
---@return purchase store_key 平台道具
---当前平台道具
function y3.current_purchasable(data)
    local py_purchase = data['__store_key']
    return y3.purchase.get_lua_purchase_from_py(py_purchase)
end

---@param value number 实数
---@return number angle 角度
---实数转角度
function y3.convert_float_to_angle(value)
    return Fix32(value)
end

---@param value number 角度
---@return number value 实数
---角度转实数
function y3.convert_angle_to_float(value)
    return Fix32(value)
end

---@param value number 整数
---@return number 图片id
---整数转图片   
function y3.convert_integer_to_image(value)
    return
end

---@param ability ability 技能
---@param data table 触发器回调函数中的data
---@return number angel 方向
---获取技能释放方向
function y3.get_ability_cast_direction(ability, data)
    return ability.api_get_release_direction(data['__ability_runtime_id'])
end

---@return number role_res_key 玩家属性 
---遍历到的玩家属性 
function y3.picked_player_attributes()
    return
end

---@param data table 触发器回调函数中的data
---@return unit unit 单位
---可破坏物死亡事件中的单位
function y3.unit_in_destroy_destructible_event(data)
    local py_unit = game_api.get_unit_by_id(data['__unit_id_of_dest_killer'])
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param data table 触发器回调函数中的data
---@return unit unit 单位
---可破坏物受伤事件中的单位
function y3.unit_in_destructible_is_damaged_event(data)
    local py_unit = game_api.get_unit_by_id(data['__unit_id_of_hurt_dest'])
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param data table 触发器回调函数中的data
---@return unit unit 单位
---可破坏物被采集事件中的单位
function y3.unit_in_destructible_is_gathered_event(data)
    local py_unit = game_api.get_unit_by_id(data['__unit_id_in_dest_event'])
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param data table 触发器回调函数中的data
---@return number value 变化值
---可破坏物事件中的资源变化值
function y3.resource_change_value_in_destructible_event(data)
    return data['__res_chg_cnt_in_dest_event']
end

---@param data table 触发器回调函数中的data
---@return ability ability 技能对象
---可破坏物事件中的技能对象
function y3.ability_in_destructible_event(data)
    local py_ability = game_api.get_ability_by_id(data['__ability_in_dest_event'])
    return y3.ability.get_lua_ability_from_py(py_ability)
end

---@param data table 触发器回调函数中的data
---@return number count 个数
---可破坏物事件中的采集的玩家属性个数
function y3.number_of_player_attributes_gathered_in_destructible_event(data)
    return data['__role_res_cnt_in_event']
end

---@param data table 触发器回调函数中的data
---@return number 伤害值
---可破坏物事件中的伤害值
function y3.damage_value_in_destructible_event(data)
    return data['__damage_value_of_hurt_dest']
end

---@return number tech_key 科技
---遍历到的科技
function y3.picked_tech()
    return
end

---@return area area 区域
---遍历到的多边形区域
function y3.picked_polygon()
    return
end

---@return point point 点
---遍历到的点
function y3.picked_point()
    return
end

---@param data table 触发器回调函数中的data
---@return ability ability 技能
---获取事件中的技能
function y3.get_ability_by_unit_and_seq(data)
    return game_api.api_get_ability_by_unit_and_seq(data['__unit_id'], data['__ability_seq'])
end

---@param data table 触发器回调函数中的data
---@return unit unit 单位
---获取事件中的建造单位
function y3.get_build_unit(data)
    local py_unit = data['__build_unit_id']
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param data table 触发器回调函数中的data
---@return number value 数值
---获取本次治疗的数值（结算前）
function y3.get_healing_value_before_settlement(data)
    return data['__cured_value']
end

---@param data table 触发器回调函数中的data
---@return unit unit 单位
---获取运动器绑定单位
function y3.get_mover_bound_units(data)
    local py_unit = game_api.get_unit_by_id(data['mover_owner_unit'])
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param player player 玩家
---@return unit_group unit_group 所有单位
---属于某玩家的所有单位
function y3.all_units_belonging_to_specified_player(player)
    local py_unit_group = player.base.get_all_unit_id()
    return y3.unit_group.create_lua_unit_group_from_py(py_unit_group)
end

---@param unit_id number 单位类型
---@return unit_group unit_group 单位组
---指定单位类型的单位
function y3.unit_of_a_specified_unit_type(unit_id)
    local py_unit_group = game_api.get_units_by_key(unit_id)
    return y3.unit_group.create_lua_unit_group_from_py(py_unit_group)
end

---@param unit_group unit_group 单位组
---@param count number 数量
---@return unit_group unit_group 单位组
---单位组中随机整数个单位
function y3.integer_random_units_from_unit_group(unit_group, count)
    local py_unit_group = game_api.get_random_n_unit_in_group(unit_group.base(), count)
    return y3.unit_group.create_lua_unit_group_from_py(py_unit_group)
end

---@param unit_group unit_group 单位组
---@return number count 数量
---获取单位组中单位数量
function y3.number_of_units_in_unit_group(unit_group)
    return game_api.get_unit_group_num(unit_group.base())
end

---@param unit_group unit_group 单位组 
---@param unit_id number 单位类型
---@return number count 数量
---单位组中单位类型的数量
function y3.get_number_of_units_of_specified_type_in_unit_group(unit_group, unit_id)
    return game_api.get_num_of_unit_key_in_group(unit_group.base(), unit_id)
end

---@param unit_group unit_group 单位组
---@return unit unit 单位
---获取单位组内第一个单位
function y3.get_the_first_unit_in_a_unit_group(unit_group)
    local py_unit = game_api.get_first_unit_in_group(unit_group.base())
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param unit_group unit_group 单位组
---@return unit unit 单位
---获取单位组中随机一个单位
function y3.get_random_unit_from_unit_group(unit_group)
    local py_unit = game_api.get_random_unit_in_unit_group(unit_group.base())
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param unit_group unit_group 单位组
---@return unit unit 单位
---获取单位组内最后一个单位
function y3.get_last_unit_in_unit_group(unit_group)
    local py_unit = game_api.get_last_unit_in_group(unit_group.base())
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---单位组中某个状态的单位数量
function y3.get_number_of_units_in_specified_state_in_unit_group()
    return
end

---@param player_or_unit_group player_group|unit_group
---清空玩家组或单位组
function y3.clear(player_or_unit_group)
    game_api.clear_group(player_or_unit_group.base())
end

---@param sfx_id number 特效id
---@param duration number 持续时间
---@param player player 玩家
---@param is_on_fog boolean 是否在迷雾上方
---创建屏幕特效
function y3.play_screen_particle_for_a_set_duration(sfx_id, duration, player, is_on_fog)
    game_api.add_sfx_to_camera_with_return(sfx_id, Fix32(duration), player.base(), is_on_fog)
end

---@param point point 点
---@param area area 区域
---@return boolean 是否在区域内
---点是否在区域内
function y3.is_point_in_area(point, area)
    return game_api.judge_point_in_area(point.base(), area.base())
end

---@param value string 字符串
---@return boolean bool 布尔值
---字符串转布尔值
function y3.string_to_bool(value)
    return global_api.str_to_bool(value)
end

---@return string weather 天气
---获取全局天气
function y3.get_global_weather()
    return game_api.get_global_weather()
end

---@param player player 玩家
---@param sound number 声音
---@param is_loop boolean 是否循环
---@param fade_in_time number 渐入时间
---@param fade_out_time number 渐出时间
---播放声音
function y3.play_sound_for_player(player, sound, is_loop, fade_in_time, fade_out_time)
    game_api.play_sound_for_player(player.base(), sound, is_loop, Fix32(fade_in_time), Fix32(fade_out_time))
end

---@param player player 玩家
---@param sound number 声音
---@param is_immediately boolean 是否立即停止
---停止播放声音
function y3.stop_sound_for_player(player, sound, is_immediately)
    game_api.stop_sound(player.base(), sound, is_immediately)
end

---@param player player 玩家
---@param sound number 声音
---@param point point 目标点
---@param height number 高度
---@param is_loop boolean 是否循环
---@param fade_in_time number 渐入时间
---@param fade_out_time number 渐出时间
---@param is_make_sure_play boolean 是否确保播放
---播放3D声音
function y3.play_3d_sound_for_player(player, sound, point, height, is_loop, fade_in_time, fade_out_time, is_make_sure_play)
    game_api.play_3d_sound_for_player(player.base(), sound, point.base(), Fix32(height), is_loop, Fix32(fade_in_time), Fix32(fade_out_time), is_make_sure_play)
end

---@param player player 玩家
---@param sound number 声音
---@param unit unit 跟随的单位
---@param is_loop boolean 是否循环
---@param fade_in_time number 渐入时间
---@param fade_out_time number 渐出时间
---@param is_make_sure_play boolean 是否确保播放
---跟随单位播放声音
function y3.follow_object_play_3d_sound_for_player(player, sound, unit, is_loop, fade_in_time, fade_out_time, is_make_sure_play)
    game_api.follow_object_play_3d_sound_for_player(player.base(), sound, unit.base(), is_loop, Fix32(fade_in_time), Fix32(fade_out_time), is_make_sure_play)
end

---@param player player 玩家
---@param sound number 声音
---@param value number 音量
---设置声音音量
function y3.set_sound_volume(player, sound, value)
    game_api.set_sound_volume(player.base(), sound, value)
end

---@param player player 玩家
---@param key number 按键
---@return boolean 是否被按下
---玩家键盘按键是否被按下
function y3.player_keyboard_key_is_pressed(player, key)
    return game_api.player_key_is_pressed(player.base(), key)
end

---@param player player 玩家
---@param key string 键
---@return boolean 是否被按下
---玩家鼠标是否被按下
function y3.player_mouse_key_is_pressed(player, key)
    return game_api.player_key_is_pressed(player.base(), key)
end

---@param type number 日志类型
---@param information string 信息
---打印日志
function y3.print_to_dialog(type, information)
    game_api.print_to_dialog(type, information, nil)
end

---@param information string 信息
---@param time number 持续时间
---显示接口测试信息
function y3.test_show_message_tip(information, time)
    game_api.api_test_show_msg_tip(information, Fix32(time))
end

---@param information string 信息
---@param time number 持续时间
---@param is_center boolean 是否居中
---记录API测试日志(可选显示)
function y3.test_log_message(information, time, is_center)
    game_api.api_test_log_msg(information, Fix32(time), is_center)
end

---@param assert_result boolean 断言结果
---@param information string 说明信息
---接口测试向日志添加断言结果
function y3.test_add_log_assert_result(assert_result, information)
    game_api.api_test_add_log_assert_result(assert_result, information)
end

---@param obj ability|modifier|item|unit 实例
---@return number id icon图片id
---获取技能/魔法效果/物品/单位的icon图标的图片
function y3.get_icon_id(obj)
    game_api.get_icon_id(obj.base())
end

---@param player player 玩家
---@param tech_type number 科技类型
---@return boolean is_success 是否满足
---检查科技类型前置条件
function y3.check_tech_key_precondition(player, tech_type)
    return game_api.check_tech_key_precondition(player.base(), tech_type)
end

---@param str1 string 字符串1
---@param str2 string 字符串2
---@return string result 结果字符串
---字符串拼接
function y3.joint_string(str1, str2)
    return global_api.join_s(str1, str2)
end

---@param str string 要截取的字符串
---@param start_pos number 起始位置
---@param end_pos number 终止位置
---@return string result 结果字符串
---截取字符串
function y3.extract_string(str, start_pos, end_pos)
    return game_api.extract_str(str, start_pos, end_pos)
end

---@param str string 字符串
---@param sub_str string 子字符串
---@param is_once boolean 是否只删一次
---@return string result 结果字符串
---删除子字符串
function y3.delete_sub_string(str, sub_str, is_once)
    return game_api.delete_sub_str(str, sub_str, is_once)
end

---@param key string 多语言key
---@return string 多语言内容
---获取多语言内容
function y3.get_text_config(key)
    return game_api.get_text_config(key)
end

---@param pool table 随机池
---@param value number 指定整数
---@return number value 权重概率
---获取随机池中指定整数的权重概率
function y3.get_random_pool_probability(pool, value)
    return game_api.get_random_pool_probability(pool, value):float()
end

---@param pool table 随机池
---@return number 随机的整数
---从随机池中获取一个随机整数
function y3.get_int_value_from_random_pool(pool)
    return game_api.get_bitrary_random_pool_value(pool)
end

---@param pool table 随机池
---@return number 随机的整数
---获取随机池总权重
function y3.get_random_pool_all_weight(pool)
    return game_api.get_random_pool_all_weight(pool)
end

---@param pool table 随机池
---@return number 整数数量
---获取随机池中的整数数量
function y3.get_random_pool_size(pool)
    return game_api.get_random_pool_size(pool)
end

---@param pool table 随机池
---@param value number 指定整数
---@return number weight 权重
---获取随机池中指定整数的权重
function y3.get_random_pool_pointed_weight(pool, value)
    return game_api.get_random_pool_pointed_weight(pool, value)
end

---@param point point 点
---@return number height 层级
---获取地图在该点位置的层级
function y3.get_point_ground_height(point)
    return game_api.get_point_ground_height(point.base())
end

---@return number seed 随机种子
---获取随机种子
function y3.get_random_seed()
    return game_api.get_random_seed()
end

---@return number time_stamp 时间戳
---获取游戏开始时间戳
function y3.get_game_init_time_stamp()
    return game_api.get_game_init_time_stamp()
end

---@return number x_resolution 横向分辨率
---获取初始化横向分辨率
function y3.get_game_x_resolution()
    return game_api.get_game_x_resolution()
end

---@return number y_resolution 纵向分辨率
---获取初始化纵向分辨率
function y3.get_game_y_resolution()
    return game_api.get_game_y_resolution()
end

---@return number quality 画质
---获取初始化游戏画质
function y3.get_graphics_quality()
    return game_api.get_graphics_quality()
end

---@return number mode 窗口类别
---获取初始化窗口类别
function y3.get_window_mode()
    return game_api.get_window_mode()
end

---@param value number 数字
---@return string str 字符串
---数字转字符串
function y3.number_to_str(value)
    if type(value) == 'Fix32' then
        
    end
    return tostring(value)
end

---@param list userdata 数组变量
---遍历数组变量
function y3.list_loop(list)
    local lua_table ={}
    local py_list = global_api.list_index_iterator(list)
    for i = 0, python_len(py_list)-1 do
        local var = python_index(py_list,i)
        table.insert(lua_table,var)
    end
    return lua_table
end

---@param is_only_gold boolean 是否只遍历货币
---遍历玩家属性
function y3.iter_role_res(is_only_gold)
    local res_table ={}
    local py_list = game_api.iter_role_res(is_only_gold)
    for i = 0, python_len(py_list)-1 do
        table.insert(res_table,python_index(py_list,i))
    end
    return res_table
end

---@param func_name string 方法枚举
---@param actor userdata 数组变量
---@param key string 变量名
---@param index integer 索引
---@param var userdata 变量
---设置变量
function y3.set_lua_var(func_name,actor,key,index,var)
    return game_api.set_lua_var(func_name, actor, key, index, var)
end

---@param func_name string 方法枚举
---@param key string 变量名
---@param index integer 索引
---获取变量
function y3.get_lua_var(func_name,key,index)
    return game_api.get_lua_var(func_name, key, index)
end

---@param key string 变量名
---@param value userdata 值
---@param boolean if_list 是否数组
---LUA层初始化参数
function y3.init_lua_var(key,value,if_list)
    return game_api.init_lua_var(key, value, if_list)
end

---退出游戏
function y3.exit_game(player)
    game_api.exit_game(player and player.base() or nil)
end

---@param player player 玩家
---@param signal_enum number 信号枚举值
---@param point point 点
---@param visible_enum point 可见性枚举值
---发送信号
function y3.send_signal(player,signal_enum,point,visible_enum)
    game_api.send_signal(player.base(),signal_enum,point.base(),visible_enum)
end

---发送自定义事件
function y3.send_custom_event(id,table)
    game_api.send_event_custom(id,table)
end

---@param target_unit number 伤害者
---@param ability ability 来源关联技能
---@param from unit|item 来源单位或者物品
---@param type number 伤害类型
---@param damage number 伤害值
---@param is_bounce boolean 是否跳字
---@param is_normal boolean 视为普攻
---@param is_critical boolean 必定暴击
---@param is_cant_miss boolean 无视闪避
---@param particle particle 受击特效
---@param socket_name string 挂接点
---@param txt_enum string 跳字枚举
---造成伤害
function y3.apply_damage(from,ability,target_unit,type,damage,is_bounce,is_normal,is_critical,is_cant_miss,particle,socket_name,txt_enum)
    game_api.apply_damage(from and from.base() or nil,ability and ability.base() or nil,target_unit and target_unit.base() or nil,type, Fix32(damage),is_bounce,nil,is_normal,is_critical,is_cant_miss,particle,socket_name,txt_enum)
end

---@param point_or_unit point|unit 点或单位
---@param range number 范围
---@return boolean in_radius 在单位附近
---在附近
function y3.is_in_radius(point_or_unit, range, unit)
    return game_api.api_is_in_range(point_or_unit.base(), Fix32(range))
end

function y3.call_any_api_3(funcname,p1,p2,p3)
    return game_api.call_any_api_3(funcname,p1,p2,p3)
end

function y3.call_any_api_1(funcname,p1)
    return game_api.call_any_api_1(funcname,p1)
end

function y3.call_any_api_2(funcname,p1,p2)
    return game_api.call_any_api_2(funcname,p1,p2)
end

function y3.call_any_api_4(funcname,p1,p2,p3,p4)
    return game_api.call_any_api_4(funcname,p1,p2,p3,p4)
end

---@param value number 治疗值
---设置当前治疗值
function y3.set_cure_value(value)
    game_api.set_cur_cure_value(Fix32(value))
end

---@param str string 字符串
---字符串转界面事件
function y3.str_to_ui_event(str)
    return global_api.str_to_ui_event(str)
end


---任意变量转字符串
function y3.any_var_to_str(p1,p2)
    if not ToString[p1] then
        return global_api.to_str_default(p2)
    end
    return ToString[p1](p2)
end

---@param name string 表名
---@return table tb 表
---获得表
function y3.get_table(name)
    return game_api.get_table(name)
end
---@param data table 触发器回调函数中的data
---@return point point 点
---获取事件中的点
function y3.get_point_from_event(data)
    local py_point = data['__point']
    return y3.get_lua_point_from_py(py_point)
end

---@param data table 触发器回调函数中的data
---@return point command 点
---获取事件中的单位命令
function y3.get_unit_command_from_event(data)
    local py_command = data['__cmd_type']
    return py_command
end

---表是否存在字段
function y3.is_exist_key(table,key)
    return game_api.table_has_key(table,key)
end

function y3.set_globale_view(enable)
    game_api.enable_fow_for_player(enable)
end

function y3.get_custom_param(data,name)
    return game_api.get_custom_param(data['__c_param_dict'], name)
end

function y3.request_server_time(func,context)
    game_api.lua_request_message_from_server(func,context)
end

---@param obj unit|item|point|area 各种对象
---@param key string 字段
---@return point command 点
---是否存在字段
function y3.api_has_kv_any(obj,key)
    return global_api.api_has_kv_any(obj and obj.base() or nil,key)
end

---获取本地玩家
function y3.get_client_player()
    return y3.player(game_api.get_owner_role_id())
end

---设置对象基础材质颜色
function y3.set_object_color(obj,r,g,b,a)
    game_api.api_change_obj_base_color(obj.base(),r,g,b,a)
end

---清空表
function y3.clear_table(table)
    game_api.clear_table(table)
end

---遍历物品类型的物品合成材料
function y3.pick_item_type(item_id)
    local lua_table ={}
    local py_list = game_api.iter_compose_item_res_of_item_name(item_id)
    for i = 0, python_len(py_list)-1 do
        table.insert(lua_table,python_index(py_list,i))
    end
    return lua_table
end

---遍历物品类型的玩家合成材料
function y3.pick_item_player_attr(item_id)
    local lua_table ={}
    local py_list = game_api.iter_compose_role_attr_of_item_name(item_id)
    for i = 0, python_len(py_list)-1 do
        local player_attr = python_index(py_list,i)
        table.insert(lua_table,player_attr)
    end
    return lua_table
end

--物品类型合成所需的物品类型数量
function y3.get_num_of_item_mat(item_key, comp_item_key)
    return game_api.api_get_value_of_item_name_comp_mat(item_key, comp_item_key)
end

--物品类型合成所需的玩家属性数量
function y3.get_num_of_player_attr(item_key, role_res_key)
    return game_api.api_get_value_of_item_name_comp_res(item_key, role_res_key)
end

---获取返回的服务器时间(年)
function y3.get_server_year(v)
    return global_api.get_year_of_server_timestamp(v)
end
---获取返回的服务器时间(月)
function y3.get_server_month(v)
    return global_api.get_month_of_server_timestamp(v)
end
---获取返回的服务器时间(日)
function y3.get_server_day(v)
    return global_api.get_day_of_server_timestamp(v)
end
---获取返回的服务器时间(小时)
function y3.get_server_hour(v)
    return global_api.get_hour_of_server_timestamp(v)
end

---@param mainString string 母字符串
---@param findString string 被替换的字符串
---@param replaceString string 替换目标字符串
---@param num integer 最大替换次数
---@return string str 字符串
---字符串替换
function y3.string_gsub(mainString,findString,replaceString,num)
    return global_api.replace_str(mainString,findString,replaceString,num)
end

---@param value1 number 数值1
---@param value2 number 数值2
---@param value3 number 数值3
---@---@return boolean bool 是否在区间内
---区间内判断
function y3.get_number_interval(value1,value2,value3)
    return ((Fix32(value1) <= Fix32(value2)) and (Fix32(value2) <= Fix32(value3)))
end

---@param fps integer 帧率
---设置逻辑帧率
function y3.set_logic_fps(fps)
    game_api.api_change_logic_fps(fps)
end

---@param tab table 表
---加密表
function y3.encrypt_table(tab)
    game_api.encrypt_table(tab)
end

---@param enable boolean 是否关闭
---关闭localplayer的表现层跳字
function y3.set_jump_word(enable)
    game_api.set_local_player_jump_word_close(enable)
end

---@param player player 玩家
---@param switch boolean 是否关闭
---特效播放开关
function y3.sfx_switch(player,switch)
    game_api.set_player_sfx_switch(player and player.base() or nil,switch)
end

---@param area area 区域
---注册区域的附近语音频道
function y3.reg_sound_area(area)
    game_api.reg_sound_area(area and area.base() or nil)
end

---@param area area 区域
---注销区域的附近语音频道
function y3.unreg_sound_area(area)
    game_api.unreg_sound_area(area and area.base() or nil)
end

---@param switch boolean 是否关闭
--设置附近语音的区域模式开关
function y3.set_nearby_voice_mode(switch)
    game_api.set_nearby_voice_mode(switch)
end

---@param player player 玩家
---@param switch boolean 是否关闭
--设置玩家的附近语音聊天收听开关
function y3.set_nearby_sound_switch(player,switch)
    game_api.set_nearby_sound_switch(player and player.base(),switch)
end

---@param player player 玩家
---@param switch boolean 是否关闭
--设置玩家的附近语音聊天发言开关
function y3.set_nearby_micro_switch(player,switch)
    game_api.set_nearby_micro_switch(player and player.base(),switch)
end

---@param player player 玩家
---@param unit unit 是否关闭
---设置玩家的声音主单位
function y3.set_role_micro_unit(player,unit)
    game_api.set_role_micro_unit(player and player.base(),unit and unit.base())
end

---@param player player 玩家
---关闭玩家的附近语音聊天
function y3.close_role_micro_unit(player)
    game_api.close_role_micro_unit(player and player.base())
end

---@param player player 玩家
---@param switch boolean 是否关闭
---设置玩家的同阵营语音聊天收听开关
function y3.set_role_camp_sound_switch(player,switch)
    game_api.set_role_camp_sound_switch(player and player.base(),switch)
end

---@param player player 玩家
---@param switch boolean 是否关闭
---设置玩家的同阵营语音聊天发言开关
function y3.set_role_camp_micro_switch(player,switch)
    game_api.set_role_camp_micro_switch(player and player.base(),switch)
end

---@param player player 玩家
---@param switch boolean 是否关闭
---设置玩家的所有人语音聊天收听开关
function y3.set_role_all_sound_switch(player,switch)
    game_api.set_role_all_sound_switch(player and player.base(),switch)
end

---@param player player 玩家
---@param switch boolean 是否关闭
---设置玩家的所有人语音聊天发言开关
function y3.set_role_all_micro_switch(player,switch)
    game_api.set_role_all_micro_switch(player and player.base(),switch)
end

function y3.get_table_var(table,key1, key2, key3, key4, key5,default_value, value_convert_func)
    return game_api.get_table_var(table,key1, key2, key3, key4, key5,default_value, value_convert_func)
    --y3.get_table_var(y3.get_table('kv2'), 1, nil, nil, nil, nil, '', '')
end

---@param var var 变量
---获取数组变量的最大索引
function y3.len_of_var(var)
    return game_api.len_of_var(var)
end

---@param obj unit|item|dest 对象
---设置聂菲尔效果开关
function y3.set_fresnel_visible(obj, is_open)
    game_api.api_set_obj_fresnel_visible(obj and obj.base() or nil, is_open)
end

---@param obj unit|item|dest 对象
---@param red number 红色
---@param green number 绿色
---@param blue number 蓝色
---@param alpha number 透明度
---@param exp number 菲涅尔指数
---@param strength number 菲涅尔强度
---设置聂菲尔效果
function y3.set_fresnel_value(obj, red,green,blue,alpha,exp,strength)
    game_api.api_set_obj_fresnel_parameters(obj and obj.base() or nil, red,green,blue,alpha,exp,strength)
end

---@param data pylist python列表
---获取前置条件遍历到的科技类型
function y3.get_precondition_tech_key(data)
    return game_api.get_pre_condition_iter_tech_key(data)
end

---@param data pylist python列表
---获取前置条件遍历到的科技标签
function y3.get_precondition_tech_tag(data)
    return game_api.get_pre_condition_iter_tech_tag(data)
end

---@param unit_key1 number 检测的单位
---@param unit_key2 number 查询的单位类型
---@return number value 需求值 
---获取单位单位类型前置条件的需求值
function y3.get_unit_type_unit_key_pre_condition_require_count(unit_key1,unit_key2)
    return game_api.get_unit_type_unit_key_pre_condition_require_count(unit_key1, unit_key2)
end

---@param unit_key1 number 检测的单位
---@param tag string 查询的单位标签
---@return number value 需求值 
---获取单位单位标签前置条件的需求值
function y3.get_unit_type_unit_tag_pre_condition_require_count(unit_key1,tag)
    return game_api.get_unit_type_unit_tag_pre_condition_require_count(unit_key1, tag)
end

---@param unit_key1 number 检测的单位
---@param tech number 查询的科技类型
---@return number value 需求值 
---获取单位科技类型前置条件的需求值
function y3.get_unit_type_tech_key_pre_condition_require_count(unit_key1,tech)
    return game_api.get_unit_type_tech_key_pre_condition_require_count(unit_key1, tech)
end

---@param unit_key1 number 检测的单位
---@param tech string 查询的科技标签
---@return number value 需求值 
---获取单位科技标签前置条件的需求值
function y3.get_unit_type_tech_tag_pre_condition_require_count(unit_key1,tech)
    return game_api.get_unit_type_tech_tag_pre_condition_require_count(unit_key1, tech)
end

---@param point point 点
function y3.get_texture(point)
    return game_api.get_texture_type(point and point.base() or nil)
end

---@param mover mover 运动器
---@return integer type 类型 
function y3.get_mover_type(mover)
    return game_api.get_mover_type(mover)
end

---@param AbilityKey number 检测的技能
---@param unit_key2 number 查询的单位类型
---@return number value 需求值 
---获取技能单位类型前置条件的需求值
function y3.get_ability_type_unit_key_pre_condition_require_count(AbilityKey,unit_key2)
    return game_api.get_ability_type_unit_key_pre_condition_require_count(AbilityKey, unit_key2)
end

---@param AbilityKey number 检测的技能
---@param tag string 查询的单位标签
---@return number value 需求值 
---获取技能单位标签前置条件的需求值
function y3.get_ability_type_unit_tag_pre_condition_require_count(AbilityKey,tag)
    return game_api.get_ability_type_unit_tag_pre_condition_require_count(AbilityKey, tag)
end

---@param AbilityKey number 检测的技能
---@param tech number 查询的科技类型
---@return number value 需求值 
---获取技能科技类型前置条件的需求值
function y3.get_ability_type_tech_key_pre_condition_require_count(AbilityKey,tech)
    return game_api.get_ability_type_tech_key_pre_condition_require_count(AbilityKey, tech)
end

---@param AbilityKey number 检测的技能
---@param tech string 查询的科技标签
---@return number value 需求值 
---获取技能科技标签前置条件的需求值
function y3.get_ability_type_tech_tag_pre_condition_require_count(AbilityKey,tech)
    return game_api.get_ability_type_tech_tag_pre_condition_require_count(AbilityKey, tech)
end

---@param ItemKey number 检测的物品
---@param unit_key2 number 查询的单位类型
---@return number value 需求值 
---获取物品单位类型前置条件的需求值
function y3.get_item_type_unit_key_pre_condition_require_count(ItemKey,unit_key2)
    return game_api.get_item_type_unit_key_pre_condition_require_count(ItemKey, unit_key2)
end

---@param ItemKey number 检测的物品
---@param tag string 查询的单位标签
---@return number value 需求值 
---获取物品单位标签前置条件的需求值
function y3.get_item_type_unit_tag_pre_condition_require_count(ItemKey,tag)
    return game_api.get_item_type_unit_tag_pre_condition_require_count(ItemKey, tag)
end

---@param ItemKey number 检测的物品
---@param tech number 查询的科技类型
---@return number value 需求值 
---获取物品科技类型前置条件的需求值
function y3.get_item_type_tech_key_pre_condition_require_count(ItemKey,tech)
    return game_api.get_item_type_tech_key_pre_condition_require_count(ItemKey, tech)
end

---@param ItemKey number 检测的物品
---@param tech string 查询的科技标签
---@return number value 需求值 
---获取物品科技标签前置条件的需求值
function y3.get_item_type_tech_tag_pre_condition_require_count(ItemKey,tech)
    return game_api.get_item_type_tech_tag_pre_condition_require_count(ItemKey, tech)
end

---@param modifier_id number 查询的科技标签
---@return string name 名称 
---获取魔法效果类型的名称
function y3.get_modifier_name(modifier_id)
    return game_api.api_get_name_of_modifier_key(modifier_id)
end

---@param ABILITY_NAME number 技能类型
---@param ABILITY_FORMULA_ATTRS number 公式类型属性
---@param level number 指定等级
---@param index number 指定充能层数
---@param unit number 单位
---@return string name 名称 
---获取技能类型公式属性-传入单位
function y3.get_ability_formula_attr(ABILITY_NAME,ABILITY_FORMULA_ATTRS,level,index,unit)
    return game_api.get_ability_conf_formula_attr_with_unit(ABILITY_NAME,ABILITY_FORMULA_ATTRS,level,index,unit and unit.base() or nil)
end

---组相关判等
function y3.equal_group(a, b, c)
    if b == '==' then
        return py_equal(a.base(),c.base())
    else
        return not py_equal(a.base(),c.base())
    end
end

---@param player player 技能类型
---@param sound sound 声音
---@param operation integer 控制枚举
---播放控制
function y3.sound_controller(player, sound, operation)
    game_api.sound_play_controller(player.base(),sound,operation)
end

---@param player player 玩家
---@param unit unit 单位
---设置相机透视射线的焦点单位
function y3.set_camera_perspective_ray_unit(player,unit)
    game_api.set_camera_perspective_ray_unit(player.base(),unit.base())
end

---@param level_id_str number  关卡ID
---切换至关卡
function y3.switch_level(level_id_str)
    game_api.request_switch_level(level_id_str)
end

---@param role player  玩家
---@param cam_mod integer  镜头模式
---@param ortho_scale number  正交缩放
---设置玩家镜头模式
function y3.set_camera_mode(role, cam_mod, ortho_scale)
    game_api.api_set_role_camera_mode(role, cam_mod, ortho_scale)
end

---@param area area  区域
---@param player player  玩家
---@param fog_state integer  迷雾状态
---@param is_vision_true boolean  布尔变量
---生成战争迷雾
function y3.set_fog_state(area,player,fog_state, is_vision_true)
    game_api.set_fog_state(area,player,fog_state, is_vision_true)
end

---@param ientity unit  单位
---@param spine string  骨骼名
---@param vertical boolean  垂直
---@param rate number  系数
---单位绑定2D骨骼动画
function y3.create_spine(ientity, spine, vertical, rate)
    game_api.create_spine(ientity.base(), spine, vertical, rate)
end

---@param unit unit  单位
---让单位看向镜头
function y3.look_at_camera(unit)
    game_api.cc_look_at_camera(unit.base())
end

---@param unit unit  单位
---@param t_unit unit  目标单位
---让单位看向指定单位
function y3.look_at_unit(unit,t_unit)
    game_api.cc_look_at_other_unit(unit.base(),t_unit.base())
end

---@param unit unit  单位
---取消单位的看向动作
function y3.cancel_look_at(unit)
    game_api.cc_cancel_look_at(unit.base())
end

---@param sfx_entity beam  链接特效
---@param role player  玩家
---@param b_visible boolean  可见性
---设置链接特效可见性
function y3.enable_link_sfx_visible(sfx_entity, role,b_visible)
    game_api.enable_link_sfx_visible(sfx_entity.base(), role.base(),b_visible)
end

---@param sfx_entity particle  特效
---@param role player  玩家
---@param b_visible boolean  可见性
---设置特效可见性
function y3.enable_sfx_visible(sfx_entity, role,b_visible)
    game_api.enable_sfx_visible(sfx_entity.base(), role.base(),b_visible)
end

---@param level_id_str number  关卡ID
---切换至关卡
function y3.set_model_comp_camera_mod(level_id_str)
    game_api.set_model_comp_camera_mod(level_id_str)
end

---@param enable boolean 开关
---@param detect_range number 检测范围
---设置镜头是否跟随地形高度浮动
function y3.set_camera_floating_with_terrain(enable,detect_range)
    game_api.set_camera_floating_with_terrain(enable,detect_range or 3)
end

---调试暂停
function y3.pause()
    game_api.api_debug_pause()
end

---@param is_critical boolean 是否暴击
---设置当前是否暴击
function y3.set_cur_damage_is_critical(is_critical)
    game_api.set_cur_damage_is_critical(is_critical)
end

---@param  player number 红色
---@param  name number 透明度
---@return string id 控件ID
---设置图片颜色
function y3.get_ui_id(player, name)
    return game_api.get_ui_comp_id_by_name(player.base(), name)
end

---@param  tab table 表
---@return boolean is_empty 是否空表
---是否为空表
function y3.is_table_empty(tab)
    return game_api.is_table_empty(tab)
end


---@param  var list 数组变量
---清空组/数组变量
function y3.clear_group(var)
    game_api.clear_group(var)
end

---@param  var list 数组变量
---@param  index integer 索引
---删除数组条目
function y3.remove_list_var(var,index)
    game_api.remove_list_var_item(var,index)
end

---@param  id integer 计时器编号
---@param  count integer 剩余次数
---设置计时器剩余次数
function y3.set_left_count(id,count)
    game_api.timer_set_left_count(id,count)
end

---@param  id integer 计时器编号
---@param  time number 剩余时间
---设置计时器剩余时间
function y3.set_left_time(id,time)
    game_api.timer_set_left_time(id,Fix32(time))
end

---@param  id integer 计时器编号
---@param  time integer 间隔时间
---设置计时器间隔时间
function y3.set_interval_time(id,time)
    game_api.timer_set_interval_time(id,Fix32(time))
end

---@param  id integer 计时器编号
---@param  tick integer 间隔帧数
---设置帧计时器间隔帧数
function y3.set_interval_frame(id,tick)
    game_api.timer_set_interval_frame(id,tick)
end

---@param  key integer 原始按键
---@param  target_key integer 目标按键
---设置本地改键
function y3.set_local_mapping_key(key, target_key)
    game_api.api_set_local_mapping_key(key, target_key)
end

---@param  key integer 原始按键
---取消本地改键
function y3.api_cancel_local_mapping_key(key)
    game_api.api_cancel_local_mapping_key(key)
end

---清空本地改键
function y3.clear_local_mapping_key()
    game_api.api_clear_local_mapping_key()
end

---@param  unit unit 原始按键
---@param  radius number 原始按键
---获取单位指定距离内的随机单位
function y3.get_random_unit_around(unit, radius)
    local py_unit = game_api.cc_get_random_unit_around(unit.base(), Fix32(radius))
    return unit.get_lua_unit_from_py(py_unit)
end

---@return integer id 场景ID
---@param area area 区域
---获取区域的场景ID
function y3.get_area_resource_id(area)
    return game_api.get_area_resource_id(area.base())
end

---@return integer id 场景ID
---@param path path 路径
---获取路径的场景ID
function y3.get_road_resource_id(path)
    return game_api.get_road_resource_id(path.base())
end

---@param item_group path 路径
---@return item item 物品
---物品组中随机物品
function y3.get_random_item_in_item_group(item_group)
    local py_item = game_api.api_get_random_item_in_item_group(item_group)
    return y3.item.get_lua_item_from_py(py_item)
end

---@param attr_name string 属性名
---@return number attr 实数属性
---获取本地玩家镜头的实数属性
function y3.get_camera_attr_real_num(attr_name)
    return game_api.get_camera_attr_real_num(attr_name)
end

---@param attr_name string 属性名
---@return integer attr 整数属性
---获取本地玩家镜头的整数属性
function y3.get_camera_attr_integer(attr_name)
    return game_api.get_camera_attr_integer(attr_name)
end

---@param modifier modifier 魔法效果类型
---@return string modifier_name 魔法效果类型的名称
---获取魔法效果类型的名称
function y3.get_modifier_name_by_type(modifier)
    return game_api.get_modifier_name_by_type(modifier)
end