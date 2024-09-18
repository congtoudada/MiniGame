require 'python'
Python = python
--require "y3.debugger":start "127.0.0.1:12306"


---全局方法类，提供各种全局方法
---@class y3
---@filed const const
---@filed ability ability
---@field destructible destructible
---@field item item
---@field modifier modifier
---@field projectile projectile
---@field purchase purchase
---@field unit unit
---@field beam beam
---@field item_group item_group
---@field mover mover
---@field particle particle
---@field player player
---@field player_group player_group
---@field timer timer
---@field unit_group unit_group
---@field area area
---@field camera camera
---@field light light
---@field path path
---@field point point
---@field scene_ui scene_ui
---@field ui ui
---@field ui_prefab ui_prefab
y3 = {}

_game_init = false

---枚举统一作为enum的成员
---@class enum
enum = {}


require 'y3.game.event_data'
require 'y3.game.const'
require 'y3.game.constant'
require 'y3.game.trigger'
require 'y3.game.trigger_new'
require 'y3.game.event_manager'
require 'y3.game.event'
require 'y3.game.game_api'
require 'y3.game.global_api'
require 'y3.game.py_obj'
require 'y3.game.tips'
require 'y3.game.util'


require 'y3.editable_object.unit'
require 'y3.editable_object.ability'
require 'y3.editable_object.destructible'
require 'y3.editable_object.item'
require 'y3.editable_object.modifier'
require 'y3.editable_object.projectile'
require 'y3.editable_object.purchase'

require 'y3.runtime_object.beam'
require 'y3.runtime_object.item_group'
require 'y3.runtime_object.math'
require 'y3.runtime_object.mover'
require 'y3.runtime_object.particle'
require 'y3.runtime_object.player'
require 'y3.runtime_object.player_group'
require 'y3.runtime_object.timer'
require 'y3.runtime_object.unit_group'
require 'y3.runtime_object.projectile_group'

require 'y3.scene_object.area'
require 'y3.scene_object.camera'
require 'y3.scene_object.light'
require 'y3.scene_object.path'
require 'y3.scene_object.point'
require 'y3.scene_object.scene_ui'
require 'y3.scene_object.ui'
require 'y3.scene_object.ui_prefab'

event_manager.init()

function print(...)
	local str = ''
    local t = {...}
    for i = 1, #t - 1 do
        str = str .. tostring(t[i]) .. '    '
    end
    str = str .. tostring(t[#t])
	game_api.print_to_dialog(3,str)
end

-- y3.trigger.create_global_trigger("Initialization", function(data)
--     _game_init = true
-- end) 
y3.game:event(const.GlobalEventType['GAME_INIT'],function (data)
    _game_init = true
end)