--- File Name : area.lua
--- Created By : duli
--- Description: 区域相关逻辑--对应编辑器圆形区域和矩形区域

local setmetatable = setmetatable

---@class  point
local point = {}
point.__index = point
-- y3.point = point
point.type = 'point'
local Points = {}

-- function point:__tostring()
--     return ('%s|%s|%s|%s'):format('point', y3.get_point_x(self),y3.get_point_y(self),y3.get_point_z(self))
-- end

---@param scene_id number 编辑场景中的id
---根据场景id获得区域
function y3.get_point_by_scene_id(scene_id)
    if not Points[scene_id] then
        local new_point = {}
        new_point.scene_id = scene_id
        local py = py_obj.new(game_api.get_point_by_res_id(scene_id))
        new_point.base = py
        Points[scene_id] = new_point
        setmetatable(new_point, point)
    end
    return Points[scene_id]
end


---@param py_point table py层对象
---根据py对象创建点
function y3.get_lua_point_from_py(py_point)
    local new_point = {}
    local py = py_obj.new(py_point)
    new_point.base = py
    setmetatable(new_point, point)
    return new_point
end


---@param is_collision_effect boolean  碰撞是否生效
---@param is_land_effect boolean  地面碰撞开关
---@param is_air_effect boolean  空中碰撞开关
---设置碰撞
function point:set_collision(is_collision_effect, is_land_effect, is_air_effect)
    game_api.set_point_collision(self.base(), is_collision_effect, is_land_effect, is_air_effect)
end

---获取地图在该点位置的碰撞类型 
--TODO:需要确认有哪些类型，ECA哪里用到
function point:get_ground_collision()
    return game_api.get_point_ground_collision(self.base)
end

---获取地图在该点位置的视野类型
--TODO:需要确认有哪些类型，ECA哪里用到
function point:get_view_block_type()
    return game_api.get_point_view_block_type(self.base)
end


---comment
---@param point point 目标点
---点的x坐标
function y3.get_point_x(point)
    return global_api.get_fixed_coord_index(point.base(), 0):float()
end


---@param point point 目标点
---点的y坐标
function y3.get_point_y(point)
    return global_api.get_fixed_coord_index(point.base(), 2):float()
end


---@param point point 目标点
---点的z坐标
function y3.get_point_z(point)
    return global_api.get_fixed_coord_index(point.base(), 1):float()
end


---@param x number 点X坐标
---@param y number 点Y坐标
---@param z number 点Z坐标
---坐标转化为点
function y3.point(x, y, z)
    local py_point = global_api.coord_to_point(Fix32(x), Fix32(y), Fix32(z or 0))
    return y3.get_lua_point_from_py(py_point)
end


---@param point point 点
---@param direction number 偏移方向点
---@param offset point 偏移量
---点向方向偏移
function y3.get_point_offset_vector(point, direction, offset)
    local py_point = global_api.get_point_offset_vector(point.base(), Fix32(direction), Fix32(offset))
    return y3.get_lua_point_from_py(py_point)
end


---@param path table 目标路径
---@param index number 索引
---路径中的点
function y3.get_point_in_path(path,index)
    local py_point = global_api.get_point_in_route(path.base(),index)
    return y3.get_lua_point_from_py(py_point)
end

---@param id integer 场景ID
---根据场景ID获取点
function y3.get_point_by_res_id(id)
    local py_point = game_api.get_point_by_res_id(id)
    return y3.get_lua_point_from_py(py_point)
end

