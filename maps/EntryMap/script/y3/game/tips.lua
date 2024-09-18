--- File Name : tips.lua

--- Description: 这个脚本本身没有意义，只是为了让一些代码能显示提示

---@class trigger_group
local trigger_group = {}
function trigger_group.add_trigger()
end

---@class mover_data
local mover_data = {}
---@type unit | projectile
---拥有者
mover_data.owner = nil
---@type number
---面向角度
mover_data.angle = nil
---@type number
---最大距离
mover_data.dis = nil
---@type number
---初始速度
mover_data.speed = nil
---@type number 加速度
mover_data.accel = nil
---@type number 最大速度
mover_data.max_speed = nil
---@type number 最小速度
mover_data.min_speed = nil
---@type number 初始高度
mover_data.height = nil
---@type number 目标高度
mover_data.target_height = nil
mover_data.parabola_height = nil
mover_data.hit_type = nil
mover_data.hit_area = nil
mover_data.is_face = nil
mover_data.is_hit_same = nil
mover_data.is_block = nil
mover_data.level = nil
mover_data.is_parabola_height = nil
mover_data.is_absolute_height = nil
mover_data.is_open_init_height = nil
mover_data.is_open_fin_height = nil

---@type function 碰撞时
mover_data.on_hit = nil
mover_data.on_finish = nil
mover_data.on_block = nil
mover_data.on_finish = nil
mover_data.on_remove = nil


