--- File Name : math.lua

--- Description:

-- 使用角度制的三角函数
local deg = math.deg(1)
local rad = math.rad(1)

---获取随机角度
function y3.get_random_angle()
    return game_api.get_random_angle()
end

---@param point_1 point 点1
---@param point_2 point 点2
---获取点与点的角度
function y3.get_points_angle(point_1, point_2)
    return game_api.get_points_angle(point_1.base(), point_2.base())
end

---@param in_radius number 内半径
---@param out_radius number 外半径
---创建环形区域
function y3.create_annular_shape(in_radius, out_radius)
    return global_api.create_annular_shape(Fix32(in_radius), Fix32(out_radius))
end

---@param radius number 半径
---创建圆形区域
function y3.create_circular_shape(radius)
    return global_api.create_circular_shape(Fix32(radius))
end

---@param width number 宽度
---@param length number 长度
---@param angle number 角度
---创建矩形区域
function y3.create_rectangle_shape(width, length, angle)
    return global_api.create_rectangle_shape(Fix32(width), Fix32(length), Fix32(angle))
end

---@param radius number 半径
---@param angle number 角度
---@param direction number 方向
---扇形
function y3.create_sector_shape(radius, angle, direction)
    return global_api.create_sector_shape(Fix32(radius), Fix32(angle), Fix32(direction))
end

---@param value integer 整数
---转换整数为实数
function y3.int_to_float(value)
    return game_api.int32_to_fixed(value)
end

---@param value string 字符串
---@return number float 实数
---转换字符串为实数
function y3.string_to_float(value)
    return game_api.str_to_fixed(value)
end

---@param min number 范围内最小实数
---@param max number 范围内最大实数
---@return number float 随机实数
---范围内随机实数
function y3.random_float_with_min_and_max(min, max)
    return game_api.get_random_fixed(Fix32(min), Fix32(max))
end

---@param point_1 point 点1
---@param point_2 point 点2
---@return number dis 距离
---计算两点间距离
function y3.get_two_points_distance(point_1, point_2)
    return game_api.get_points_dis(point_1.base(), point_2.base())
end

---@param value number 实数
---@return number float 实数
---实数加1
function y3.float_plus_one(value)
    return value +1
end

---@param value number 实数
---@return number float 实数
---正弦
function y3.sin(value)
    return math.sin(value * rad)
end

---@param value number 实数
---@return number float 实数
---余弦
function y3.cos(value)
    return math.cos(value * rad)
end

---@param value number 实数
---@return number float 实数
---正切
function y3.tan(value)
    return math.tan(value * rad)
end

---@param value number 实数
---@return number float 实数
---反正弦
function y3.asin(value)
    return math.asin(value * deg)
end

---@param value number 实数
---@return number float 实数
---反余弦
function y3.acos(value)
    return math.acos(value * deg)
end

---@param value number 实数
---@return number float 实数
---反正切
function y3.atan(value)
    return math.atan(value * deg)
end

---@param value number 实数
---@return number float 实数
---平方根
function y3.sqrt(value)
    return math.sqrt(value)
end

---@param value number 实数
---@param count integer 次数 
---@return number float 实数
---求幂
function y3.pow(value, count)
    return value ^ count
end

---@param value number 实数
---@return number float 实数
---求绝对值
function y3.abs(value)
    return math.abs(value)
end

---@param value number 实数
---@return number float 实数
---基于10的对数
function y3.log10(value)
    return math.log(value, 10)
end

---@param value number 实数
---@param base number 实数
---@return number float 实数
---value基于base的对数
function y3.log(value, base)
    return math.log(value, base)
end

---@param value number 实数
---@param position integer 位置
---@param is_round boolean 是否四舍五入
---@return number float 实数
---保留X位小数后结果
function y3.round_dec(value, position, is_round)
    local round = 0
    if is_round then
        round = 0.5
    end
    local rounded_num = math.floor(value * 10 ^ position+round) / 10 ^ position
    local num = string.format("%." .. position .. "f", rounded_num)
    return tonumber(num)
end

---@param one number 实数
---@param two number 实数
---@return number float 实数
---取实数与实数较小值
function y3.get_minor_between_two_float(one, two)
    return math.min(one, two)
end

---@param one number 实数
---@param two number 实数
---@return number float 实数较大值
---取实数与实数较大值
function y3.get_bigger_between_two_float(one, two)
    return math.max(one, two)
end

---@param value number 实数
---@return integer int 整数
---转换浮点数为整数
function y3.float_to_int(value)
    return math.floor(value)
end

---@param value string 字符串
---@return integer int 整数
---字符串转整数
function y3.string_to_int(value)
    return math.floor(tonumber(value))
end

---@param min integer 整数
---@param max integer 整数
---@return integer int 整数
---范围内随机整数
function y3.get_random_int(min, max)
    return math.random(min, max)
end

---@param one integer 整数
---@param two integer 整数
---@return integer int 整数
---取整数与整数较小值
function y3.get_minor_between_two_int(one, two)
    return math.min(one, two)
end

---@param one integer 整数
---@param two integer 整数
---@return integer int 整数
---取整数与整数较大值
function y3.get_bigger_between_two_int(one, two)
    return math.max(one, two)
end

---@param value integer 整数
---@return integer int 整数
---整数增加1
function y3.int_plus_one(value)
    return value + 1
end

---@param num1 number 整数1
---@param num2 number 整数2
---@return number value 开方结果
---开方
function y3.root(num1,num2)
    return global_api.root(num1,num2)
end
