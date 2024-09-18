---@class ui_prefab
local ui_prefab = {}
ui_prefab.__index = ui_prefab
y3.ui_prefab = ui_prefab

local UI_PREFAB={}

---@param  py_ui_prefab string 
---@return table 返回在lua层初始化后的lua层技能实例
---通过py层的界面实例获取lua层的界面实例
function ui_prefab.get_lua_ui_prefab_from_py(player,py_ui_prefab)
    if not py_ui_prefab then
        return
    end
    local py = py_obj.new(py_ui_prefab)
    if not UI_PREFAB[player.id] then UI_PREFAB[player.id] = {} end
    if not UI_PREFAB[player.id][py_ui_prefab] then
        local new_ui_prefab = {}
        setmetatable(new_ui_prefab, ui_prefab)
        new_ui_prefab.base = py
        new_ui_prefab.player = player
        UI_PREFAB[player.id][py_ui_prefab] = new_ui_prefab
    end
    return UI_PREFAB[player.id][py_ui_prefab]
end

---@param  player player 玩家
---@param  prefab_ui string 界面模块id
---@param  ui string ui实例
---@return table 返回在lua层初始化后的lua层技能实例
--创建界面模块实例
function ui_prefab.create_ui_prefab_instance(player,prefab_ui,ui)
    local py_ui_prefab = game_api.create_ui_prefab_instance(player.base(),prefab_ui,ui)
    return y3.ui_prefab.get_lua_ui_prefab_from_py(player,py_ui_prefab)
end


--删除界面模块实例
function ui_prefab:remove_ui_prefab()
    game_api.del_ui_prefab(self.base())
end


---@param path string 路径
---@return ui
--通过界面模块路径获取界面模块实例下的控件
function ui_prefab:get_ui_prefab_child_by_path(path)
    local py_ui = game_api.get_ui_prefab_child_by_path(self.player.base(),self.base(),path)
    return y3.ui.get_lua_ui_from_py(self.player ,py_ui)
end

