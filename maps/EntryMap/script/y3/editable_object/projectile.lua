--- File Name : projectile.lua
--- Description: 投射物相关逻辑 对应编辑器---投射物

local setmetatable = setmetatable
local ipairs = ipairs

---@class projectile
local projectile = {}
projectile.__index = projectile
y3.projectile = projectile
projectile.type = 'projectile'
---所有物品实例
local Projectiles = setmetatable({}, { __mode = 'kv' })
---所有触发器组
local TriggerGroups = {}

---@param projectile_id number 场景Id
---@return projectile lua层projectile
---根据场景id得到item实例
function y3.get_projectile_by_scene_id(projectile_id)
    local py_item = game_api.get_projectile_by_id(projectile_id)
    return projectile.get_lua_projectile_from_py(py_item)
end

---@param group table 物编触发器组
---@param projectile_id number 物编道具id
---初始化物编触发器组
local function trigger_group_init(group, projectile_id)
    group.add_trigger = function(event_name, action)
        local trigger_id = y3.trigger.get_trigger_id()
        local py_trigger = new_projectile_trigger(projectile_id, trigger_id, event_name, event_name, true)
        function py_trigger.on_event(trigger, event, actor, data)
            if EVENT_DATA[event_name] then
                action(EVENT_DATA[event_name](data))
            else
                action(data)
            end
        end
    end
end

---@param projectile_id number 物编道具id
---@return trigger_group 触发器组
---按照道具id创建道具触发器组
function projectile.create_projectile_trigger_group(projectile_id)
    if not TriggerGroups[projectile_id] then
        TriggerGroups[projectile_id] = {}
        trigger_group_init(TriggerGroups[projectile_id], projectile_id)
    end
    return TriggerGroups[projectile_id]
end

---@param  py_item table py层的道具实例
---@return table 返回在lua层初始化后的lua层道具实例
---通过py层的技能实例获取lua层的道具实例
function projectile.get_lua_projectile_from_py(py_projectile)
    if not py_projectile then
        return
    end
    --TODO:py层好像没有获取唯一id的api,那怎么唯一确定一个投射物呢 这个key不知道是不是物编id，那这个就不对
    --TODO:实在不行就只能把py本体当成key了
    local py = py_obj.new(py_projectile)
    local id = py_projectile.api_get_key()
    if not Projectiles[id] then
        local new_projectile = {}
        setmetatable(new_projectile, projectile)
        new_projectile.base = py
        new_projectile.id = id
        Projectiles[id] = new_projectile
    end
    return Projectiles[id]
end


---@return number type 类型
---投射物的类型
function projectile:get_type()
    return self.id
end

---@return boolean is_exist 是否存在
---是否存在
function projectile:is_destory()
    return  game_api.projectile_is_exist(self.base())
end
---@return number height 高度
---获取投射物高度
function projectile:get_height()
    return self.base():api_get_height()
end

---@return number type 投射物类型
---整数转化为投射物类型
function projectile:convert_integer_to_projectile_type()
    return
end

---@return number duration 投射物剩余持续时间
---获取投射物剩余持续时间
function projectile:get_time()
    return self.base():api_get_left_time()
end

---@return unit unit 投射物的拥有者
---获取投射物的拥有者
function projectile:get_owner()
    local py_unit = self.base():api_get_owner()
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@return number angle 投射物朝向
---获取投射物朝向
function projectile:get_facing()
    return self.base():api_get_face_angle()
end

---@return point point 投射物所在点
---获取投射物所在点
function projectile:get_point()
    local py_point = self.base():api_get_position()
    return y3.get_lua_point_from_py(py_point)
end

---@param  tag string 标签
---@return boolean is_has_tag 是否拥有标签
---拥有标签
function projectile:has_tag(tag)
    global_api.has_tag(self.base(), tag)
end

---@return table projectiles 所有投射物
---所有带有标签的投射物  
function projectile:all_projectiles_with_specified_tag()
    return
end

---@return number type 类型
---投射物类型转化为整数 
function projectile:convert_projectile_type_to_integer()
    return
end

---@param data table 触发器回调函数中的data
---@return projectile projectile 绑定的投射物
---获取运动器绑定投射物
function projectile.get_mover_bound_projectiles(data)
    local py_projectile = y3.get_projectile_by_scene_id(data['mover_owner_projectile'])
    return projectile.get_lua_projectile_from_py(py_projectile)
end

---@param tag string 标签
---投射物添加标签
function projectile:add_tag(tag)
    self.base():api_add_tag(tag)
end

---@param tag string 标签
---投射物移除标签
function projectile:remove_tag(tag)
    self.base():api_remove_tag(tag)
end

function projectile.create(data)
    if not data.angle then
        data.angle = 0
    end
    if not data.height then
        data.height = 0
    end
    if not data.time then
        data.time = -1
    end
    if not data.owner then
        data.owner = y3.player(31)
    end
    if not data.ability then
        data.ability = nil
    else
        data.ability = data.ability.base()
    end
    if data.target then
        if data.target.type == 'point' then
            local py_obj = game_api.create_projectile_in_scene_new(data.type, data.target.base(), data.owner.base(), Fix32(data.angle), data.ability, Fix32(data.time), Fix32(data.height), data.visible_name, data.immediate)
            return projectile.get_lua_projectile_from_py(py_obj)
        else
            local py_obj = game_api.create_projectile_on_socket(data.type, data.target.base(), data.socket, Fix32(data.angle), data.owner.base(), data.ability, data.visible_name,data.time, data.immediate)
            return projectile.get_lua_projectile_from_py(py_obj)
        end
    end
end



---为投射物所属单位的所属玩家的玩家关系播放声音
function projectile:play_sound_for_projectile_units_of_specified_player_relationship()

end

---@param unit unit 所属单位
---设置所属单位
function projectile:set_owner(unit)
    game_api.change_projectile_owner(self.base(), unit.base())
end

---@param ability ability 关联技能
---设置关联技能
function projectile:set_ability(ability)
    game_api.change_projectile_ability(self.base(), ability.base())
end

---使投射物做环绕运动
function projectile:moves_in_a_circle()

end

---销毁
function projectile:remove()
    self.base():api_delete(nil)
end

---@param height number 高度
---设置高度
function projectile:set_height(height)
    self.base():api_raise_height(Fix32(height))
end

---@param point point 点坐标
---设置坐标
function projectile:set_point(point)
    self.base():api_set_position(point.base())
end

---@param direction number 朝向
---设置朝向
function projectile:set_facing(direction)
    self.base():api_set_face_angle(Fix32(direction))
end

---@param x number x轴
---@param y number y轴
---@param z number z轴
---设置旋转
function projectile:set_rotation(x, y, z)
    self.base():api_set_rotation(Fix32(x), Fix32(y), Fix32(z))
end

---@param x number x轴
---@param y number y轴
---@param z number z轴
---设置缩放
function projectile:set_scale(x, y, z)
    self.base():api_set_scale(Fix32(x), Fix32(y), Fix32(z))
end

---设置动画速度
function projectile:set_animation_speed(speed)
    self.base():api_set_animation_speed(Fix32(speed))
end

---@param duration number 持续时间
---设置持续时间
function projectile:set_time(duration)
    self.base():api_set_duration(Fix32(duration))
end

---@param duration number 持续时间
---增加持续时间
function projectile:add_time(duration)
    self.base():api_add_duration(Fix32(duration))
end


---@return ability ability 投射物或魔法效果的关联技能
---获得关联技能
function projectile:get_ability()
    local py_ability = global_api.get_related_ability(self.base())
    if py_ability then
        return y3.ability.get_lua_ability_from_py(py_ability)
    end
    return nil
end