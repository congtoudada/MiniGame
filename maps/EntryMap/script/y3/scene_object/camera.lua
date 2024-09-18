--- File Name : camera.lua

--- Description: 镜头

local setmetatable = setmetatable

---@class  camera
local camera = {}
camera.__index = camera
y3.camera = camera

local Cameras = {}


---@param scene_id number 编辑场景中的id
---根据场景id获得镜头
function y3.get_camera_by_scene_id(scene_id)
    if not Cameras[scene_id] then
        local new_camera = {}
        new_camera.scene_id = scene_id
        Cameras[scene_id] = new_camera
        setmetatable(new_camera, camera)
    end
    return Cameras[scene_id]
end


---@return boolean 是否正在播放动画
---玩家镜头是否正在播放动画
function camera.is_camera_playing_timeline(player)
    return game_api.is_cameraIS_playing_timeline(player.base())
end


---@param point point 镜头所在点
---@param focal_length number 焦距
---@param focal_height number 焦点高度
---@param yaw number 镜头的yaw
---@param pitch number 镜头的pitch
---@param range_of_visibility number 远景裁切范围
---创建镜头
function camera.create_camera(point, focal_length, focal_height, yaw, pitch, range_of_visibility)
    focal_length = focal_length ~= nil and Fix32(focal_length) or nil
    yaw = yaw ~= nil and Fix32(yaw) or nil
    pitch = pitch ~= nil and Fix32(pitch) or nil
    focal_height = focal_height ~= nil and Fix32(focal_height) or nil
    range_of_visibility = range_of_visibility ~= nil and Fix32(range_of_visibility) or nil
    local id = game_api.add_camera_conf(point.base(), focal_length, focal_height, yaw, pitch, range_of_visibility)
    return y3.get_camera_by_scene_id(id)
end


---@param player player 玩家
---@param camera camera 镜头
---@param time number 过渡时间
---@param move_type number 移动方式枚举
---应用镜头 
function camera.apply_camera(player, camera, time, move_type)
    if type(camera) ~= 'number' then
        game_api.apply_camera_conf(player.base(), camera.scene_id, Fix32(time), move_type)
    else
        game_api.apply_camera_conf(player.base(), scene_id, Fix32(time), move_type)
    end
end

---允许玩家镜头移动
---@param player player 玩家
function camera.enable_camera_move(player)
    game_api.camera_set_move_enable(player.base())
end


---@param player player 玩家
---禁止玩家镜头移动
function camera.disable_camera_move(player)
    game_api.camera_set_move_not_enable(player.base())
end


---@param player player 玩家
---@param camera_timeline_id number 镜头动画ID
---播放镜头动画
function camera.play_camera_timeline(player, camera_timeline_id)
    game_api.play_camera_timeline(player.base(), camera_timeline_id)
end


---@param player player 玩家
---停止镜头动画
function camera.stop_camera_timeline(player)
    game_api.stop_camera_timeline(player.base())
end


---@param player player 玩家
---@param shake number 震动幅度
---@param attenuation number 衰减
---@param frequency number 频率
---@param time number 持续时间
---@param shake_type number 震动模式
---镜头带衰减震动
function camera.camera_shake_with_decay(player, shake, attenuation, frequency, time, shake_type)
    game_api.camera_shake_with_decay(player.base(), Fix32(shake), Fix32(attenuation), Fix32(frequency), Fix32(time), shake_type)
end


---@param player player 玩家
---@param strength number 晃动幅度
---@param speed number 速率
---@param time number 持续时间
---@param shake_type number 震动模式
---镜头摇晃镜头
function camera.camera_shake(player, strength, speed, time, shake_type)
    game_api.camera_shake(player.base(), Fix32(strength), Fix32(speed), Fix32(time), shake_type)
end


---@param player player 玩家
---@param point point 目标点
---@param time number 过渡时间
---@param move_type number 移动模式
---线性移动（时间）
function camera.linear_move_by_time(player, point, time, move_type)
    time = time ~= nil and Fix32(time) or nil
    game_api.camera_linear_move_duration(player.base(), point.base(), time, move_type)
end


---@param player player 玩家
---@param unit unit 目标单位
---@param x number 过渡时间
---@param y number 移动模式
---@param height number 高度
---设置镜头跟随单位
function camera.set_camera_follow_unit(player, unit, x, y, height)
    x = x ~= nil and Fix32(x) or nil
    y = y ~= nil and Fix32(y) or nil
    height = height ~= nil and Fix32(height) or nil

    game_api.camera_set_follow_unit(player.base(), unit.base(), x, y, height)
end


---@param player player 玩家
---设置镜头取消跟随
function camera.cancel_camera_follow_unit(player)
    game_api.camera_cancel_follow_unit(player.base())
end


---@param player player 玩家
---@param unit unit 目标单位
---@param sensitivity number 灵敏度
---@param yaw number yaw
---@param pitch number pitch
---@param x_offset number 偏移量X
---@param y_offset number 偏移量Y
---@param z_offset number 偏移高度
---@param camera_distance number 距离焦点距离
---设置镜头第三人称跟随单位
function camera.set_tps_follow_unit(player, unit, sensitivity, pitch,yaw,  x_offset, y_offset, z_offset, camera_distance)
    sensitivity = sensitivity ~= nil and Fix32(sensitivity) or 5
    yaw = yaw ~= nil and Fix32(yaw) or 6
    pitch = pitch ~= nil and Fix32(pitch) or 3
    x_offset = x_offset ~= nil and Fix32(x_offset) or 0
    y_offset = y_offset ~= nil and Fix32(y_offset) or 10
    z_offset = z_offset ~= nil and Fix32(z_offset) or 1
    camera_distance = camera_distance ~= nil and Fix32(camera_distance) or 13
    game_api.camera_set_tps_follow_unit(player.base(), unit.base(),sensitivity , pitch,yaw, x_offset, y_offset, z_offset, camera_distance)
end


---@param player player 玩家
---取消镜头第三人称跟随单位
function camera.cancel_tps_follow_unit(player)
    game_api.camera_cancel_tps_follow_unit(player.base())
end


---@param player player 玩家
---@param point point 目标点
---@param time number 过渡时间
---设置镜头朝向点
function camera.look_at_point(player, point, time)
    time = time ~= nil and Fix32(time) or 0
    game_api.camera_look_at(player.base(), point.base(), Fix32(time))
end


---@param player player 玩家
---@param value number 高度上限/单位为m,编辑器中为cm
---设置镜头高度上限
function camera.set_max_distance(player, value)
    game_api.set_camera_distance_max(player.base(), Fix32(value))
end


---@param player player 玩家
---@param angle_type number 角度类型
---@param value number 值
---@param time number 过渡时间
---设置镜头角度
function camera.set_rotate(player, angle_type, value, time)
    time = time ~= nil and Fix32(time) or 0
    game_api.camera_set_param_rotate(player.base(), angle_type, Fix32(value), Fix32(time))
end


---@param player player 玩家
---@param value number 值
---@param time number 过渡时间
---设置焦点距离
function camera.set_distance(player, value, time)
    time = time ~= nil and Fix32(time) or 0
    game_api.camera_set_param_distance(player.base(), Fix32(value), Fix32(time))
end


---@param player player 玩家
---@param value number 值
---@param time number 过渡时间
---设置镜头焦点高度
function camera.set_focus_height(player, value, time)
    time = time ~= nil and Fix32(time) or 0
    game_api.camera_set_focus_y(player.base(), Fix32(value), Fix32(time))
end


---@param player player 玩家
---@param area area 移动范围区域
---限制镜头移动范围
function camera.limit_in_rectangle_area(player, area)
    game_api.camera_limit_area(player.base(), area.base())
end


---@param player player 玩家
---关闭镜头限制移动
function camera.cancel_area_limit(player)
    game_api.camera_limit_area_close(player.base())
end


---@param player player 玩家
---@param state boolean 开关
---设置是否可以鼠标移动镜头
function camera.set_moving_with_mouse(player, state)
    game_api.set_mouse_move_camera_mode(player.base(), state)
end


---@param player player 玩家
---@param speed number 移动速度
---设置镜头移动速度（鼠标）
function camera.set_mouse_move_camera_speed(player, speed)
    game_api.set_mouse_move_camera_speed(player.base(), Fix32(speed))
end


---@param player player 玩家
---@param speed number 移动速度
---设置镜头移动速度（键盘）
function camera.set_keyboard_move_camera_speed(player, speed)
    game_api.set_key_move_camera_speed(player.base(), Fix32(speed))
end


---@param player player 玩家
---@return number 摄像机朝向
---获取玩家摄像机朝向
function camera.get_player_camera_direction(player)
    return game_api.get_player_camera_direction(player.base())
end



---@param player player 玩家
---@return point 摄像机中心射线的碰撞点
---获取玩家摄像机中心射线的碰撞点
function camera.get_camera_center_raycast(player)
    return game_api.get_camera_center_raycast(player.base())
end








