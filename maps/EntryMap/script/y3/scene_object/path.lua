--- File Name : path.lua

--- DateTime: 2023/2/14 16:31


local setmetatable = setmetatable

---@class  path
local path = {}
path.__index = path
y3.path = path

local Path = {}


---@param scene_id number 编辑场景中的id
---根据场景id获得路径
function y3.get_path_by_scene_id(scene_id)
    if not Path[scene_id] then
        local new_path = {}
        new_path.scene_id = scene_id
        local py = py_obj.new(game_api.get_road_point_list_by_res_id(scene_id))
        new_path.base = py
        Path[scene_id] = new_path
        setmetatable(new_path, path)
    end
    return Path[scene_id]
end


---@param py_path table py层对象
---根据py对象创建路径
function path.get_lua_path_from_py(py_path)
    --local id = 0 --TODO:这里需要确认获取id的方法
    --if not Path[id] then
        local new_path = {}
        --new_path.scene_id = id
        new_path.base = py_obj.new(py_path)
        --Path[id] = new_path
        setmetatable(new_path, path)
    --end
    return new_path
end


---@param tag string tag
---@return boolean 路径是否有tag
---路径是否有tag
function path:has_tag(tag)
    return game_api.if_road_has_tag(self.base(), tag)
end

---删除路径
function path:remove_path()
    game_api.remove_road_point_list(self.base())
end


---@param index number 序号
---@param point point 点
---给路径添加点
function path:add_point(index, point)
    game_api.add_road_point(self.base(), Fix32(index), point.base())
end


---@param index number 序号
---给路径移除点
function path:remove_point(index)
    game_api.remove_road_point(self.base(), Fix32(index))
end


---@param tag string 序号
---给路径添加标签
function path:add_tag(tag)
    game_api.add_road_tag(self.base(), tag)
end


---@param tag string 序号
---给路径移除标签
function path:remove_tag(tag)
    game_api.remove_road_tag(self.base(), tag)
end

---获取路径中点的个数
function path:get_point_count()
    return game_api.get_road_point_num(self.base())
end




--------------------------------------------------------类的方法--------------------------------------------------------


---@param start_point point 起点
---@return path 创建的路径
---以点为起点创建路径
function path.create_path(start_point)
    local py_path = game_api.create_road_point_list(start_point.base())
    if py_path then
        return path.get_lua_path_from_py(py_path)
    end
end

---路径 - 遍历标签做动作
---@param tag string 标签
---@return table path 路径
function path.get_path_areas_by_tag(tag)
    local paths = {}
    local py_list = game_api.get_roads_by_tag(tag)
    for i = 0, python_len(py_list)-1 do
        local lua_path = path.get_lua_path_from_py(python_index(py_list,i))
        table.insert(paths, lua_path)
    end
    return paths
end







