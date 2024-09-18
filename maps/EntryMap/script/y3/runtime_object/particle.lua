--- File Name : particle.lua

--- Description: 


local setmetatable = setmetatable

---@class  particle
local particle = {}
particle.__index = particle
y3.particle = particle

function y3.create_lua_particle_by_py(py_particle)
    local new = {}
    local py = py_obj.new(py_particle)
    -- local id = py.base.api_get_id()
    setmetatable(new, particle)  
    new.base = py
    -- new.id = id  
    return new
end


---@param sfx_id number 特效id
---@param duration number 持续时间
---@param player player 玩家
---@param is_on_fog boolean 是否在迷雾上方
---创建屏幕特效
function particle.screen_particle(data)
    if data.target then
        data.target = data.target.base()
    else
        data.target = nil
    end
    local py_particle = game_api.add_sfx_to_camera_with_return(data.type, data.time, data.target, data.is_on_fog,data.immediate,data.immediate)
    return y3.create_lua_particle_by_py(py_particle)
end


---@param sfx_id integer 特效类型id
---@param point point 点
---@param direction number 方向
---@param scale number 缩放
---@param height number 高度
---@param duration number 持续时间
---@return particle particle 特效
--创建到点

function particle.create(data)
    if not data.angle then data.angle = 0 end
    if not data.scale then data.scale = 1 end
    if not data.height then data.height = 0 end
    if not data.time then data.time = -1 end
    if data.immediate == nil then data.immediate = false end
    if data.target.type == 'unit' then
        local py_particle = game_api.create_sfx_on_unit_new(
            data.type,
            data.target.base(),
            data.socket or 'origin',
            data.follow_rotation or 0,
            data.follow_scale or false,
            Fix32(data.scale),
            Fix32(data.time),
            Fix32(data.angle),
            data.immediate,
            data.immediate)
        return y3.create_lua_particle_by_py(py_particle)
    else
        local py_particle = game_api.create_sfx_on_point(
            data.type,
            data.target.base(),
            Fix32(data.angle),
            Fix32(data.scale), 
            Fix32(data.height), 
            Fix32(data.time),
            data.immediate,
            data.immediate)
        return y3.create_lua_particle_by_py(py_particle)
    end
end


--删除
function particle:remove()
    game_api.delete_sfx(self.base(),true)
end




---@param x number X轴角度
---@param y number Y轴角度
---@param z number Z轴角度
--设置旋转角度
function particle:set_rotate(x,y,z)
    game_api.set_sfx_rotate(self.base(), Fix32(x), Fix32(y), Fix32(z))
end


---@param direction number 方向
--设置朝向
function particle:set_facing(direction)
    game_api.set_sfx_angle(self.base(), direction)
end


---@param x number X轴缩放
---@param y number Y轴缩放
---@param z number Z轴缩放
--设置缩放比例
function particle:set_scale(x,y,z)
    game_api.set_sfx_scale(self.base(), x,y,z)
end


---@param height number 高度
--设置高度
function particle:set_height(height)
    game_api.set_sfx_height(self.base(), height)
end


---@param point point 点
--设置坐标
function particle:set_point(point)
    game_api.set_sfx_position(self.base(), point.base())
end


---@param speed number 速度
--设置动画速度
function particle:set_animation_speed(speed)
    game_api.set_sfx_animation_speed(self.base(), speed)
end


---@param duration number 持续时间
--设置持续时间
function particle:set_time(duration)
    game_api.set_sfx_duration(self.base(), duration)
end

---@param red integer 红色
---@param green integer 绿色
---@param blue integer 蓝色
---@param alpha integer 透明度
---设置颜色
function particle:set_color(red,green,blue,alpha)
    game_api.set_sfx_color(Fix32(red),Fix32(green),Fix32(blue),Fix32(alpha))
end
