local setmetatable = setmetatable
local unit = y3.unit.__index
local projectile = y3.projectile.__index

require 'y3.runtime_object.mover_data'

---创建直线运动器
---@param mover_data mover_line_data 数据(y3.create_mover_line_data)
---@param unit_collide function 单位碰撞
---@param mover_finish function 运动完成
---@param terrain_collide function 地形碰撞
---@param mover_interrupt function 运动打断
---@param mover_removed function 运动移除
function unit:mover_line(mover_data,unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
    self.base():create_mover_trigger(mover_data,'StraightMover',unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
end

---创建直线运动器
---@param mover_data mover_line_data 数据(y3.create_mover_line_data)
---@param unit_collide function 单位碰撞
---@param mover_finish function 运动完成
---@param terrain_collide function 地形碰撞
---@param mover_interrupt function 运动打断
---@param mover_removed function 运动移除
function projectile:mover_line(mover_data,unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
    self.base():create_mover_trigger(mover_data,'StraightMover',unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
end

---创建追踪运动器
---@param mover_data mover_target_data 数据(y3.create_mover_target_data)
---@param unit_collide function 单位碰撞
---@param mover_finish function 运动完成
---@param terrain_collide function 地形碰撞
---@param mover_interrupt function 运动打断
---@param mover_removed function 运动移除
function unit:mover_target(mover_data,unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
    self.base():create_mover_trigger(mover_data,'ChasingMover',unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
end

---创建追踪运动器
---@param mover_data mover_target_data 数据(y3.create_mover_target_data)
---@param unit_collide function 单位碰撞
---@param mover_finish function 运动完成
---@param terrain_collide function 地形碰撞
---@param mover_interrupt function 运动打断
---@param mover_removed function 运动移除
function projectile:mover_target(mover_data,unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
    self.base():create_mover_trigger(mover_data,'ChasingMover',unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
end

---创建曲线运动器
---@param mover_data mover_curve_data 数据(y3.create_mover_curve_data)
---@param unit_collide function 单位碰撞
---@param mover_finish function 运动完成
---@param terrain_collide function 地形碰撞
---@param mover_interrupt function 运动打断
---@param mover_removed function 运动移除
function unit:mover_curve(mover_data,unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
    self.base():create_mover_trigger(mover_data,'CurvedMover',unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
end

---创建曲线运动器
---@param mover_data mover_curve_data 数据(y3.create_mover_curve_data)
---@param unit_collide function 单位碰撞
---@param mover_finish function 运动完成
---@param terrain_collide function 地形碰撞
---@param mover_interrupt function 运动打断
---@param mover_removed function 运动移除
function projectile:mover_curve(mover_data,unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
    self.base():create_mover_trigger(mover_data,'CurvedMover',unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
end

---创建环绕运动器
---@param mover_data mover_round_data 数据(y3.create_mover_round_data)
---@param unit_collide function 单位碰撞
---@param mover_finish function 运动完成
---@param terrain_collide function 地形碰撞
---@param mover_interrupt function 运动打断
---@param mover_removed function 运动移除
function unit:mover_round(mover_data,unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
    self.base():create_mover_trigger(mover_data,'RoundMover',unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
end

---创建环绕运动器
---@param mover_data mover_round_data 数据(y3.create_mover_round_data)
---@param unit_collide function 单位碰撞
---@param mover_finish function 运动完成
---@param terrain_collide function 地形碰撞
---@param mover_interrupt function 运动打断
---@param mover_removed function 运动移除
function projectile:mover_round(mover_data,unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
    self.base():create_mover_trigger(mover_data,'RoundMover',unit_collide,mover_finish,terrain_collide,mover_interrupt,mover_removed)
end

---打断单位运动器
---@param owner unit 单位/投射物
function y3.break_mover_on_owner(owner)
    game_api.break_unit_mover(owner.base())
end

---移除单位运动器
---@param owner unit 单位/投射物
function y3.remove_mover_on_owner(owner)
    game_api.remove_unit_mover(owner.base())
end

---打断运动器
function unit:break_mover()
    game_api.break_unit_mover(self.base())
end

---移除运动器
function unit:remove_mover()
    game_api.remove_unit_mover(self.base())
end

---打断运动器
function projectile:break_mover()
    game_api.break_unit_mover(self.base())
end

---移除运动器
function projectile:remove_mover()
    game_api.remove_unit_mover(self.base())
end

---@param mover mover 运动器
---新打断运动器
function y3.break_mover(mover)
    game_api.break_mover(mover)
end

---@param mover mover 运动器
---新移除运动器
function y3.remove_mover(mover)
    game_api.remove_mover(mover)
end

---@param mover mover 运动器
---@param priority integer 优先级
---设置运动器优先级
function y3.set_mover_priority(mover,priority)
    game_api.set_mover_priority(mover,priority)
end

---@param mover mover 运动器
---@param property integer 属性
---@param value number 属性值
---设置运动器属性
function y3.set_mover_property(mover, property, value)
    game_api.set_mover_property(mover,property, value)
end

---@param mover mover 运动器
---@param radius number 属性
---设置运动器碰撞范围
function y3.set_mover_collision_radius(mover, radius)
    game_api.set_mover_collision_radius(mover,Fix32(radius))
end

---@param mover mover 运动器
---@param unit unit 单位
---设置运动器关联单位
function y3.set_mover_relate_unit(mover, unit)
    game_api.set_mover_relate_unit(mover,unit.base())
end

---@param mover mover 运动器
---@param ability ability 技能
---设置运动器关联技能
function y3.set_mover_relate_ability(mover, ability)
    game_api.set_mover_relate_ability(mover,ability.base())
end

---@param mover mover 运动器
---@param angle number 运动方向
---设置运动器运动方向
function y3.set_mover_angle(mover, angle)
    game_api.set_mover_angle(mover,Fix32(angle))
end

---@param obj unit|projectile 单位|投射物
---@return mover mover 运动器
---获得单位|投射物的运动器
function y3.get_mover_by_obj(obj)
    return game_api.get_unit_mover(obj and obj.base() or nil)
end

---@param mover mover 运动器
---@return integer priority 优先级
---获得运动器对象优先级
function y3.get_mover_priority(mover)
    return game_api.get_mover_priority(mover)
end

---@param mover mover 运动器
---@param property integer 属性
---@return number property 属性值
---获得运动器属性值
function y3.get_mover_property(mover,property)
    return game_api.get_mover_priority(mover,property)
end

---@param mover mover 运动器
---@return number angle 运动方向
---获得运动器的运动方向
function y3.get_mover_angle(mover)
    return game_api.get_mover_angle(mover)
end

---@param mover mover 运动器
---@return number radius 碰撞半径
---获得运动器的碰撞半径
function y3.get_mover_collision_radius(mover)
    return game_api.get_mover_collision_radius(mover)
end

---@param mover mover 运动器
---@return unit unit 关联单位
---获得运动器关联单位
function y3.get_mover_relate_unit(mover)
    local py_unit = game_api.get_mover_relate_unit(mover)
    return y3.unit.get_lua_unit_from_py(py_unit)
end

---@param mover mover 运动器
---@return ability ability 关联技能
---获得运动器关联技能
function y3.get_mover_relate_ability(mover)
    local py_ability = game_api.get_mover_relate_ability(mover)
    return y3.ability.get_lua_ability_from_py(py_ability)
end
