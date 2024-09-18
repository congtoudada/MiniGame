--- File Name : item.lua
--- Description: 物品相关逻辑 对应编辑器---物品

local setmetatable = setmetatable
local ipairs = ipairs

---@class item
local item = {}
item.__index = item
y3.item = item
item.type = 'item'
---所有物品实例
local Items = setmetatable({}, { __mode = 'kv' })
---所有触发器组
local TriggerGroups = {}

---@param scene_id number 场景Id
---@return item lua层item
---根据场景id得到item实例
function y3.get_item_by_scene_id(scene_id)
    local py_item = game_api.get_item(scene_id)
    return item.get_lua_item_from_py(py_item)
end

---@param group table 物编触发器组
---@param item_id number 物编道具id
---初始化物编触发器组
local function trigger_group_init(group, item_id)
    group.add_trigger = function(event_name, action)
        -- local enum, params = event_manager.get_enum_and_params(event_name, event_enum.item)
        local trigger_id = y3.trigger.get_trigger_id()
        local py_trigger = new_item_trigger(item_id, trigger_id, event_name, event_name, true)
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

---@param item_id number 物编道具id
---@return trigger_group 触发器组
---按照道具id创建道具触发器组
function item.create_item_trigger_group(item_id)
    if not TriggerGroups[item_id] then
        TriggerGroups[item_id] = {}
        trigger_group_init(TriggerGroups[item_id], item_id)
    end
    return TriggerGroups[item_id]
end

---@param  py_item table py层的道具实例
---@return table 返回在lua层初始化后的lua层道具实例
---通过py层的技能实例获取lua层的道具实例
function item.get_lua_item_from_py(py_item)
    if not py_item then
        return
    end
    local id 
    if type(py_item) == 'number' then
        id = py_item
        py_item = game_api.get_item(py_item)
    else
        id = py_item.api_get_id()
    end
    local py = py_obj.new(py_item)
    if not Items[id] then
        local new_item = {}
        setmetatable(new_item, item)
        new_item.base = py
        new_item.id = id
        Items[id] = new_item
    end
    return Items[id]
end

---返回空物品
function item.get_nil_item()
    if not Items[0] then
        local new_item = {}
        setmetatable(new_item, item)
        new_item.base = py_obj.new(0)
        new_item.id = 0
        Items[0] = new_item
    end
    return Items[0]
end

---@param event_name string 事件名
---@param action function 事件触发时执行的方法
---添加触发器
function item:add_trigger(event_name, action)
    local enum, params = event_manager.get_enum_and_params(event_name, event_enum.item)
    local trigger_id = y3.get_trigger_id()
    local py_trigger = new_global_trigger(trigger_id, event_name, enum, true)
    function py_trigger.on_event(trigger, event, actor, data)
        if data.__item_id:api_get_id() == self.id then
            --local lua_data = event_manager.get_lua_params(params, data)
            action(data)
        end
    end
end

---@return boolean is_exist 是否存在
---是否存在
function item:is_destory()
    return  game_api.item_is_exist(self.base())
end
---@param tag string 删除标签
---@return boolean is_has_tag 是否有标签
---存在标签
function item:has_tag(tag)
    return self.base():api_has_tag(tag)
end

---@return boolean is_in_scene 是否在场景中
---是否在场景中
function item:is_in_scene()
    return self.base():api_is_in_scene()
end


--TODO:需确认物品栏英文
---@return boolean is_in_bar 是否在物品栏 
---物品在物品栏 
function item:is_in_bar()
    return self.base():api_is_in_bar()
end

---@return boolean is_in_bag 是否在背包栏
---物品在背包栏
function item:is_in_bag()
    return self.base():api_is_in_pkg()
end

---删除物品
function item:remove()
    self.base():api_remove()
end

---@param point point 目标点
---@param count number 丢弃数量
---丢弃物品到点
function item:drop(point, count)
    self.base():api_drop_self(point.base(), count)
end

---@param point point 点
---移动到点 
function item:set_point(point)
    self.base():api_transmit(point.base())
end

---@param name string 名字
---设置物品的名称
function item:set_name(name)
    self.base():set_name(name)
end

---@param description string 描述
---设置物品的描述
function item:set_description(description)
    self.base():api_set_desc(description)
end

---@param picture_id number 图片id
---设置物品的图标
function item:set_icon(picture_id)
    self.base():api_set_item_icon(picture_id)
end

---@param player player 所属玩家
---设置所属玩家
function item:set_owner(player)
    self.base():api_set_creator(player.base())
end

---@param level number 等级
---设置等级
function item:set_level(level)
    self.base():api_set_level(level)
end

---@param charge number 充能数
---设置充能数
function item:set_charge(charge)
    self.base():api_set_charge_cnt(charge)
end

---@param charge number 充能数
---增加充能数
function item:add_charge(charge)
    self.base():api_add_charge(charge)
end

---@param charge number 最大充能数 
---设置最大充能数 
function item:set_max_charge(charge)
    self.base():api_set_max_charge(charge)
end

---@param stack number 堆叠数
---设置堆叠数
function item:set_stack(stack)
    self.base():api_set_stack_cnt(stack)
end

---@param stack number 堆叠数
---增加堆叠数
function item:add_stack(stack)
    self.base():api_add_stack(stack)
end


--TODO:这里的key需要在lua层处理
---@param key string 属性key
---@param value number 属性值
---设置基础属性 
function item:set_basic_attributes(key, value)
    self.base():api_set_attr("ATTR_BASE", key, Fix32(value))
end


--TODO:这里的key需要在lua层处理
---@param key string 属性key
---@param value number 属性值
---增加基础属性 
function item:add_basic_attributes(key, value)
    self.base():api_change_attr("ATTR_BASE", key, Fix32(value))
end

---@param value number 生命值
---设置生命值
function item:set_hp(value)
    self.base():api_set_hp(Fix32(value))
end

---@param ability_id number 技能id
---@param level number 等级
---给物品添加被动技能
function item:add_passive_ability(ability_id, level)
    self.base():api_item_add_passive_ability(ability_id, level)
end

---@param state number 状态
---设置丢弃状态
function item:set_droppable(state)
    self.base():api_set_droppable(state)
end

---@param tag string 标签
---添加标签
function item:add_tag(tag)
    self.base():api_add_tag(tag)
end

---@param tag string 标签
function item:remove_tag(tag)
    self.base():api_remove_tag(tag)
end

---@param state boolean 是否可出售
---设置物品可否出售
function item:set_sale_state(state)
    self.base():api_set_sale_state(state)
end

---@param scale number 缩放
---设置物品缩放
function item:set_scale(scale)
    self.base():api_set_scale(Fix32(scale))
end

---@param facing string 描述
---设置物品朝向
function item:set_facing(facing)
    self.base():api_set_face_angle(Fix32(facing))
end

---@return number type 类型
---获取物品类型id
function item:get_type()
    return self.base():api_get_key()
end


---@param id number 物品id
---@param player_attr_name string 玩家属性
---@param price number 价格
---设置物品商品售价
function item.set_item_shop_price(id,player_attr_name, price)
    game_api.set_item_buy_price(id, player_attr_name, price)
end

---@return unit owner 拥有者
---物品拥有者
function item:get_owner()
    local py_owner = self.base():api_get_owner()
    return y3.unit.get_lua_unit_from_py(py_owner)
end

---@return point position 物品所在点
---物品所在点
function item:get_point()
    local py_point = self.base():api_get_position()
    return y3.get_lua_point_from_py(py_point)
end

---@return number stacks 堆叠数 
---物品堆叠数
function item:get_stack()
    return self.base():api_get_stack_cnt()
end

---@return number charges 充能数
---物品充能数
function item:get_charge()
    return self.base():api_get_charge_cnt()
end

---@return number max_charge 最大充能数
---获取最大充能数
function item:get_max_charge()
    return self.base():api_get_max_charge()
end

---@return number level 物品等级
---获取物品等级
function item:get_level()
    return self.base():api_get_level()
end

---@return number hp 物品的生命值
---获取物品的生命值
function item:get_hp()
    return self.base():api_get_hp()
end

--TODO:这里的key需要在lua层处理
---@param type number 类型
---@param key string 属性key
---获取物品的基础属性
function item:get_basic_attributes(type, key)
    --TODO:下面第一个参数是根据类型拼出来的，需要处理
    return self.base():api_get_attr("ATTR_BASE", key)
end

---@return string name 物品名字
---获取物品名
function item:get_name()
    return self.base():get_name()
end

---@return string description 物品描述
---获取物品描述
function item:get_description()
    return self.base():api_get_desc()
end

---@return number scale 物品缩放
---获取物品缩放
function item:get_scale()
    return self.base():api_get_scale()
end

---@return number angel 朝向
---获取物品的朝向
function item:get_facing()
    return self.base():api_get_face_angle()
end

---@return ability ability 主动技能
---获取物品的主动技能
function item:get_ability()
    local py_ability = self.base():api_get_positive_ability()
    return y3.ability.get_lua_ability_from_py(py_ability)
end

---@return ability ability 被动技能
---获取物品的被动技能
function item:get_passive_ability(index)
    local py_ability = self.base():api_get_passive_ability(index)
    return y3.ability.get_lua_ability_from_py(py_ability)
end

---@return number index 格子位置
---获取物品在单位身上的格子位置
function item:get_slot()
    return self.base():api_get_item_slot_idx()
end

---@return player  player 玩家
---获取物品的拥有玩家
function item:get_creator()
    local py_player = self.base():api_get_creator()
    return y3.create_lua_player_from_py(py_player)
end

---@return number 背包槽类型
---获取物品在单位身上的背包槽类型
function item:get_slot_type()
    return self.base():api_get_item_slot_type()
end

---@return item item 物品 
---触发当前事件的物品 
function item.item_that_triggered_current_event(data)
    local py_item = gameapi.get_item(data['__item_id'])
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item item 物品
---单位获得物品
function item.unit_gains_item()
    local py_item = gameapi.get_last_add_item()
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item item 物品
---单位失去物品
function item.unit_loses_item()
    local py_item = gameapi.get_last_remove_item()
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item item 物品
---单位使用物品
function item.unit_uses_item()
    local py_item = gameapi.get_last_use_item()
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item item 物品
---堆叠层数变化物品
function item.item_whose_stack_changed()
    local py_item = gameapi.get_last_stack_changed_item()
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item item 物品
---充能变化物品
function item.item_whose_charge_changed()
    local py_item = gameapi.get_last_stack_changed_item()
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item item 物品
---购买物品
function item.item_purchased()
    local py_item = gameapi.get_last_buy_shop_item()
    return y3.item.get_lua_item_from_py(py_item)
end

---@return item item 物品
---出售物品
function item.item_sold()
    local py_item = gameapi.get_last_sell_shop_item()
    return y3.item.get_lua_item_from_py(py_item)
end


--------------------------------------------------------类的方法--------------------------------------------------------


---@param player player 玩家
---@param item item 道具
---检查物品类型前置条件
function item.check_item_key_precondition(player, item)
    if type(item) == 'number' then
        game_api.check_item_key_precondition(player.base(), item)
    else
        game_api.check_item_key_precondition(player.base(), item.id)
    end
end

---@param point point 点
---@param item_id number 道具类型
---@param player player 玩家
---创建物品到点
function item.create_item(point, item_id, player)
    if player then
        player = player.base()
    else
        player = nil
    end
    local py = game_api.create_item_by_id(point and point.base() or nil, item_id, player)
    return item.get_lua_item_from_py(py)
end

---@param unit unit 单位
---@param item_id number 道具类型
---单位添加物品
function item.add_item_to_unit(unit, item_id)
    unit.base.api_add_item(item_id)
end

---@param unit unit 单位
---@param item_id number 道具类型
---单位移除物品
function item.remove_item_from_unit(unit, item_id)
    unit.base.api_delete_item(item_id, 1)   --TODO:需要确认这个1是啥，大概是数量？
end

---@param unit unit 单位
---@param type number 类型
---@param position point 点
---@param is_move boolean 是否移动
---转移物品 type1 物品栏 type2背包栏  
function item:shift_item(unit, type, position, is_move)
    unit.base().api_shift_item_new(self.base(), type, position, is_move)  --TODO:需要确认 槽位被占是否转移 这个的英文

end

---最近创建的物品
function item.get_last_created_item()
    local py_item = game_api.get_last_created_item()
    return item.get_lua_item_from_py(py_item)
end

---@param type_id number 类型
---@param key string 玩家属性
---获取物品购买售价
function item.get_item_buy_price(type_id, key)
    return game_api.get_item_buy_price(type_id, key):float()
end

---@param type_id number 类型
---@param key string 玩家属性
---获取物品出售售价
function item.get_item_sell_price(type_id, key)
    return game_api.get_item_sell_price(type_id, key)
end

---@param area area 区域
---获得区域内所有物品
function item.get_item_group_in_area(area)
    local py_item_group = game_api.get_item_group_in_area(area.base())
    return y3.item_group.create_lua_item_group_from_py(py_item_group)
end

---@param type_id number 物品类型
---获取物品类型名
function item.get_item_type_name(type_id)
    return game_api.get_item_conf_name(type_id)
end

---@param type_id number 物品类型
---获取物品类型的icon的图片id
function item.get_icon_id_by_item_type(type_id)
    return game_api.get_icon_id_by_item_type(type_id)
end

---@param type_id number 物品类型
---获取物品类型的描述
function item.get_item_description_by_type(type_id)
    return game_api.get_item_desc_by_type(type_id)
end

---@return number type 物品类型
---获取物品类型
function item:get_item_type()
    return self.base():api_get_type()
end

---@return number type 模型类型
---获取物品模型
function item:get_model()
    return self.base():api_get_item_model()
end

---@param item_type number 物品类型编号
---@param first_attr_name number 一级属性名
---@param second_attr_name number 二级属性名
---@return number value 属性值
---获取物品类型的单位属性
function item.get_attr_of_item_type(item_type,first_attr_name,second_attr_name)
    return game_api.api_get_attr_of_item_key(item_type,first_attr_name,second_attr_name)
end

---@return number type 物品类型
---获取物品类型的模型
function item.get_model_by_item_type(item_type)
    return game_api.api_get_item_type_model(item_type)
end

---@param visible boolean 可见性
---设置物品可见性
function item:set_visible(visible)
    self.base():api_set_item_visible(visible)
end

---@param model model 模型
---替换物品模型
function item:change_model(model)
    self.base():api_change_model(model)
end

---@param model model 模型
---取消替换物品模型
function item:cancel_model(model)
    self.base():api_cancel_replace_model(model)
end

---遍历物品的单位属性
function item:pick_attr()
    local lua_table = {}
    local py_list = game_api.iter_unit_attr_of_item(self.base())
    for i = 0, python_len(py_list)-1 do
        local iter_item = python_index(py_list,i)
        table.insert(lua_table,iter_item)
    end
    return lua_table
end

---遍历物品类型的单位属性
function item.pick_attr_by_type(item_type)
    local lua_table = {}
    local py_list = game_api.iter_unit_attr_of_item_name(item_type)
    for i = 0, python_len(py_list)-1 do
        local iter_item = python_index(py_list,i)
        table.insert(lua_table,iter_item)
    end
    return lua_table
end

---@param item_key number 物品类型
---获取物品类型的前置条件列表
function item.get_item_precondition(item_key,data)
    data[const.IterKey.ITER_PRE_CONDITION]= game_api.get_item_key_precondition_list(item_key)
    local lua_table = {}
    for i = 0, python_len(data[const.IterKey.ITER_PRE_CONDITION])-1 do
        local key = python_index(data[const.IterKey.ITER_PRE_CONDITION],i)
        table.insert(lua_table,key)
    end
    return lua_table
end

---@return  boolean visible 是否可见
---物品是否可见
function item:is_visible()
    return self.base():is_visible()
end

---@param res_key string 玩家属性key
---@return  integer count 购买资源数量
---获取物品的购买资源数量
function item:get_item_res_cnt(res_key)
    return self.base():api_get_item_res_cnt(res_key)
end

---@param res_key string 物品实数属性key
---@return  number attr 物品的实数属性
---获取物品的实数属性
function item:get_item_float_attr(res_key)
    return self.base():api_get_item_float_attr(res_key)
end

---@param res_key string 物品整数属性key
---@return  integer attr 物品的整数属性
---获取物品的整数属性
function item:get_item_int_attr(res_key)
    return self.base():api_get_item_int_attr(res_key)
end

---@param itemKey integer 物编id
---@param res_key string 玩家属性key
---@return  integer count 购买资源数量
---获取物品类型的购买所需资源
function y3.get_item_key_res_cnt(itemKey,res_key)
    return self.base():api_get_item_key_res_cnt(itemKey,res_key)
end

---@param itemKey integer 物编id
---@param res_key string 实数属性key
---@return  number count 购买资源数量
---获取物品类型的实数属性
function y3.get_item_type_float_attr(itemKey,res_key)
    return self.base():api_get_item_type_float_attr(itemKey,res_key)
end

---@param itemKey integer 物编id
---@param res_key string 整数属性key
---@return  integer count 购买资源数量
---获取物品类型的整数属性
function y3.api_get_item_type_int_attr(itemKey,res_key)
    return self.base():api_get_item_type_int_attr(itemKey,res_key)
end