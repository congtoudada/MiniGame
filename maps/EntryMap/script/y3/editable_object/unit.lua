--- File Name : unit.lua
--- Description: 单位相关逻辑 对应编辑器---单位

local setmetatable = setmetatable
local ipairs = ipairs

---@class unit
local unit = {}
unit.__index = unit
y3.unit = unit
unit.type = 'unit'

function unit:__tostring()
    return ('%s %s %s'):format('unit', self:get_name(), tostring(self.base))
end

---所有单位实例
-- local Units = {}
local Units = setmetatable({}, { __mode = 'kv' })
---所有触发器组
local TriggerGroups = {}

---@param scene_id number 场景Id
---@return unit lua层unit
---根据场景id得到unit实例
function y3.get_unit_by_scene_id(scene_id)
    local py_unit = game_api.get_unit_by_id(scene_id)
    return unit.get_lua_unit_from_py(py_unit)
end

---@param group table 物编触发器组
---@param unit_id number 物编单位id
---初始化物编触发器组
local function trigger_group_init(group, unit_id)
    group.add_trigger = function(event_name, action)
        -- local enum, params = event_manager.get_enum_and_params(event_name, event_enum.unit)
        local trigger_id = y3.trigger.get_trigger_id()
        local py_trigger = new_unit_trigger(unit_id, trigger_id, event_name, event_name, true)
        function py_trigger.on_event(trigger, event, actor, data)
            --local lua_data = event_manager.get_lua_params(params, data)
            if EVENT_DATA[event_name] then
                action(_,EVENT_DATA[event_name](data))
            else
                action(_,data)
            end
        end
    end
end

---@param unit_id number 物编单位id
---@return trigger_group 触发器组
---按照单位物编id创建单位触发器组
function unit.create_unit_trigger_group(unit_id)
    if not TriggerGroups[unit_id] then
        TriggerGroups[unit_id] = {}
        trigger_group_init(TriggerGroups[unit_id], unit_id)
    end
    return TriggerGroups[unit_id]
end

---@param  py_unit table py层的道具实例
---@return table 返回在lua层初始化后的lua层道具实例
---通过py层的技能实例获取lua层的道具实例
function unit.get_lua_unit_from_py(py_unit)
    if not py_unit then
        return
    end
    local id
    if type(py_unit) == 'number' then
        id = py_unit
        py_unit = game_api.get_unit_by_id(py_unit)
    else
        id = py_unit.api_get_id()
    end
    local py = py_obj.new(py_unit)
    if not Units[id] then
        local new_unit = {}
        setmetatable(new_unit, unit)
        new_unit.base = py
        new_unit.id = id
        Units[id] = new_unit
    end
    return Units[id]
end

---返回空单位
function unit.get_nil_unit()
    if not Units[0] then
        local new_unit = {}
        setmetatable(new_unit, unit)
        new_unit.base = py_obj.new(0)
        new_unit.id = 0
        Units[0] = new_unit
    end
    return Units[0]
end

---@param event_name string 事件名
---@param action function 事件触发时执行的方法
---添加触发器
function unit:add_trigger(event_name, action)
    local enum, params = event_manager.get_enum_and_params(event_name, event_enum.unit)
    local trigger_id = y3.get_trigger_id()
    local py_trigger = new_global_trigger(trigger_id, event_name, enum, true)
    function py_trigger.on_event(trigger, event, actor, data)
        if data.__unit_id:api_get_id() == self.id then
            --local lua_data = event_manager.get_lua_params(params, data)
            action(data)
        end
    end
end

---@return boolean is_exist 是否存在
---是否存在
function unit:is_destory()
    return game_api.unit_is_exist(self.base())
end

---@param type integer 技能类型
---@param id number 物编id
---移除技能(指定类型)
function unit:remove_abilitiy(type, id)
    self.base():api_remove_abilities_in_type(type, id)
end

---@param item_id number 物品id
---单位添加物品
function unit:add_item(item_id)
    self.base():api_add_item(item_id)
end

---@param item_id number 物品id
---单位移除物品
function unit:remove_item(item_id)
    self.base():api_delete_item(item_id, 1) --TODO:需要确认这个1是啥，大概是数量？
end

---@param item item 物品
---@param type number 背包槽位类型
---@param position number 槽位
---@param is_occupy boolean 槽位被占是否转移
---转移物品 type1 物品栏 type2背包栏
function unit:shift_item(item, type, position, is_occupy)
    self.base():api_shift_item_new(item.base(), type, position, is_occupy) --TODO:需要确认 槽位被占是否转移 这个的英文
end

---@param type integer 技能类型
---@return table 指定类型的技能
---获取指定类型的技能
function unit:get_abilities_by_type(type)
    local abilities = {}
    local py_list = self.base():api_get_abilities_by_type(type)
    for i = 0, python_len(py_list) - 1 do
        local lua_ability = y3.ability.get_lua_ability_from_py(python_index(py_list, i))
        table.insert(abilities, lua_ability)
    end
    return abilities
end

---@param type integer 技能类型
---@return table modifiers 魔法效果表
---获取单位上的魔法效果
function unit:get_modifier()
    local modifiers = {}
    local py_list = self.base():api_get_all_modifiers()
    for i = 0, python_len(py_list) - 1 do
        local lua_modifier = y3.modifier.get_lua_modifier_from_py(python_index(py_list, i))
        table.insert(modifiers, lua_modifier)
    end
    return modifiers
end

---@param ability_1 ability 第一个技能
---@param ability_2 ability 第二个技能
---交换技能位置
function unit:switch_ability(ability_1, ability_2)
    self.base():api_switch_ability(ability_1.base(), ability_2.base())
end

---@param type_1 number 第一个技能类型
---@param slot_1 number 第一个技能坑位
---@param type_2 number 第二个技能类型
---@param slot_1 number 第二个技能坑位
---根据坑位交换技能
function unit:switch_ability_by_slot(type_1, slot_1, type_2, slot_2)
    self.base():api_switch_ability_by_index(type_1, slot_1, type_2, slot_2)
end

---停止所有技能
function unit:stop_all_abilities()
    self.base():stop_all_abilities()
end

---@param type integer 技能类型
---@param id number 物编id
---@param slot number 技能位
---@param level number 等级
---添加技能
function unit:add_ability(type, id, slot, level)
    self.base():api_add_ability(type, id, slot, level)
end

---@param type number 技能位
---@param slot number 等级
---移除技能
function unit:remove_ability(type, slot)
    self.base():api_remove_ability_by_index(type, slot)
end

---@param type integer 技能类型
---@param ability_type number 技能类型id(物编id)
---@return ability ability 技能
---通过技能名寻找技能
function unit:find_ability(type, ability_type)
    local py_ability = self.base():api_get_ability_by_type(type, ability_type)
    return y3.ability.get_lua_ability_from_py(py_ability)
    --return self.base():api_get_ability_by_type(type, ability_type)
end

---@param type integer 技能类型
---@param slot number 技能位
---@return ability ability 技能
---获得某个技能位的的技能
function unit:get_ability_by_slot(type, slot)
    --return self.base():api_get_ability(type, slot)
    local py_ability = self.base():api_get_ability(type, slot)
    return y3.ability.get_lua_ability_from_py(py_ability)
end

---@param type number 背包槽类型
---@param slot number 位置
---@return item item 物品
---获取单位背包槽位上的物品
function unit:get_item_by_slot(type, slot)
    local py_item = self.base():api_get_item_by_slot(type, slot)
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item_group item_group 所有物品
---单位的所有物品
function unit:get_all_items()
    local py_item_group = self.base():api_get_all_item_pids()
    return y3.item_group.create_lua_item_group_from_py(py_item_group)
end

---@param TECH_KEY number 科技类型
---@return table tech 科技
---单位获得科技
function unit:unit_gains_tech(TECH_KEY)
    return self.base():api_add_tech(TECH_KEY)
end

---@param unit_id number 单位类型
---@param point point 点
---@param direction number 方向
---创建单位
function unit.create_unit(unit_id, point, direction, player)
    local py_unit = game_api.create_unit(unit_id, point.base(), direction, player.base())
    return unit.get_lua_unit_from_py(py_unit)
end

---@param killer unit 凶手单位
---杀死单位
function unit:kill(killer)
    self.base():api_kill(killer)
end

---@return boolean has_running 正在释放技能
---单位是否有正在释放的技能
function unit:has_running_ability()
    return self.base():api_unit_has_running_ability()
end

-- ---造成伤害
-- function unit:apply_damage(target_unit,ability,from_unit,damage_enum,damage,isnormal,)
--     game_api.apply_damage(target_unit,ability,from_unit, DAMAGE_TYPE[damage_enum], Fix32(damage), isnormal, nil, true, true, true, 100001, "", "0")
-- end


---@param illusion_unit unit 幻象单位
---@param call_unit unit 召唤单位
---@param player player 玩家
---@param point point 点
---@param direction number 方向
---@param clone_hp_mp bool 是否继承HP和MP
---创建幻象
function unit.create_illusion(illusion_unit, call_unit, player, point, direction, clone_hp_mp)
    local py_unit = game_api.create_illusion(illusion_unit.base(), call_unit.base(), player.base(), point.base(),
        direction, clone_hp_mp)
    return unit.get_lua_unit_from_py(py_unit)
end

---删除单位
function unit:remove()
    self.base():api_delete()
end

---@param point point 点
---移动到点（瞬间）
function unit:blink(point)
    self.base():api_transmit(point.base())
end

---@param point point 点
---@param isSmooth boolean 是否丝滑
---强制移动
function unit:set_point(point, isSmooth)
    self.base():api_force_transmit_new(point.base(), isSmooth)
end

---@param point point 点
---复活单位
function unit:reborn(point)
    self.base():api_revive(point.base())
end

---@param value number 治疗值
---@param isShowTxt boolean 是否跳字
---@param skill ability 技能
---@param from_unit unit 单位
---@param txt_enum integer 跳字类型
---造成治疗
function unit:heals(value, isShowTxt, skill, from_unit, txt_enum)
    self.base():api_heal(value, isShowTxt, skill and skill.base() or nil, from_unit and from_unit.base() or nil, txt_enum)
end

---@param tag string 标签
---添加标签
function unit:add_tag(tag)
    self.base():api_add_tag(tag)
end

---@param tag string 标签
---移除标签
function unit:remove_tag(tag)
    self.base():api_remove_tag(tag)
end

---@param state_enum integer 状态名
---添加状态
function unit:add_state(state_enum)
    self.base():api_add_state(state_enum)
end

---@param state_enum integer 状态名
---移除状态
function unit:remove_state(state_enum)
    self.base():api_remove_state(state_enum)
end

---@param ability_id number 技能id
---学习技能
function unit:learn(ability_id)
    self.base():api_unit_learn_ability(ability_id)
end

---@param command string 命令
---发布命令
function unit:release_command(command)
    self.base():api_release_command(command)
end

---@param direction number 朝向
---@param turn_time number 转向时间
---设置朝向
function unit:set_facing(direction, turn_time)
    self.base():api_set_face_angle(Fix32(direction), turn_time)
end

---@param name string 名称
---设置名称
function unit:set_name(name)
    self.base():api_set_name(name)
end

---@param description string 描述
---设置描述
function unit:set_description(description)
    self.base():api_set_str_attr("desc", description)
end

---@param attrName string 属性名
---@param value number 属性值
---@param attrType string 属性类型
---设置属性
function unit:set(attrType, attrName, value)
    self.base():api_set_attr_by_attr_element(attrName, Fix32(value), attrType)
end

---@param attrName string 属性名
---@param value number 属性值
---@param attrType string 属性类型
---增加属性
function unit:add(attrType, attrName, value)
    self.base():api_add_attr_by_attr_element(attrName, Fix32(value), attrType)
end

---@param level number 等级
---设置等级
function unit:set_level(level)
    self.base():api_set_level(level)
end

---@param level number 等级
---增加等级
function unit:add_level(level)
    self.base():api_add_level(level)
end

---@param exp number 经验
---设置经验
function unit:set_exp(exp)
    self.base():api_set_exp(exp)
end

---@param exp number 经验
---增加经验值
function unit:add_exp(exp)
    self.base():api_add_exp(exp)
end

---@param hp number 当前生命值
---设置当前生命值
function unit:set_hp(hp)
    self.base():api_set_attr("hp_cur", Fix32(hp))
end

---@param hp number 当前生命值
---增加当前生命值
function unit:add_hp(hp)
    self.base():api_add_attr_base("hp_cur", Fix32(hp))
end

---@param mp number 当前魔法值
---设置当前魔法值
function unit:set_mp(mp)
    self.base():api_set_attr("mp_cur", Fix32(mp))
end

---@param mp number 当前魔法值
---增加当前魔法值
function unit:add_mp(mp)
    self.base():api_add_attr_base("mp_cur", Fix32(mp))
end

---@param skill_point number 技能点
---设置技能点
function unit:set_ability_point(skill_point)
    self.base():api_set_ability_point(skill_point)
end

---@param skill_point number 技能点
---增加技能点
function unit:add_ability_point(skill_point)
    self.base():api_add_ability_point(skill_point)
end

---@param player player 所属玩家
---设置所属玩家
function unit:change_owner(player)
    game_api.change_unit_role(self.base(), player.base())
end

---@param height number 高度
---@param trans_time number 过渡时间
---设置飞行高度
function unit:set_height(height, trans_time)
    self.base():api_raise_height(Fix32(height), Fix32(trans_time))
end

---@param time number 生命周期
---设置生命周期
function unit:set_life_cycle(time)
    self.base():api_set_life_cycle(Fix32(time))
end

---@param is_stop boolean 生命周期暂停状态
---设置生命周期暂停状态
function unit:pause_life_cycle(is_stop)
    self.base():api_pause_life_cycle(is_stop)
end

---@param range number 范围
---设置警戒范围
function unit:set_alert_range(range)
    self.base():api_set_unit_alarm_range(Fix32(range))
end

---@param range number 取消警戒范围
---设置取消警戒范围
function unit:set_cancel_alert_range(range)
    self.base():api_set_unit_cancel_alarm_range(Fix32(range))
end

---@param number number 槽位数
---设置背包栏的槽位数
function unit:set_pkg_cnt(number)
    self.base():api_set_unit_pkg_cnt(number)
end

---@param number number 槽位数
---设置物品栏的槽位数
function unit:set_bar_cnt(number)
    self.base():api_set_unit_bar_cnt(number)
end

---@param behavior string 单位行为
---设置默认单位行为
function unit:set_behavior(behavior)
    self.base():api_set_default_switch_behavior(behavior)
end

--******************************************
---@param unit_id string 单位id
---@param attr_name string 属性名
---@param value number 属性成长
---设置属性成长
function unit.set_attr_growth(unit_id, attr_name, value)
    game_api.api_set_attr_growth(unit_id, attr_name, Fix32(value))
end

---@param exp number 经验
---设置被击杀的经验值奖励
function unit:set_reward_exp(exp)
    self.base():api_set_unit_reward_exp(exp)
end

---@param player_attr_name number 属性名
---@param value number 属性奖励
---设置被击杀的玩家属性奖励
function unit:set_reward_res(player_attr_name, value)
    self.base():api_set_unit_reward_res(player_attr_name, Fix32(value))
end

---@param attack_type integer 攻击类型
---设置攻击类型
function unit:set_attack_type(attack_type)
    self.base():api_set_attack_type(attack_type)
end

---@param armor_type integer 护甲类型
---设置护甲类型
function unit:set_armor_type(armor_type)
    self.base():api_set_armor_type(armor_type)
end

--************************残影优化
---@param red number 红
---@param green number 绿
---@param blue number 蓝
---@param alpha number 透明度
---@param break_time number 间隔时间
---@param start_time number 开始时间
---@param end_time boolean 结束时间
---@param is_origin_martial number 使用原生材质
---开启残影
function unit:enable_afterimage(red, green, blue, alpha, break_time, show_time, start_time, end_time, is_origin_martial)
    self.base():api_start_ghost(Fix32(red), Fix32(green), Fix32(blue), Fix32(alpha), Fix32(break_time), Fix32(show_time),
        Fix32(start_time), Fix32(end_time), is_origin_martial)
end

---关闭残影
function unit:disable_afterimage()
    self.base():api_stop_ghost()
end

---@param red number 绿
---@param green number 绿
---@param blue number 蓝
---@param alpha number 透明度
---设置残影颜色
function unit:set_afterimage_color(red, green, blue, alpha)
    self.base():api_set_ghost_color(Fix32(red), Fix32(green), Fix32(blue), Fix32(alpha))
end

---@param break_time number 间隔时间
---@param show_time number 显示时间
---@param start_time number 开始时间
---@param end_time number 结束时间
---设置残影时间
function unit:set_afterimage_time(break_time, show_time, start_time, end_time)
    self.base():api_set_ghost_time(Fix32(break_time), Fix32(show_time), Fix32(start_time), Fix32(end_time))
end

---@param img_id number 单位头像
---设置单位头像
function unit:set_icon(img_id)
    self.base():api_set_unit_icon(img_id)
end

---@param bar_type integer 血条样式
---设置血条样式
function unit:set_blood_bar_type(bar_type)
    self.base():api_set_blood_bar_type(bar_type)
end

---@param bar_show_type integer 血条显示方式
---设置血条显示方式
function unit:set_health_bar_display(bar_show_type)
    self.base():api_set_blood_bar_show_type(bar_show_type)
end

--***************敌我合并一条
---@param img_id number 单位小地图头像
---设置单位小地图头像
function unit:set_minimap_icon(img_id)
    self.base():api_set_mini_map_icon(img_id)
end

---@param img_id number 敌方单位小地图头像
---设置敌方单位小地图头像
function unit:set_minimap_avatar_for_enemy_unit(img_id)
    self.base():api_set_enemy_mini_map_icon(img_id)
end

---@param scale number 模型缩放
---设置模型缩放
function unit:set_scale(scale)
    self.base():api_set_scale(Fix32(scale))
end

---@param speed number 转身速度
---设置转身速度
function unit:set_turning_speed(speed)
    self.base():api_set_turn_speed(Fix32(speed))
end

---@param model_id number 模型id
---替换模型
function unit:replace_model(model_id)
    self.base():api_replace_model(model_id)
end

---@param model_id number 模型id
---取消模型替换
function unit:cancel_replace_model(model_id)
    self.base():api_cancel_replace_model(model_id)
end

--**********************这是啥
---@param is_visible boolean 是否半透明
---设置隐身可见时是否半透明
function unit:set_semitransparency_when_hidden_unit_is_visible(is_visible)
    self.base():api_set_transparent_when_invisible(is_visible)
end

---@param is_recycle boolean 是否回收
---设置尸体消失后是否回收
function unit:set_corpse_recyclable_status_after_fading(is_recycle)
    self.base():api_set_recycle_on_remove(is_recycle)
end

---@param is_open boolean 是否透视
---设置透视状态
function unit:set_Xray_is_open(is_open)
    self.base():api_set_Xray_is_open(is_open)
end

---@param tech_id number 科技id
---单位添加科技
function unit:add_tech(tech_id)
    self.base():api_add_tech(tech_id)
end

---@param tech_id number 科技id
---单位删除科技
function unit:remove_tech(tech_id)
    self.base():api_remove_tech(tech_id)
end

---@param tech_id number 科技id
---研究科技
function unit:research_tech(tech_id)
    self.base():api_upgrade_tech(tech_id)
end

---@return table
---遍历研发科技做动作
function unit:get_tech_list()
    local lua_table = {}
    local py_list = self.base():api_get_tech_list()
    for i = 0, python_len(py_list) - 1 do
        local tech = python_index(py_list, i)
        table.insert(lua_table, tech)
    end
    return lua_table
end

---@return table
---遍历应用科技做动作
function unit:get_affect_techs()
    local lua_table = {}
    local py_list = self.base():api_get_affect_techs()
    for i = 0, python_len(py_list) - 1 do
        local tech = python_index(py_list, i)
        table.insert(lua_table, tech)
    end
    return lua_table
end

function unit:set_day_vision(value)
    self.base():api_set_unit_day_vision(value)
end

function unit:set_night_value(value)
    self.base():api_set_unit_night_vision(value)
end

--*******************播放动画全局统一
---@param anim_name string 动画名
---@param speed number 速度
---@param start_time number 开始时间
---@param end_time number 结束时间
---@param isloop boolean 是否循环
---@param is_back_normal boolean 是否返回默认状态
---播放动画
function unit:play_animation(anim_name, speed, start_time, end_time, isloop, is_back_normal)
    self.base():api_play_animation(anim_name, Fix32(speed), Fix32(start_time), Fix32(end_time), isloop, is_back_normal)
end

---@param anim_name string 动画名
---停止动画
function unit:stop_animation(anim_name)
    self.base():api_stop_animation(anim_name)
end

---@param replace_anim_name string 动画名
---@param bereplace_anim_name string 动画名
---替换动画
function unit:change_animation(replace_anim_name, bereplace_anim_name)
    self.base():api_change_animation(replace_anim_name, bereplace_anim_name)
end

---@param replace_anim_name string 动画名
---@param bereplace_anim_name string 动画名
---取消动画替换
function unit:cancel_change_animation(replace_anim_name, bereplace_anim_name)
    self.base():api_cancel_change_animation(replace_anim_name, bereplace_anim_name)
end

---@param anim_name string 动画名
---重置动画替换
function unit:clear_change_animation(anim_name)
    self.base():api_clear_change_animation(anim_name)
end

---停止当前正在播放的动画
function unit:stop_cur_animation()
    self.base():api_stop_cur_animation()
end

---@param speed number 速度
---设置动画播放速率
function unit:set_animation_speed(speed)
    self.base():api_set_animation_speed(Fix32(speed))
end

---@param tag_name string 标签名
---@param item_id number 物品id
---添加物品
function unit:add_goods(tag_name, item_id)
    self.base():api_add_shop_item(tag_name, item_id)
end

---@param item_name string 物品名
---@param item_id number 物品id
---移除物品
function unit:remove_goods(item_name, item_id)
    self.base():api_remove_shop_item(item_name, item_id)
end

---@param tag_name string 标签名
---@param item_id number 物品id
---@param number number 物品库存
---设置物品库存
function unit:set_goods_stack(tag_name, item_id, number)
    self.base():api_set_shop_item_stock(tag_name, item_id, number)
end

---@param unit unit 单位
---@param item item 物品
---单位向商店出售物品
function unit:sell(unit, item)
    self.base():api_sell_item(unit.base(), item.base())
end

---@param unit unit 单位
---@param tag_num number 物品位置
---@param item_id number 物品id
---从商店购买物品商品
function unit:buy(unit, tag_num, item_id)
    self.base():api_buy_item_with_tab_name(unit, tag_num, item_id)
end

--******************是否和ac统一
---@param modifier_type number 魔法效果类型
---@param source_unit number 物品位置
---@param associated_ability ability 关联技能
---@param seconds number 持续时间
---@param duration number 循环周期
---@param stacks number 添加层数
---给单位添加魔法效果
function unit:add_modifier(modifier_type, source_unit, associated_ability, seconds, duration, stacks)
    self.base():api_add_modifier(modifier_type, source_unit and source_unit.base() or nil,
        associated_ability and associated_ability.base() or nil, Fix32(seconds), Fix32(duration), stacks)
end

---@param modifier_type number 影响类型的魔法效果
---单位移除魔法效果类型
function unit:remove_modifier_type(modifier_type)
    self.base():api_remove_modifier_type(modifier_type)
end

---@param modifier_type number 影响类型的魔法效果
---删除影响类型的魔法效果
function unit:delete_all_modifiers_by_effect_type(modifier_type)
    self.base():api_delete_all_modifiers_by_effect_type(modifier_type)
end

---@param modifier_type number 魔法效果类型
---@return modifier modifier 单位指定类型的魔法效果
---获取单位指定类型的魔法效果
function unit:get_specified_modifier_type(modifier_type)
    local py_modifier = self.base():api_get_modifier(-1, modifier_type)
    return y3.modifier.get_lua_modifier_from_py(py_modifier)
end

---@param page number 页
---@param index number 序号
---@return number recovery_interval 剩余恢复时间
---获取商店商品的库存间隔
function unit:get_recovery_interval_of_shop_goods(page, index)
    return self.base():api_get_shop_item_default_cd(page, index)
end

---@param page number 页
---@param index number 序号
---@return number recovery_time 剩余恢复时间
---获取商店商品的剩余恢复时间
function unit:get_remaining_recovery_time_of_shop_goods(page, index)
    return self.base():api_get_shop_item_residual_cd(page, index)
end

---@param tag_name number 页签
---@return table shop_item_list 商店中的商品
---遍历商店中的商品做动作
function unit:get_shop_item_list(tag_name)
    local lua_table = {}
    local py_list = self.base():api_get_shop_item_list(tag_name)
    for i = 0, python_len(py_list) - 1 do
        local iter_item = python_index(py_list, i)
        table.insert(lua_table, y3.item.get_lua_item_from_py(iter_item))
    end
    return lua_table
end

---@return number current_unit_hp 当前生命值
---获取当前生命值
function unit:get_hp()
    return self.base():api_get_float_attr("hp_cur"):float()
end

---@return number current_mp 当前魔法值
---获取当前魔法值
function unit:get_mp()
    return self.base():api_get_float_attr("mp_cur"):float()
end

---@param attr_name string 属性名
---@return number float_attr 单位实际属性类型的属性
---获取单位实际属性类型的属性
function unit:get_float_attr(attr_name)
    return self.base():api_get_float_attr(attr_name)
end

---@param attr_name string 属性名
---@return number attr_other 单位额外属性类型的属性
---获取单位额外属性类型的属性
function unit:get_attr_other(attr_name)
    return self.base():api_get_attr_other(attr_name)
end

---@return number attr_base 单位基础属性类型的属性
---获取单位基础属性类型的属性
function unit:get_attr_base(attr_name)
    return self.base():api_get_attr_base(attr_name)
end

---@return number attr_base_ratio 单位基础属性加成类型的属性
---获取单位基础属性加成类型的属性
function unit:get_attr_base_ratio(attr_name)
    return self.base():api_get_attr_base_ratio(attr_name)
end

---@return number attr_bonus 单位增益属性类型的属性
---获取单位增益属性类型的属性
function unit:get_attr_bonus(attr_name)
    return self.base():api_get_attr_bonus(attr_name)
end

---@return number attr_all_ratio 单位总属性加成类型的属性
---获取单位总属性加成类型的属性
function unit:get_attr_all_ratio(attr_name)
    return self.base():api_get_attr_all_ratio(attr_name)
end

---@return number attr_bonus_ratio 单位增益属性加成类型的属性
---获取单位增益属性加成类型的属性
function unit:get_attr_bonus_ratio(attr_name)
    return self.base():api_get_attr_bonus_ratio(attr_name)
end

---@return number unit_attribute_growth 单位属性成长
---获取单位属性成长
function unit.get_unit_attribute_growth(unit_id, attr_name)
    return game_api.api_get_attr_growth(unit_id, attr_name)
end

---@return number life_cycle 单位生命周期
---获取单位生命周期
function unit:get_life_cycle()
    return self.base():api_get_life_cycle():float()
end

---@return number height 单位飞行高度
---获取单位飞行高度
function unit:get_height()
    return self.base():api_get_height():float()
end

---@return number turning_speed 单位转身速度
---获取单位转身速度
function unit:get_turning_speed()
    return self.base():api_get_turn_speed():float()
end

---@return number alert_range 单位警戒范围
---获取单位警戒范围
function unit:get_alert_range()
    return self.base():api_get_unit_alarm_range():float()
end

---@return number cancel_alert_range 单位取消警戒范围
---获取单位取消警戒范围
function unit:get_cancel_alert_range()
    return self.base():api_get_unit_cancel_alarm_range()
end

---@return number collision_radius 单位碰撞半径
---获取单位碰撞半径
function unit:get_collision_radius()
    return self.base():api_get_unit_collision_radius():float()
end

---@return player player 单位所属玩家
---获取单位所属玩家
function unit:get_owner()
    local py_player = self.base():api_get_role()
    return y3.create_lua_player_from_py(py_player)
end

---@param unit_id number 单位类型
---@param player_attr_name string 玩家属性名
---@return number  player_attr 单位被击杀玩家属性
---获取单位建造资源消耗属性
function unit:get_unit_resource_cost(unit_id, player_attr_name)
    return game_api.get_role_attr_by_unit_type(unit_id, player_attr_name)
end

---@param player_attr_name string 玩家属性名
---@return number player_attr 单位被击杀玩家属性
---获取单位被击杀玩家属性
function unit:get_reward_res(player_attr_name)
    return self.base():api_get_unit_reward_res(player_attr_name):float()
end

---@return number model_scale 单位缩放
---获取单位缩放
function unit:get_scale()
    return self.base():api_get_model_scale()
end

---@return number range_scale 选择圈缩放
---获取单位选择圈缩放
function unit:get_unit_selection_range_scale()
    return game_api.get_select_circle_scale(self.base()):float()
end

---@return number xaxis X轴缩放
---获取单位的X轴缩放
function unit:get_x_scale()
    return self.base():api_get_x_scale()
end

---@return number zaxis  Z轴缩放
---获取单位的Z轴缩放
function unit:get_z_scale()
    return self.base():api_get_y_scale()
end

---@return number yaxis Y轴缩放
---获取单位的Y轴缩放
function unit:get_y_scale()
    return self.base():api_get_z_scale()
end

---@return number purchase_range 购买范围
---获取商店的购买范围
function unit:get_shop_range()
    return self.base():api_get_shop_range()
end

---@return number unit_level 单位等级
---获取单位等级
function unit:get_level()
    return self.base():api_get_level()
end

---@return number unit_type 单位类型ID
---获取单位的单位类型ID
function unit:get_type()
    return self.base():api_get_key()
end

---@return number type_id 单位类型的ID
---获取单位类型的ID
function unit:get_unit_type_id()
    return
end

---@return number exp 单位当前的经验值
---获取单位当前的经验值
function unit:get_exp()
    return self.base():api_get_exp()
end

---@return number exp 单位当前升级所需经验
---获取单位当前升级所需经验
function unit:get_upgrade_exp()
    return self.base():api_get_upgrade_exp()
end

---@return number hero_ability_point_number 英雄的技能点数量
---获取英雄的技能点数量
function unit:get_ability_point()
    return self.base():api_get_ability_point()
end

---@return number slot_number 单位背包栏的槽位数
---获取单位背包栏的槽位数
function unit:get_pkg_cnt()
    return self.base():api_get_unit_pkg_cnt()
end

---@return number slot_number 单位物品栏的槽位数
---获取单位物品栏的槽位数
function unit:get_bar_cnt()
    return self.base():api_get_unit_bar_cnt()
end

---@param item_id number 物品类型id
---@return number item_type_number 物品类型数量
---获取单位拥有的物品类型数量
function unit:get_item_type_number_of_unit(item_id)
    return self.base():api_get_num_of_item_type(item_id)
end

---@return number exp 单位被击杀经验
---获取单位被击杀经验
function unit:get_exp_reward()
    return self.base():api_get_unit_reward_exp()
end

---@param shield_type integer 护盾类型
---@return number shield_value 护盾类型的护盾值
---获取单位指定护盾类型的护盾值
function unit:get_shield(shield_type)
    return self.base():api_get_unit_shield_value(shield_type)
end

---@return number tab_number 页签数量
---获取商店页签数量
function unit:get_shop_tab_number()
    return self.base():api_get_shop_tab_cnt()
end

---@param tag_index number 页签
---@param item_id number 物品类型
---@return number item_stock 商品库存
---获取商店的物品商品库存
function unit:get_shop_goods(tag_index, item_id)
    return self.base():api_get_shop_item_stock(tag_index, item_id)
end

---@return string unit_name  单位名称
---获取单位名称
function unit:get_name()
    return self.base():api_get_name()
end

---@return string unit_description 单位的描述
---获取单位的描述
function unit:get_description()
    return self.base():api_get_str_attr("desc")
end

---@return string type_name 单位类型名称
---获取单位类型名称
function unit.get_unit_type_name(unit_id)
    return game_api.get_unit_name_by_type(unit_id)
end

---@param unit_id number 单位类型
---@return string des 单位类型的描述
---获取单位类型的描述
function unit.get_unit_type_description(unit_id)
    return game_api.get_unit_desc_by_type(unit_id)
end

---@param tag_index number 页签
---@return string tab_name 页签名
---获取商店的页签名
function unit:get_shop_tab_name(tag_index)
    return self.base():api_get_shop_tab_name(tag_index)
end

---@return number unit_subtype 单位分类
---获取单位分类
function unit:get_subtype()
    return self.base():api_get_type()
end

---@param unit_id number 单位类型
---@return number image 单位类型的头像
---获取单位类型的头像
function unit:get_image_of_unit_type_icon(unit_id)
    return game_api.get_icon_id_by_unit_type(unit_id)
end

---@return number unit_type  单位类型
---获取单位类型
function unit:get_unit_type()
    return self.base():api_get_key()
end

---@return unit unit 最后创建的单位
---最后创建的单位
function unit.last_unit_created()
    local py_unit = game_api.get_last_created_unit()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return unit unit 单位的拥有者
---获取单位的拥有者（单位）
function unit:get_parent_unit()
    local py_unit = self.base():api_get_parent_unit()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param unit unit 幻象
---@return unit unit 幻象的召唤者
---获取幻象的召唤者
function unit:get_illusion_owner()
    local py_unit = game_api.get_illusion_caller_unit(self.base())
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return number angle 单位的朝向
---获取单位的朝向
function unit:get_facing()
    return self.base():get_face_angle()
end

---@return number DAMAGE_ARMOR_TYPE 护甲类型
---获得护甲类型
function unit:get_armor_type()
    return self.base():api_get_armor_type()
end

---@return number DAMAGE_ATTACK_TYPE 攻击类型
---获得攻击类型
function unit:get_attack_type()
    return self.base():api_get_atk_type()
end

---@param tag_index number 页签
---@param item_index number 序号
---@return number item 物品类型
---获取商店的物品商品
function unit:get_goods(tag_index, item_index)
    return self.base():api_get_shop_tab_item_type(tag_index, item_index)
end

---@return number model 当前模型
---获取单位的当前模型
function unit:get_model()
    return self.base():api_get_model()
end

---@return number model 原本模型
---获取单位的原本模型
function unit:get_source_model()
    return self.base():api_get_source_model()
end

---@return point unit_point 单位所在点
---获取单位所在点
function unit:get_point()
    local py_point = self.base():api_get_position()
    return y3.get_lua_point_from_py(py_point)
end

---@return point point 单位最近的可通行点
---获取单位最近的可通行点
function unit:get_nearest_point()
    local py_point = self.base():api_find_nearest_valid_position()
    return y3.get_lua_point_from_py(py_point)
end

---@return string team 获取单位的队伍
---获取单位的队伍
function unit:get_team()
    return self.base():api_get_camp()
end

---@param tag_name string 标签
---@return boolean has_tag 具有标签
---具有标签
function unit:has_tag(tag_name)
    return global_api.has_tag(self.base(), tag_name)
end

---@return boolean alive 是否存活
---是否存活
function unit:is_unit_alive()
    return global_api.is_unit_alive(self.base())
end

---@param target_unit unit 单位
---@return boolean visibility 是否可见
---是否可见
function unit:visibility_of_unit(target_unit)
    return game_api.get_visibility_of_unit(target_unit.base(), self.base())
end

---@return boolean is_moving 正在移动
---正在移动
function unit:is_unit_moving()
    return self.base():api_is_moving()
end

---@param point_or_unit point|unit 点或单位
---@param range number 范围
---@return boolean in_radius 在单位附近
---点或单位在单位附近
function unit:is_in_radius(point_or_unit, range)
    if point_or_unit.type == "point" then
        return self.base():api_is_point_in_range(point_or_unit.base(), Fix32(range))
    elseif point_or_unit.type == "unit" then
        return self.base():api_is_in_range(point_or_unit.base(), Fix32(range))
    end
end

---@return boolean is_shop 是商店
---是商店
function unit:unit_is_shop()
    return self.base():api_is_shop()
end

---@return boolean illusion 是幻象单位
---是幻象单位
function unit:is_unit_illusion()
    return game_api.is_unit_illusion(self.base())
end

---@param group unit_group 单位组
---@return boolean in_group 在单位组中
---在单位组中
function unit:unit_in_group(group)
    if group == nil then
        return false
    end
    return game_api.judge_unit_in_group(self.base(), group.base())
end

---@return boolean in_battle 在战斗状态
---在战斗状态
function unit:is_in_battle()
    return self.base():api_is_in_battle_state()
end

---@param state_name integer 状态
---@return boolean has_buff_status 有指定状态
---有指定状态
function unit:has_buff_status(state_name)
    return self.base():api_has_state(state_name)
end

---@param ability_id number 技能类型
---@return boolean has_ability_type 有指定类型的技能
---有指定类型的技能
function unit:check_has_ability_type(ability_id)
    return self.base():api_check_has_ability_type(ability_id)
end

---@param item item 物品
---@return boolean has_item 有物品
---有物品
function unit:unit_has_item(item)
    return self.base():api_has_item(item.base())
end

---@param item_id number 物品类型
---@return boolean has_item_name 有指定类型的物品
---有指定类型的物品
function unit:unit_has_item_name(item_id)
    return self.base():api_has_item_key(item_id)
end

---@param modifier_id number 魔法效果id
---@return boolean has_modifier 有魔法效果
---有魔法效果
function unit:unit_has_modifier(modifier_id)
    return self.base():api_has_modifier(modifier_id)
end

---@param modifier_type integer 魔法效果类型
---@return boolean has_modifier_style 有指定类型的魔法效果
---有指定类型的魔法效果
function unit:unit_has_modifier_style(modifier_type)
    return self.base():api_has_modifier_type(modifier_type)
end

---@param tag_name string 标签
---@return boolean has_modifier_tag 有指定标签的魔法效果
---有指定标签的魔法效果
function unit:unit_has_modifier_tag(tag_name)
    return self.base():api_has_modifier_with_tag(tag_name)
end

---@param player player 玩家
---@param unit_id number 单位类型
---@return boolean unit_precondition 单位类型前置条件是否通过
---单位类型前置条件是否通过
function unit.check_unit_key_precondition(player, unit_id)
    return game_api.check_unit_key_precondition(player.base(), unit_id)
end

---@param target_unit unit 目标单位
---@return boolean is_enemy  是敌对关系
---是敌对关系
function unit:is_ally(target_unit)
    return game_api.is_ally(self.base(), target_unit.base())
end

---@param target_unit unit 目标单位
---@return boolean is_enemy  是敌对关系
---是敌对关系
function unit:is_enemy(target_unit)
    return game_api.is_enemy(self.base(), target_unit.base())
end

---@param point point 点
---@return boolean can_teleport 能否传送到点
---能否传送到点
function unit:can_teleport_to(point)
    return self.base():api_can_teleport_to(point.base())
end

---@param point point 点
---@param range number 范围
---@return boolean can_collide 是否与点碰撞
---是否与点碰撞
function unit:unit_can_collide_with_point(point, range)
    return game_api.unit_can_collide_with_point(self.base(), point.base(), Fix32(range))
end

---@param start_point point 起始点
---@param end_point point 终点
---@return boolean is_reach 是否寻路可达
---是否寻路可达
function unit:unit_can_from_point_to_point(start_point, end_point)
    return game_api.can_point_reach_point(self.base(), start_point.base(), end_point.base())
end

---@param collision_type string 碰撞类型
---@return  boolean collision_type_name 是否拥有指定碰撞类型
---是否拥有指定碰撞类型
function unit:get_unit_move_collision(collision_type)
    return self.base():api_get_move_collision(collision_type)
end

---获得单位属性
function unit:get(p1, p2)
    if p1 == 'ATTR_RESULT' then
        return self.base():api_get_float_attr(p2):float()
    elseif p1 == 'ATTR_OTHER' then
        return self.base():api_get_attr_other(p2):float()
    elseif p1 == 'ATTR_BASE' then
        return self.base():api_get_attr_base(p2):float()
    elseif p1 == 'ATTR_BASE_RATIO' then
        return self.base():api_get_attr_base_ratio(p2):float()
    elseif p1 == 'ATTR_BONUS' then
        return self.base():api_get_attr_bonus(p2):float()
    elseif p1 == 'ATTR_BONUS_RATIO' then
        return self.base():api_get_attr_bonus_ratio(p2):float()
    elseif p1 == 'ATTR_ALL_RATIO' then
        return self.base():api_get_attr_all_ratio(p2):float()
    end
end

function unit:get_unit_player()
    return y3.player(self.base():api_get_role_id())
end

---玩家是否可以购买商店的物品
function unit:player_shop_check(player)
    return self.base():api_shop_check_camp(player and player.base() or nil)
end

---@param type_id number 范围
---@return number model 模型
---获取单位类型的模型
function unit.get_model_by_type(type_id)
    return game_api.api_get_unit_type_model(type_id)
end

---@param type_id number 范围
---@return number model 模型
---获取单位类型的分类
function unit.get_type_by_id(type_id)
    return game_api.api_get_unit_type_category(type_id)
end

---@param is_enable boolean 空中通道限制
---设置单位的移动类型为空中
function unit:set_move_air(is_enable)
    self.base():set_move_channel_air(is_enable or false)
end

---@param land boolean 地面通道限制
---@param obj boolean 物件通道限制
---@param sea boolean 海洋通道限制
---设置单位的移动类型为地面
function unit:set_move_land(land, obj, sea)
    self.base():set_move_channel_land(land or false, obj or false, sea or false)
end

---@param visible boolean 是否显示
---设置单位选择圈
function unit:set_circle_visible(visible)
    self.base():api_set_unit_select_effect_visible(visible)
end

---@return attr attr 单位属性
---获取单位的主要属性
function unit:get_main_attr()
    return self.base():api_get_unit_main_attr()
end

---@param page_num integer 商品物品页
---@param item_type integer 物品类型id
---@return integer item_num 商品库存
---获取商店的物品库存
function unit:get_shop_goods_stack(page_num, item_type)
    return self.base():api_get_shop_item_stock(page_num, item_type)
end

---@param switch boolean 圆盘阴影开关
---设置单位圆盘阴影开关
function unit:set_shadow_disk(switch)
    self.base():api_set_disk_shadow_open(switch)
end

---@param size number 圆盘阴影大小
---设置单位圆盘阴影大小
function unit:set_shadow_disk_size(size)
    self.base():api_set_unit_disk_shadow_size(Fix32(size))
end

---@param unit_key number 单位类型
---获取单位类型的前置条件列表
function unit.get_unit_precondition(unit_key, data)
    data[const.IterKey.ITER_PRE_CONDITION] = game_api.get_unit_key_precondition_list(unit_key)
    local lua_table = {}
    for i = 0, python_len(data[const.IterKey.ITER_PRE_CONDITION]) - 1 do
        local key = python_index(data[const.IterKey.ITER_PRE_CONDITION], i)
        table.insert(lua_table, key)
    end
    return lua_table
end

---@param data pylist python列表
---获取前置条件遍历到的单位标签
function unit.get_precondition_unit_tag(data)
    return game_api.get_pre_condition_iter_unit_tag(data)
end

---@param data pylist python列表
---获取前置条件遍历到的单位类型
function unit.get_precondition_unit_key(data)
    return game_api.get_pre_condition_iter_unit_key(data)
end

---@param scale_x number x缩放
---@param scale_y number 可见性
---@param scale_z number z缩放
---设置单位三轴缩放
function unit:set_unit_scale(scale_x, scale_y, scale_z)
    self.base():api_set_unit_scale(scale_x, scale_y, scale_z)
end

---@param node_name string 血条命名
---@param visible boolean 可见性
---@param player player 玩家
---设置血条可见性
function unit:set_hp_visible(node_name,visible,player)
    game_api.set_billboard_visible(self.base(),node_name,visible,player and player.base() or nil)
end

---@param node_name string 血条命名
---@param progress number 进度
---@param player player 玩家
---设置血条进度
function unit:set_hp_progress(node_name,progress,player)
    game_api.set_billboard_visible(self.base(),node_name,progress,player and player.base() or nil)
end

---@param node_name string 血条命名
---@param image_id integer 图片id
---@param player player 玩家
---设置血条图片
function unit:set_hp_pic(node_name,image_id,player)
    game_api.set_billboard_picture(self.base(),node_name,image_id,player and player.base() or nil)
end

---@param node_name string 血条命名
---@param text string 图片id
---@param player player 玩家
---@param font integer 字体
---设置血条文本
function unit:set_hp_text(node_name,text,player,font)
    game_api.set_billboard_text(self.base(),node_name,text,player and player.base() or nil,font or nil)
end

---@param point1 point 起始点
---@param point2 point 目标点
---@return number range 寻路距离
---获取单位从点到点的寻路距离
function unit:get_unit_path_length_between_points(point1,point2)
    return self.base():get_unit_path_length_between_points(point1.base(),point2.base())
end

---@param SlotType integer 槽位类型
---@param index integer 槽位
---@return integer id 物编id
---获取单位持有的物品类型
function unit:get_item_type_by_slot(SlotType,index)
    return self.base():api_get_item_type_by_slot(SlotType,index)
end