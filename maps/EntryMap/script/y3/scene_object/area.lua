--- File Name : area.lua
--- Created By : duli
--- Description: 区域相关逻辑--对应编辑器圆形区域和矩形区域

local setmetatable = setmetatable

---@class  area
local area = {}
area.__index = area
y3.area = area

local Areas = {}

area.enum = {}
area.enum.circle = 1
area.enum.rectangle = 2
area.enum.polygon = 3


---@param scene_id number 编辑场景中的id
---根据场景id获得圆形区域
function y3.get_circle_area_by_scene_id(scene_id)
    if not Areas[scene_id] then
        local new_area = {}
        new_area.type = area.enum.circle
        new_area.scene_id = scene_id
        local py = py_obj.new(game_api.get_circle_area_by_res_id(scene_id))
        new_area.base = py
        Areas[scene_id] = new_area
        setmetatable(new_area, area)
    end
    return Areas[scene_id]
end

---@param scene_id number 编辑场景中的id
---根据场景id获得矩形区域
function y3.get_rectangle_area_by_scene_id(scene_id)
    if not Areas[scene_id] then
        local new_area = {}
        new_area.type = area.enum.rectangle
        new_area.scene_id = scene_id
        local py = py_obj.new(game_api.get_rec_area_by_res_id(scene_id))
        new_area.base = py
        Areas[scene_id] = new_area
        setmetatable(new_area, area)
    end
    return Areas[scene_id]
end

---@param scene_id number 编辑场景中的id
---根据场景id获得多边形区域
function y3.get_polygon_area_by_scene_id(scene_id)
    if not Areas[scene_id] then
        local new_area = {}
        new_area.type = area.enum.polygon
        new_area.scene_id = scene_id
        local py = py_obj.new(game_api.get_polygon_area_by_res_id(scene_id))
        new_area.base = py
        Areas[scene_id] = new_area
        setmetatable(new_area, area)
    end
    return Areas[scene_id]
end

---@param py_area table py层对象
---@param type integer 见area.enum
---根据py对象创建区域
function area.get_lua_area_from_py(py_area, type)
    local new_area = {}
    local py = py_obj.new(py_area)
    new_area.type = type
    new_area.base = py
    setmetatable(new_area, area)
    return new_area
end


---删除区域
function area:remove()
    game_api.remove_area(self.base())
end

---@param is_collision_effect boolean  碰撞是否生效
---@param is_land_effect boolean  地面碰撞开关
---@param is_air_effect boolean  空中碰撞开关
---设置区域碰撞
function area:set_collision(is_collision_effect, is_land_effect, is_air_effect)
    game_api.set_area_collision(self.base(), is_collision_effect, is_land_effect, is_air_effect)
end

---@param tag string tag
---给区域添加标签
function area:add_tag(tag)
    game_api.add_area_tag(self.base(), tag)
end

---@param tag string tag
---给区域移除标签
function area:remove_tag(tag)
    game_api.remove_area_tag(self.base(), tag)
end

---@param tag string tag
---@return boolean 区域是否有tag
---区域是否有tag
function area:has_tag(tag)
    if area.enum == area.enum.circle then
        return game_api.if_cir_area_has_tag(self.base(), tag)
    elseif area.enum == area.enum.rectangle then
        return game_api.if_rect_area_has_tag(self.base(), tag)
    end
    return false
end

---@param player player 玩家
---@param is_visibility boolean 是否开启视野
---@param is_real_visibility boolean 是否开启真实视野
---设置多边形区域对玩家可见性
function area:set_visible(player, is_visibility, is_real_visibility)
    if self.type == area.enum.circle then
        game_api.set_circle_vision_visibility(self.base(), player.base(), is_visibility, is_real_visibility)
    elseif self.type == area.enum.rectangle then
        game_api.set_rect_vision_visibility(self.base(), player.base(), is_visibility, is_real_visibility)
    elseif self.type == area.enum.polygon then
        game_api.set_poly_vision_visibility(self.base(), player.base(), is_visibility, is_real_visibility)
    end
end

---@param radius number 半径
---设置圆形区域半径
function area:set_radius(radius)
    if self.type == area.enum.circle then
        game_api.set_cir_area_radius(self.base(), Fix32(radius))
    end
end

---@param horizontal_length number 长度
---@param vertical_length number 宽度
---设置矩形区域半径
function area:set_size(horizontal_length, vertical_length)
    if self.type == area.enum.rectangle then
        game_api.set_rect_area_radius(self.base(), Fix32(horizontal_length), Fix32(vertical_length))
    end
end

---@return  number 半径
---获得圆形区域半径
function area:get_radius()
    if self.type == area.enum.circle then
        return game_api.get_circle_area_radius(self.base())
    end
end

---@return  number X坐标
---获取圆形区域内最小X坐标
function area:get_min_x()
    if self.type == area.enum.circle then
        return game_api.get_circle_area_min_x(self.base())
    end    
    if self.type == area.enum.rectangle then
        return game_api.get_rect_area_min_x(self.base())
    end
end

function area:get_min_y()
    if self.type == area.enum.circle then
        return game_api.get_circle_area_min_y(self.base())
    end
    if self.type == area.enum.rectangle then
        return game_api.get_rect_area_min_y(self.base())
    end
end

function area:get_max_x()
    if self.type == area.enum.circle then
        return game_api.get_circle_area_max_x(self.base())
    end
    if self.type == area.enum.rectangle then
        return game_api.get_rect_area_max_x(self.base())
    end
end

function area:get_max_y()
    if self.type == area.enum.circle then
        return game_api.get_circle_area_max_y(self.base())
    end
    if self.type == area.enum.rectangle then
        return game_api.get_rect_area_max_y(self.base())
    end
end

function area:get_center_point()
    if self.type == area.enum.circle then
        local py_point = game_api.get_circle_center_point(self.base())
        return y3.get_lua_point_from_py(py_point)
    end
    if self.type == area.enum.rectangle then
        local py_point = game_api.get_rec_center_point(self.base())
        return y3.get_lua_point_from_py(py_point)
    end
end

function area:random_point()
    if self.type == area.enum.circle then
        local py_point = game_api.get_random_point_in_circular_area(self.base())
        if py_point then
            return y3.get_lua_point_from_py(py_point)
        end
    end
    if self.type == area.enum.polygon then
        local py_point = game_api.get_random_point_in_poly_area(self.base())
        if py_point then
            return y3.get_lua_point_from_py(py_point)
        end
    end
    if self.type == area.enum.rectangle then
        local py_point = game_api.get_random_point_in_rec_area(self.base())
        if py_point then
            return y3.get_lua_point_from_py(py_point)
        end
    end
end


---@return  number 天气枚举
---获得区域天气
function area:get_weather()
    return game_api.get_area_weather(self.base())
end

---@return  table 单位组
---区域内的所有单位(单位组)
function area:get_all_unit_in_area()
    local py_unit_group = game_api.get_unit_group_in_area(self.base())
    if py_unit_group then
        return y3.unit_group.create_lua_unit_group_from_py(py_unit_group)
    end
    return nil
end

---@param player player 玩家
---@return  table 单位组
---区域内玩家单位(单位组)
function area:get_unit_group_in_area(player)
    local py_unit_group = game_api.get_unit_group_belong_to_player_in_area(self.base(), player.base())
    if py_unit_group then
        return y3.unit_group.create_lua_unit_group_from_py(py_unit_group)
    end
    return nil
end

---@return  number 数量
---区域中单位的数量
function area:get_unit_num_in_area()
    return game_api.get_unit_num_in_area(self.base())
end

---@param collision_layer number 碰撞类型
---@param is_add boolean  添加/去除
---编辑区域碰撞
function area:edit_area_collision(collision_layer, is_add)
    game_api.edit_area_collision(self.base(), collision_layer, is_add)
end

---@param fov_block_type number 视野阻挡类型
---@param is_add boolean  添加/去除
---编辑区域视野阻挡
function area:edit_area_fov_block(fov_block_type, is_add)
    game_api.edit_area_fov_block(self.base(), fov_block_type, is_add)
end

--------------------------------------------------------类的方法--------------------------------------------------------



---获取完整地图区域
function area.get_map_range()
    local py_area = game_api.get_usable_map_range()
    if py_area then
        return area.get_lua_area_from_py(py_area, area.enum.rectangle)
    end
    return nil
end

---获得最后创建的矩形区域
function area.get_rectangle_area_last_created()
    local py_area = game_api.get_rec_area_last_created()
    if py_area then
        return area.get_lua_area_from_py(py_area, area.enum.rectangle)
    end
    return nil
end

---@param point point 点
---@param radius number 半径
---@return area 圆形区域
---创建圆形区域
function area.create_circle_area(point, radius)
    local py_area = game_api.create_new_cir_area(point.base(), Fix32(radius))
    if py_area then
        return area.get_lua_area_from_py(py_area, area.enum.circle)
    end
    return nil
end

---@param point point 点
---@param horizontal_length number 长度
---@param vertical_length number 宽度
---@return area area 矩形区域
---创建矩形区域
function area.create_rectangle_area(point, horizontal_length, vertical_length)
    local py_area = game_api.create_rect_area_by_center(point.base(), Fix32(horizontal_length), Fix32(vertical_length))
    if py_area then
        return area.get_lua_area_from_py(py_area, area.enum.rectangle)
    end
    return nil
end

---@param point_one point 点1
---@param point_two point 点2
---@return area area 矩形区域
---以起点终点创建矩形区域
function area.create_rectangle_area_from_two_points(point_one, point_two)
    local py_area = game_api.create_rec_area_from_two_points(point_one.base(), point_two.base())
    if py_area then
        return area.get_lua_area_from_py(py_area, area.enum.rectangle)
    end
    return nil
end

---@param point1 point 点1
---@param point2 point 点2
---@param point3 point 点3
---@param point4 point 点4
---@param point5 point 点5
---@param point6 point 点6
---@param point7 point 点7
---@param point8 point 点8
---@param point9 point 点9
---@param point10 point 点10
---@param point11 point 点11
---@param point12 point 点12
---@param point13 point 点13
---@return area polygon 多边形区域
---沿点创建多边形
function area.create_polygon_area_by_points(point1, point2, point3, point4, point5, point6, point7, point8, point9,
                                            point10, point11, point12, point13)
    local _points = {point1, point2, point3, point4, point5, point6, point7, point8, point9,point10, point11, point12, point13}
    for k, v in ipairs(_points) do
        _points[k] = v.base()
    end
    local py_area = game_api.create_polygon_area_new(_points[1], _points[2], _points[3], _points[4],
    _points[5], _points[6], _points[7], _points[8], _points[9], _points[10], _points[11],_points[12],
    _points[13])
    if py_area then
        return area.get_lua_area_from_py(py_area, area.enum.polygon)
    end
    return nil
end

---圆形区域 - 遍历标签做动作
---@param tag string 标签
---@return table area 矩形区域
function area.get_circle_areas_by_tag(tag)
    --TODO:等待遍历优化
    local areas = {}
    local py_list = game_api.get_cir_areas_by_tag(tag)
    for i = 0, python_len(py_list) - 1 do
        local lua_area = area.get_lua_area_from_py(python_index(py_list, i))
        table.insert(areas, lua_area)
    end
    return areas
end

---矩形区域 - 遍历标签做动作
---@param tag string 标签
---@return table area 矩形区域表
function area.get_rect_areas_by_tag(tag)
    --TODO:等待遍历优化
    local areas = {}
    local py_list = game_api.get_rect_areas_by_tag(tag)
    for i = 0, python_len(py_list) - 1 do
        local lua_area = area.get_lua_area_from_py(python_index(py_list, i))
        table.insert(areas, lua_area)
    end
    return areas
end

---多边形区域 - 遍历标签做动作
---@param tag string 标签
---@return table area 多边形区域表
function area.get_polygon_areas_by_tag(tag)
    --TODO:等待遍历优化
    local areas = {}
    local py_list = game_api.get_polygon_areas_by_tag(tag)
    for i = 0, python_len(py_list) - 1 do
        local lua_area = area.get_lua_area_from_py(python_index(py_list, i))
        table.insert(areas, lua_area)
    end
    return areas
end

---多边形区域 - 遍历定点做动作
---@param polygon area 多边形区域
---@return table area 多边形顶点表
function area.get_polygon_areas_point_list(polygon)
    --TODO:等待遍历优化
    local points = {}
    local py_list = game_api.get_poly_area_point_list(polygon)
    for i = 0, python_len(py_list) - 1 do
        local lua_area = y3.get_lua_point_from_py(python_index(py_list, i))
        table.insert(points, lua_area)
    end
    return points
end
