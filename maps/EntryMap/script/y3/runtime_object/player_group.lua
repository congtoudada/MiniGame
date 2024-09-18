--- File Name : player_group.lua
--- Created By : liruiguang
--- Description: 玩家组

local setmetatable = setmetatable
local ipairs = ipairs

---@class player_group
local player_group = {}
player_group.__index = player_group
y3.player_group = player_group
local PlayerGp = setmetatable({}, { __mode = 'kv' })

function player_group.create_lua_player_group_from_py(py_player_group)
    local id = py_id(py_player_group)
    if not PlayerGp[id] then
        local new = {}
        local py = py_obj.new(py_player_group)
        new.base = py
        setmetatable(new, player_group)
        PlayerGp[id] = new
    end
    return PlayerGp[id]
end

--遍历玩家组中玩家做动作
function player_group:pick()
    local lua_table = {}
    for i = 0, python_len(self.base()) - 1 do
        local iter_player = python_index(self.base(), i)
        table.insert(lua_table, y3.player(iter_player))
    end
    return lua_table
end

---@param player player 玩家
--添加玩家
function player_group:add_player(player)
    game_api.add_role_to_group(player.base(), self.base())
end

---@param player player 玩家
--移除玩家
function player_group:remove_player(player)
    game_api.rem_role_from_group(player.base(), self.base())
end

--清空组
function player_group:clear_group()
    global_api.clear_group(self.base())
end

---获取玩家组的玩家数量
function player_group:get_player_num()
    return global_api.get_player_group_num(self.base())
end

---@return player_group player_group 玩家组
---獲取所有玩家
function player_group.get_all_players()
    return player_group.create_lua_player_group_from_py(game_api.get_all_role_ids())
end

---@param camp integer 陣營
---@return player_group player_group 玩家组
---陣營內所有玩家
function player_group.get_player_group_by_camp(camp)
    return player_group.create_lua_player_group_from_py(game_api.get_role_ids_by_camp(camp))
end

---@param player player 玩家
---@return player_group player_group 玩家组
---玩家的所有敌对玩家
function player_group.get_enemy_player_group_by_player(player)
    return player_group.create_lua_player_group_from_py(game_api.get_enemy_ids_by_role(player.base()))
end

---@param player player 玩家
---@return player_group player_group 玩家组
---玩家的所有同盟玩家
function player_group.get_ally_player_group_by_player(player)
    return player_group.create_lua_player_group_from_py(game_api.get_ally_ids_by_role(player.base()))
end

---@return player_group player_group 玩家组
---获取所有胜利的玩家
function player_group.get_victorious_player_group()
    return player_group.create_lua_player_group_from_py(game_api.get_victorious_role_ids())
end

---@return player_group player_group 玩家组
---获取所有失败的玩家
function player_group.get_defeated_player_group()
    return player_group.create_lua_player_group_from_py(game_api.get_defeated_role_ids())
end

---@return player_group player_group 玩家组
---所有非中立玩家
function player_group.get_neutral_player_group()
    return player_group.create_lua_player_group_from_py(game_api.get_role_ids_by_type(1))
end

---@return player player 玩家
---获取玩家组中随机一个玩家
function player_group:get_random_role(player_group)
    return y3.player(game_api.get_random_role_in_role_group(self.base()))
end

---@return player player 玩家
---获取玩家组中第一个玩家
function player_group:get_first_role(player_group)
    return y3.player(game_api.get_first_role_in_group(self.base()))
end

---@return player player 玩家
---获取玩家组中第一个玩家
function player_group:get_last_role()
    return y3.player(game_api.get_last_role_in_group(self.base()))
end
