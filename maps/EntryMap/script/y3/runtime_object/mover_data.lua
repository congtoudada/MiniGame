local setmetatable = setmetatable
local unit = y3.unit.__index
local projectile = y3.projectile.__index

---构建直线运动器数据
---@param angle number 运动方向
---@param max_dist number 运动距离
---@param init_velocity number 初始速度
---@param acceleration number 加速度
---@param max_velocity number 最大速度
---@param min_velocity number 最小速度
---@param init_height number 初始高度
---@param fin_height number 终点高度
---@param parabola_height number 抛物线顶点高度
---@param collision_type number 碰撞类型
---@param collision_radius number 碰撞范围
---@param is_face_angle boolean 是否始终面向运动方向
---@param is_multi_collision boolean 能否重复碰撞同一单位
---@param terrain_block boolean 地形阻挡
---@param priority number 优先级
---@param is_absolute_height boolean 使用绝对高度
---@param unit_collide_interval number 碰撞同一单位间隔
---@param relate_unit_id boolean 关联单位
---@param relate_ability_seq boolean 关联技能
---@param terrain_collide_interval number 地形时间触发间隔
---@return mover_line_data 直线运动器数据
function y3.create_mover_line_data(
    angle, max_dist, init_velocity, acceleration,
    max_velocity, min_velocity, init_height, fin_height, parabola_height, collision_type, collision_radius, is_face_angle,
    is_multi_collision, terrain_block, priority, is_absolute_height, unit_collide_interval, relate_unit_id,
    relate_ability_seq, terrain_collide_interval
)
    local is_parabola_height = false
    local is_open_init_height = false
    local is_open_fin_height = false
    if parabola_height then is_parabola_height = true end
    if init_height then is_open_init_height = true end
    if fin_height then is_open_fin_height = true end

    local args = StraightMoverArgs()
    args.set_angle(Fix32(angle or 0))
    args.set_max_dist(Fix32(max_dist or 99999))
    args.set_init_velocity(Fix32(init_velocity or 0))
    args.set_acceleration(Fix32(acceleration or 0))
    args.set_max_velocity(Fix32(max_velocity or 99999))
    args.set_min_velocity(Fix32(min_velocity or 0))
    args.set_init_height(Fix32(init_height or 0))
    args.set_fin_height(Fix32(fin_height or 0))
    args.set_parabola_height(Fix32(parabola_height or 0))
    args.set_collision_type(collision_type or 0)
    args.set_collision_radius(Fix32(collision_radius or 0.0))
    args.set_is_face_angle(is_face_angle or false)
    args.set_is_multi_collision(is_multi_collision or false)
    args.set_terrain_block(terrain_block or false)
    args.set_priority(priority or 1)
    args.set_is_parabola_height(is_parabola_height or false)
    args.set_is_absolute_height(is_absolute_height or false)
    args.set_is_open_init_height(is_open_init_height or false)
    args.set_is_open_fin_height(is_open_fin_height or false)
    args.set_unit_collide_interval(unit_collide_interval or 0.0)
    args.set_relate_unit_id(relate_unit_id or 0)
    args.set_relate_ability_seq(relate_ability_seq or 0)
    args.set_terrain_collide_interval(terrain_collide_interval or 0.0)
    return args
end

local a = { '__class__', '__delattr__', '__dict__', '__doc__', '__format__', '__getattribute__', '__hash__', '__init__',
    '__module__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__',
    '__subclasshook__', '__weakref__', 'acceleration', 'bind_point', 'collision_radius', 'collision_type',
    'cur_base_height', 'cur_height', 'cur_max_rotate_angle', 'cur_parabola_height', 'cur_pos', 'cur_speed', 'dt_height',
    'enter_collide', 'extra_mover_collision_type', 'init_angle', 'init_height', 'init_max_rotate_angle',
    'init_max_rotate_angle_dt', 'init_velocity', 'is_absolute_height', 'is_auto_pitch', 'is_face_angle',
    'is_multi_collision', 'is_open_bind_point', 'is_open_init_angle', 'is_open_init_height', 'is_parabola_height',
    'is_target_entity', 'leave_collide', 'max_velocity', 'measure_dist', 'min_velocity', 'moved_progress',
    'mover_finish_func_num', 'mover_interrupt_func_num', 'mover_remove_func_num', 'next_pos', 'on_success',
    'on_terrain_collide', 'on_unit_collide', 'parabola_height', 'pass_time', 'pitch', 'priority', 'relate_ability_seq',
    'relate_ability_unit_id', 'relate_unit_id', 'remain_dist', 'rotate_time', 'speed', 'step', 'stop_distance_to_target',
    'target_unit_id', 'terrain_block', 'terrain_collide_func_num', 'terrain_collide_interval', 'to_title_string',
    'to_value_string', 'unit_collide_func_num', 'unit_collide_interval', 'yaw' }
---构建追踪运动器数据
---@param target unit|item|destructible|projectile 追踪目标
---@param stop_distance number 停止距离
---@param init_velocity number 初始速度
---@param acceleration number 加速度
---@param max_velocity number 最大速度
---@param min_velocity number 最小速度
---@param init_height number 初始高度
---@param bind_point string 追踪挂接点
---@param collision_type number 碰撞类型
---@param collision_radius number 碰撞范围
---@param is_face_angle boolean 是否始终面向运动方向
---@param is_multi_collision boolean 能否重复碰撞同一单位
---@param terrain_block boolean 地形阻挡
---@param priority number 优先级
---@param is_absolute_height boolean 使用绝对高度
---@param parabola_height number 抛物线顶点高度
---@param init_max_rotate_angle number 初始转向角速度
---@param init_angle number 初始角度
---@param pass_time number 过渡时间
---@param unit_collide_interval number 碰撞同一单位间隔
---@param relate_unit_id boolean 关联单位
---@param relate_ability_seq boolean 关联技能
---@param terrain_collide_interval number 地形时间触发间隔
---@return mover_target_data 追踪运动器数据
function y3.create_mover_target_data(
    target, stop_distance, init_velocity, acceleration,
    max_velocity, min_velocity, init_height, bind_point, collision_type, collision_radius, is_face_angle,
    is_multi_collision, terrain_block, priority, is_absolute_height, parabola_height, init_max_rotate_angle, init_angle,
    pass_time, unit_collide_interval, relate_unit_id, relate_ability_seq, terrain_collide_interval
)
    local is_parabola_height = false
    local is_open_init_height = false
    local is_open_bind_point = false
    if parabola_height then is_parabola_height = true end
    if init_height then is_open_init_height = true end
    if bind_point then is_open_bind_point = true end

    local args = ChasingMoverArgs()
    args.set_stop_distance_to_target(Fix32(stop_distance or 0.0))
    args.set_init_velocity(Fix32(init_velocity or 0))
    args.set_acceleration(Fix32(acceleration or 0))
    args.set_max_velocity(Fix32(max_velocity or 99999))
    args.set_min_velocity(Fix32(min_velocity or 0))
    args.set_init_height(Fix32(init_height or 0))
    args.set_bind_point(bind_point or '')
    args.set_collision_type(collision_type or 0)
    args.set_collision_radius(Fix32(collision_radius or 0.0))
    args.set_is_face_angle(is_face_angle or false)
    args.set_is_multi_collision(is_multi_collision or false)
    args.set_terrain_block(terrain_block or false)
    args.set_priority(priority or 1)
    args.set_is_absolute_height(is_absolute_height or false)
    args.set_is_open_init_height(is_open_init_height)
    args.set_is_parabola_height(is_parabola_height)
    args.set_parabola_height(Fix32(parabola_height or 0))
    args.set_is_open_bind_point(is_open_bind_point)
    args.set_target_unit_id(target.base().id)
    args.set_init_max_rotate_angle(init_max_rotate_angle or 0.0)
    args.set_init_angle(init_angle or 0.0)
    args.set_pass_time(pass_time or 0.0)
    args.set_unit_collide_interval(unit_collide_interval or 0.0)
    args.set_relate_unit_id(relate_unit_id or 0)
    args.set_relate_ability_seq(relate_ability_seq or 0)
    args.set_terrain_collide_interval(terrain_collide_interval or 0.0)

    print(args.target_unit_id)
    return args
end

---构建曲线运动器数据
---@param angle number 运动方向
---@param max_dist number 运动距离
---@param init_velocity number 初始速度
---@param acceleration number 加速度
---@param path table 平面路径表
---@param max_velocity number 最大速度
---@param min_velocity number 最小速度
---@param init_height number 初始高度
---@param fin_height number 终点高度
---@param collision_type number 碰撞类型
---@param collision_radius number 碰撞范围
---@param is_face_angle boolean 是否始终面向运动方向
---@param is_multi_collision boolean 能否重复碰撞同一单位
---@param terrain_block boolean 地形阻挡
---@param priority number 优先级
---@param is_absolute_height boolean 使用绝对高度
---@param parabola_height number 抛物线顶点高度
---@param unit_collide_interval number 碰撞同一单位间隔
---@param relate_unit_id boolean 关联单位
---@param relate_ability_seq boolean 关联技能
---@param terrain_collide_interval number 地形时间触发间隔
---@return mover_curve_data 曲线运动器数据
function y3.create_mover_curve_data(
    angle, max_dist, init_velocity, acceleration, path,
    max_velocity, min_velocity, init_height, fin_height, collision_type, collision_radius, is_face_angle,
    is_multi_collision, terrain_block, priority, is_absolute_height, parabola_height, unit_collide_interval,
    relate_unit_id, relate_ability_seq, terrain_collide_interval
)
    local is_open_init_height = false
    local is_open_fin_height = false
    if init_height then is_open_init_height = true end
    if fin_height then is_open_fin_height = true end

    local args = CurvedMoverArgs()
    args.set_angle(Fix32(angle or 0))
    args.set_max_dist(Fix32(max_dist or 99999))
    args.set_init_velocity(Fix32(init_velocity or 0))
    args.set_acceleration(Fix32(acceleration or 0))
    args.set_path(path)
    args.set_max_velocity(Fix32(max_velocity or 99999))
    args.set_min_velocity(Fix32(min_velocity or 0))
    args.set_init_height(Fix32(init_height or 0))
    args.set_fin_height(Fix32(fin_height or 0))
    args.set_collision_type(collision_type or 0)
    args.set_collision_radius(Fix32(collision_radius or 0.0))
    args.set_is_face_angle(is_face_angle or false)
    args.set_is_multi_collision(is_multi_collision or false)
    args.set_terrain_block(terrain_block or false)
    args.set_priority(priority or 1)
    args.set_is_absolute_height(is_absolute_height or false)
    args.set_is_open_init_height(is_open_init_height or false)
    args.set_unit_collide_interval(unit_collide_interval or 0.0)
    args.set_relate_unit_id(relate_unit_id or 0)
    args.set_relate_ability_seq(relate_ability_seq or 0)
    args.set_terrain_collide_interval(terrain_collide_interval or 0.0)
    args.set_parabola_height(Fix32(parabola_height or 0))
    return args
end

---构建环绕运动器数据
---@param target point|unit 环绕目标
---@param circle_radius number 圆周半径
---@param angle_velocity number 角速度
---@param init_angle number 初始角度
---@param counterclockwise number 方向
---@param round_time number 环绕时间
---@param centrifugal_velocity number 离心速度
---@param lifting_velocity number 提升速度
---@param around_init_height number 环绕高度
---@param collision_type number 碰撞类型
---@param collision_radius number 碰撞范围
---@param is_face_angle boolean 是否始终面向运动方向
---@param is_multi_collision boolean 能否重复碰撞同一单位
---@param terrain_block boolean 地形阻挡
---@param priority number 优先级
---@param is_absolute_height boolean 使用绝对高度
---@param unit_collide_interval number 碰撞同一单位间隔
---@param relate_unit_id boolean 关联单位
---@param relate_ability_seq boolean 关联技能
---@param terrain_collide_interval number 地形时间触发间隔
---@return mover_round_data 环绕运动器数据
function y3.create_mover_round_data(
    target, circle_radius, angle_velocity,
    init_angle, counterclockwise, round_time, centrifugal_velocity, lifting_velocity, around_init_height, collision_type,
    collision_radius, is_face_angle, is_multi_collision, terrain_block, priority, is_absolute_height,
    unit_collide_interval, relate_unit_id, relate_ability_seq, terrain_collide_interval
)
    local args = RoundMoverArgs()
    if target.type == 'unit' then
        args.set_is_to_unit(true)
        args.set_target_unit_id(target and target.base() or nil)
    else
        args.set_is_to_unit(false)
        args.set_target_pos(target and target.base() or nil)
    end
    args.set_circle_radius(Fix32(circle_radius or 0.0))
    args.set_angle_velocity(Fix32(angle_velocity or 0.0))
    args.set_init_angle(Fix32(init_angle or 0.0))
    args.set_counterclockwise(Fix32(counterclockwise))
    args.set_round_time(Fix32(round_time or 0))
    args.set_centrifugal_velocity(Fix32(centrifugal_velocity or 0))
    args.set_lifting_velocity(Fix32(lifting_velocity or 0))
    args.set_around_init_height(Fix32(around_init_height or 0))
    args.set_collision_type(collision_type or 0)
    args.set_collision_radius(Fix32(collision_radius or 0.0))
    args.set_is_face_angle(is_face_angle or false)
    args.set_is_multi_collision(is_multi_collision or false)
    args.set_terrain_block(terrain_block or false)
    args.set_priority(priority or 1)
    args.set_is_absolute_height(is_absolute_height or false)
    args.set_unit_collide_interval(unit_collide_interval or 0.0)
    args.set_relate_unit_id(relate_unit_id or 0)
    args.set_relate_ability_seq(relate_ability_seq or 0)
    args.set_terrain_collide_interval(terrain_collide_interval or 0.0)

    return args
end
