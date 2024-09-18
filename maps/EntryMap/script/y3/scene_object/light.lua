--- File Name : light.lua

--- Description: 光源

local setmetatable = setmetatable

---@class  light
local light = {}
light.__index = light
y3.light = light

local Lights = {}


---@param scene_id number 编辑场景中的id
---根据场景id获得点光源
function y3.get_point_light_by_scene_id(scene_id)
    if not Lights[scene_id] then
        local new_light = {}
        new_light.scene_id = scene_id
        local py = py_obj.new(game_api.get_point_light_res_by_res_id(scene_id))
        new_light.base = py
        Lights[scene_id] = new_light
        setmetatable(new_light, light)
    end
    return Lights[scene_id]
end

---@param scene_id number 编辑场景中的id
---根据场景id获得聚光灯
function y3.get_directional_light_by_scene_id(scene_id)
    if not Lights[scene_id] then
        local new_light = {}
        new_light.scene_id = scene_id
        local py = py_obj.new(game_api.get_spot_light_res_by_res_id(scene_id))
        new_light.base = py
        Lights[scene_id] = new_light
        setmetatable(new_light, light)
    end
    return Lights[scene_id]
end

---@param scene_id number 编辑场景中的id
---根据场景id获得雾气
function y3.get_fog_by_scene_id(scene_id)
    return game_api.get_fog_res_by_res_id(scene_id)
end

function y3.create_lua_light_by_py(py_light)
    local new = {}
    local py = py_obj.new(py_light)
    new.base = py
    setmetatable(new, light)
    return new
end


--TODO:点光源属性枚举需在Lua层处理

---@param key string 属性名
---@return number 属性值
---获取光源属性
function light:get_light_attribute(key)
    return game_api.get_light_float_attr_value(self.base(), key)
end


---@return boolean 是否产生阴影
---获取光源是否产生阴影
function light:get_light_cast_shadow_state()
    return game_api.get_light_cast_shadow_attr_value(self.base())
end


---@param point point 目标点
---@param deviation_height number 偏移高度
--创建点光源到点
function light.create_point_light_at_point(point,deviation_height)
    local py_light = game_api.create_point_light_to_point(point.base(), Fix32(deviation_height))
    return y3.create_lua_light_by_py(py_light)
    
end


---@param unit unit 目标单位
---@param socket_name string 挂接点
---@param deviation_height number 偏移高度
--创建点光源到单位挂接点
function light.create_point_light_at_unit_socket(unit,socket_name,deviation_height)
    local py_obj = game_api.create_point_light_to_unit_socket(unit.base(), socket_name, Fix32(deviation_height))
    return y3.create_lua_light_by_py(py_obj)
end


---@param point point 目标点
---@param deviation_height number 偏移高度
---@param unit_point_projectile point 目标点
---@param target_deviation_height number 目标点偏移高度
--创建方向光源到点
function light.create_directional_light_at_point(point,deviation_height,unit_point_projectile,target_deviation_height)
    local py_obj = game_api.create_spot_light_to_point(point.base(), Fix32(deviation_height), unit_point_projectile and unit_point_projectile.base() or nil, Fix32(target_deviation_height))
    return y3.create_lua_light_by_py(py_obj)
end


---@param unit unit 目标单位
---@param socket_name string 挂接点
---@param deviation_height number 偏移高度
---@param target_unit unit 目标单位
---@param target_deviation_height number 目标点偏移高度
--创建方向光源到单位挂接点
function light.create_directional_light_at_unit_socket(unit,socket_name,deviation_height,target_unit,target_deviation_height)
    local py_obj = game_api.create_spot_light_to_unit_socket(unit.base(), socket_name, Fix32(deviation_height), target_unit and target_unit.base() or nil, Fix32(target_deviation_height))
    return y3.create_lua_light_by_py(py_obj)
end

--删除光源
function light:remove_light()
    game_api.remove_light(self.base())
end



---@param is_cast_shadow boolean 是否产生阴影
--设置光源是否产生阴影
function light:set_shadow_casting_status(is_cast_shadow)
    game_api.set_light_cast_shadow_attr_value(self.base(), is_cast_shadow)
end



---@param light_attr_type integer 属性名
---@param value number 属性值
--设置点光源属性
function light:set_point_light_attribute(light_attr_type,value)
    game_api.set_light_float_attr_value(self.base(), light_attr_type, Fix32(value))
end


---@param light_attr_type integer 属性名
---@param value number 属性值
--设置方向光源属性
function light:set_directional_light_attribute(light_attr_type,value)
    game_api.set_light_float_attr_value(self.base(), light_attr_type, Fix32(value))
end
