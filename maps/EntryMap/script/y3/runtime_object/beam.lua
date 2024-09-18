--- File Name : beam.lua

--- Description: 


local setmetatable = setmetatable

---@class  beam
local beam = {} --setmetatable({}, { __mode = 'kv' })
beam.__index = beam
y3.beam = beam

function beam.create_lua_beam_by_py(py_beam)
    local new = {}
    local py = py_obj.new(py_beam)
    -- local id = py.base.api_get_id()
    setmetatable(new, beam)
    new.base = py
    -- new.id = id
    return new
end


---@class beam_data
---@field type integer 特效id
---@field source unit/point 目标
---@field target unit/point 目标
---@field time number 存在时间
---@field source_height number 高度（只在目标是点时生效）
---@field target_height number 高度（只在目标是点时生效）
---@field source_socket string 挂接点（只在目标是单位时生效）
---@field target_socket string 挂接点（只在目标是单位时生效）
---@field immediate boolean 销毁时，是否有过度

---@param data beam_data
beam.create = function(data)
    local lightning 
    --判断到底是哪种创建方式
    if not data.source_height then
        data.source_height = 0
    end
    if not data.target_height then
        data.target_height = 0
    end
    if not data.time then
        data.time = -1
    end
    if not data.immediate then
        data.immediate = true
    end
    if data.source.type == 'unit' and data.target.type == 'point' then
        lightning = game_api.create_link_sfx_from_unit_to_point(data.type,data.source.base(),data.source_socket,data.target.base(),Fix32(data.target_height),Fix32(data.time),data.immediate)
    elseif data.source.type == 'unit' and data.target.type == 'unit' then
        lightning = game_api.create_link_sfx_from_unit_to_unit(data.type,data.source.base(),data.source_socket,data.target.base(),data.target_socket,Fix32(data.time),data.immediate)
    elseif data.source.type == 'point' and data.target.type == 'unit' then
        lightning = game_api.create_link_sfx_from_point_to_unit(data.type,data.source.base(),Fix32(data.source_height),data.target.base(),data.target_socket,Fix32(data.time),data.immediate)
    elseif data.source.type == 'point' and data.target.type == 'point' then
        lightning = game_api.create_link_sfx_from_point_to_point(data.type,data.source.base(),Fix32(data.source_height),data.target.base(),Fix32(data.target_height),Fix32(data.time),data.immediate)
    else
        print('不符合要求的闪电特效创建')
    end

    lightning = beam.create_lua_beam_by_py(lightning)
    return lightning
end


---链接特效 - 销毁
function beam:remove()
    game_api.remove_link_sfx(self.base())
    self = nil
end


---@param is_show boolean 是否显示
---链接特效 - 显示/隐藏
function beam:show(is_show)
    game_api.enable_link_sfx_show(self.base(), is_show)
end

---@class beam_target_data
---@field point_type integer 起点or终点
---@field target unit/point 目标
---@field height number 高度（只在目标是点时生效）
---@field socket string 挂接点（只在目标是单位时生效）

---@param data beam_target_data
---链接特效 - 设置位置
function beam:set(data)
    if data.target.type == 'point' then
        if not data.height then
            data.height = 0
        end
        game_api.set_link_sfx_point(self.base(),data.point_type,data.target.base(),Fix32(data.height))
    end
    if data.target.type == 'unit' then
        game_api.set_link_sfx_unit_socket(self.base(),data.point_type,data.target.base(),data.socket)
    end
end
