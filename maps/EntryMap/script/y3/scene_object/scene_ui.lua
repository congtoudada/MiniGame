---@class scene_ui
local scene_ui = {}
scene_ui.__index = scene_ui
y3.scene_ui = scene_ui

local SCENE_UI = {}

---通过py层的界面实例获取lua层的界面实例
---@param  py_scene_ui string 
---@return table 返回在lua层初始化后的lua层技能实例
function scene_ui.get_lua_scene_ui_from_py(py_scene_ui,player)
    if not py_scene_ui then
        return
    end
    if not player then
        player = y3.get_client_player()
    end
    local py = py_obj.new(py_scene_ui)
    if not SCENE_UI[player.id] then SCENE_UI[player.id] = {} end
    if not SCENE_UI[player.id][py] then
        local new_scene_ui = {}
        setmetatable(new_scene_ui, scene_ui)
        new_scene_ui.base = py
        new_scene_ui.player = player
        SCENE_UI[player.id][py] = new_scene_ui
    end
    return SCENE_UI[player.id][py]
end


---@param  sceneui string 控件
---@param  point point 点
---@param  range number 可见距离
---@param  height number 离地高度
---@return point scene_ui 场景ui
---创建场景界面到场景点 
function scene_ui.create_scene_ui_at_point(sceneui,point,range,height)
    return game_api.create_scene_node_on_point(sceneui, point.base(), range, Fix32(height))
end



---@param scene_ui_type number 场景ui类型
---@param player player 玩家
---@param unit unit 单位
---@param socket_name string 挂接点名称
---@param distance number 可见距离
---@return scene_ui 场景ui
--创建场景界面到玩家单位挂点
function scene_ui.create_scene_ui_at_player_unit_socket(scene_ui_type,player,unit,socket_name,distance)
    local py_scene_ui = game_api.create_scene_node_on_unit(scene_ui_type,player.base(),unit.base(),socket_name,distance or 999999)
    return y3.scene_ui.get_lua_scene_ui_from_py(py_scene_ui,player)
end

--删除场景界面
function scene_ui:remove_scene_ui()
    game_api.delete_scene_node(self.base())
end


---@return ui
--获取场景UI中的控件
function scene_ui:get_widget_in_scene_ui(str)
    local py_ui = game_api.get_ui_comp_in_scene_ui(self.base(),str)
    return y3.ui.get_lua_ui_from_py(self.player,py_ui)
end



---@param player player 玩家
---@param dis number 可见距离
--设置场景界面对玩家的可见距离
function scene_ui:set_scene_ui_visible_distance(player,dis)
    game_api.set_scene_node_visible_distance(self.base(),player.base(),dis)
end
