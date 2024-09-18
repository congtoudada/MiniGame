--- File Name : player.lua

--- Description: 


local setmetatable = setmetatable

---@class  player
local player = {}
player.__index = player
--y3.player = player

local Players = {}

---@param id integer 玩家ID
---@return player player 玩家
---转换玩家ID为玩家
function y3.player(id)
    if Players[id] == nil then
        local py_player = game_api.get_role_by_role_id(id)
        if py_player == nil then
            return
        end
        local py = py_obj.new(py_player)
        local new_player = {}
        new_player.base = py
        new_player.camp = py_player.api_get_camp()
        new_player.id = id
        setmetatable(new_player, player)
        Players[id] = new_player
    end
    return Players[id]
end

function y3.create_lua_player_from_py(py_player)
    local id = py_player:get_role_id_num()
    if Players[id] then 
        return Players[id]
    else
        return y3.player(id)
    end
end

function player:get_camp()
    return self.base():api_get_camp()
end

---@param name  string 存档key
---@return boolean bool_value 布尔型玩家存档数据
---布尔型玩家存档数据
function player:get_save_data_bool_value(name)
    return self.base():get_save_data_bool_value(name)
end

---@return boolean is_middle_join 是否中途加入
---玩家是否中途加入
function player:is_middle_join()
    return self.base():is_middle_join()
end

---@param player player 玩家
---@return boolean is_enemy 是否是敌对关系
---玩家间是否是敌对关系
function player:is_enemy(player)
    return self.base():players_is_enemy(player and player.base() or nil)
end

---@param name string 名字
---设置名字
function player:set_name(name)
    self.base():set_role_name(name)
end

---@param id integer 名字
---设置队伍ID
function player:set_team(id)
    self.base():api_set_camp(id)
end

---@param key string 属性名
---@param value number 值
---设置属性值
function player:set(key, value)
    self.base():set_role_res(key, Fix32(value))
end

---@param key string 属性名
---@param value number 值
---增加属性值
function player:add(key, value)
    self.base():change_role_res(key, Fix32(value))
end

---@param rate number 经验获得率
---设置经验获得率
function player:set_exp_rate(rate)
    self.base():set_role_exp_rate(Fix32(rate))
end
---@param player player 玩家
---@param is_hostile boolean 是否敌视
---设置敌对关系
function player:set_hostility(player, is_hostile)
    self.base():set_role_hostility(player and player.base() or nil, is_hostile)
end

---@param is_strict boolean 是否严格
---设置群体寻路严格模式
function player:set_strict_group_navigation(is_strict)
    self.base():set_group_navigate_mode(is_strict)
end

---@param unit unit 单位/单位组
---选中单位/单位组
function player:select_unit(unit)
    self.base():role_select_unit(unit and unit.base() or nil)
end

---@param distance number 距离
---设置跟随距离
function player:set_follow_distance(distance)
    self.base():api_set_follow_distance(Fix32(distance))
end

---@param is_enable boolean 是否开鼠标点选
---为玩家开/关鼠标点选
function player:set_mouse_click_selection(is_enable)
    self.base():set_role_mouse_left_click(is_enable)
end

---@param is_enable boolean 是否开鼠标框选
---为玩家开/关鼠标框选
function player:set_mouse_drag_selection(is_enable)
    self.base():set_role_mouse_move_select(is_enable)
end

---@param is_enable boolean 是否开鼠标滚轮
---为玩家开/关鼠标滚轮
function player:set_mouse_wheel(is_enable)
    self.base():set_role_mouse_wheel(is_enable)
end

---@param key integer 玩家
---@param assist_key integer 玩家
---@return boolean is_conf 是否被占用
---玩家基础操作快捷键是否被占用
--TODO:功能键lua层表示需要处理
function player:is_operation_key_occupied(key,assist_key)
    return self.base():api_is_conf_of_editable_game_func(key, assist_key)
end

---@param operation integer 可编辑操作
---@param key integer 功能按键
---@param assist_key integer 辅助按键
---设置玩家的基础操作快捷键（过滤掉禁止设置的） 
--TODO:operation在lua层的表示方式待整理 方法名英文待确认
function player:set_operation_key(operation, key, assist_key)
    self.base():api_set_role_editable_game_func(operation, key, assist_key)
end

---@param operation integer 可编辑操作
---@param is_enable boolean 是否开
---设置玩家的基础操作开关（包含所有基础操作）
--TODO:operation在lua层的表示方式待整理 方法名英文待确认
function player:set_all_operation_key(operation, is_enable)
    self.base():api_set_role_all_game_func_enable(operation, is_enable)
end

---@param key integer 键名
---@param assist_key integer 键盘按键
---@return string shortcut 基础操作
---获取玩家响应键盘按键的基础操作（过滤掉禁止设置的）
function player:get_operation_key(key, assist_key)
    return self.base():api_get_editable_game_func_of_shortcut(key, assist_key)
end

---@param tech_type integer 科技等级
---@param level integer 等级
---设置科技等级
function player:set_tech_level(tech_type, level)
    self.base():api_set_tech_level(tech_type, level)
end

---@param tech_type integer 科技等级
---@param level integer 等级
---增加科技等级
function player:add_tech_level(tech_type, level)
    self.base():api_change_tech_level(tech_type, level)
end

---@param target_player player 玩家
---对玩家开放视野
function player:open_view_with_player(target_player)
    self.base():share_source_player_vision_to_target(target_player and target_player.base() or nil)
end

---@param target_player player 玩家
---视野对玩家关闭
function player:close_view_with_player(target_player)
    self.base():close_source_player_vision_to_target(target_player and target_player.base() or nil)
end

---@param unit unit 单位
---单位对玩家视野关闭
function player:close_view_with_unit(unit)
    self.base():close_source_unit_vision_to_target(unit and unit.base() or nil)
end

---上传存档
function player:upload_save_data()
    self.base():upload_save_data()
end

---@param key integer 键
---@param value number 值
---增加全局存档
function player:add_global_save_data(key, value)
    self.base():add_global_map_archive_data(key, value)
end

---设置玩家存档
function player:save_data(key,value)
    if type(value) =="number" then
        if not string.find(string.format("%f", value), "%.") then
            self.base():set_save_data_fixed_value(key, Fix32(value))
        else
            self.base():set_save_data_int_value(key, value)
        end
    elseif type(value) == "string" then
        self.base():set_save_data_str_value(key, value)
    elseif type(value) == "boolean" then
        self.base():set_save_data_bool_value(key, value)
    elseif type(value) == "table" then
        self.base():set_save_data_table_value(key, value)
    end
end

---@param count integer 个数
---@param item_id integer 平台道具id
---消耗玩家平台道具
function player:use_store_item(count, item_id)
    self.base():api_use_store_item(count, item_id)
end

---@param point point 点
---@return boolean visible 点对于玩家可见
---点对于玩家可见
function player:is_visible(point)
    return self.base():is_point_visible_to_player(point and point.base() or nil)
end

---@param point point 点
---@return boolean is_point_in_fog 点在迷雾中
---点在迷雾中
function player:is_in_fog(point)
    return self.base():is_point_in_fog(point.base())
end

---@param point point 点
---@return boolean is_point_in_shadow 点在黑色阴影中
---点在黑色阴影中
function player:is_in_shadow(point)
    return self.base():is_point_in_shadow(point and point.base() or nil)
end


---@param key string 属性名
---@return number role_res 玩家属性
---获取玩家属性
function player:get_attr(key)
    return self.base():get_role_res(key):float()
end


---@return integer role_id_num 玩家ID
---获取玩家ID
function player:get_id()
    return self.base():get_role_id_num()
end


---@return string role_status 玩家游戏状态
---获取玩家游戏状态
function player:get_state()
    return self.base():get_role_status()
end

---@return string role_type 玩家控制者类型
---获取玩家控制者类型
function player:get_controller()
    return self.base():get_role_type()
end

---@return string role_name 玩家名字
---获取玩家名字
function player:get_name()
    return self.base():get_role_name()
end

---@return number exp_rate 经验获得率
---获取经验获得率
function player:get_exp_rate()
    return self.base():get_role_exp_rate():float()
end

---@return integer camp_id 队伍ID
---获取队伍ID
function player:get_team_id()
    return self.base():get_camp_id_num()
end

---@param key  string 存档key
---@return table table_value 表格型玩家存档数据
---表格型玩家存档数据
function player:get_save_data_table(key)
    return self.base():get_save_data_table_value(key)
end

---@param key  string 存档key
---字符串型玩家存档数据
---@return string str_value 字符串玩家存档数据
function player:get_save_data_string(key)
    return self.base():get_save_data_str_value(key)
end

---@param key string 存档key
---@return number int_value 实数型存档数据
---实数型存档数据
function player:get_save_data_float(key)
    return self.base():get_save_data_fixed_value(key)
end

---@param key string 存档key
---@return integer int_value 整数型存档数据
---获取整数型存档数据
function player:get_save_data_int(key)
    return self.base():get_save_data_int_value(key)
end

---@param save_slot integer 存档槽id
---@param key1 int or string 第一层索引
---@param key2 int or string 第二层索引
---@param key3 int or string 第三层索引
---获取表格型存档数据
function player:get_save_table_var(save_slot,key1, key2, key3,default_value, value_convert_func)
    return self.base():get_save_table_key_value(save_slot,key1, key2, key3, default_value, value_convert_func)
end

---@param save_slot integer 存档槽id
---@param key1 int or string 第一层索引
---@param value any 值
---@param key2 int or string 第二层索引
---@param key3 int or string 第三层索引
function player:set_save_table_kv(save_slot, key1, value, key2, key3, value_convert_func)
    if not value_convert_func then value_convert_func = '' end
    if not key2 then key2 = '' end
    if not key3 then key3 = '' end
    self.base():set_save_table_key_value(save_slot, key1, value, key2, key3, value_convert_func)
end

---@param save_slot integer 存档槽id
---@param key1 int or string 第一层索引
---@param value number 值
---@param key2 int or string 第二层索引
---@param key3 int or string 第三层索引
function player:add_save_table_kv(save_slot, key1, value, key2, key3)
    if not key2 then key2 = '' end
    if not key3 then key3 = '' end
    self.base():add_save_table_kv(save_slot, key1, value, key2, key3)
end


---@param key string 存档key
---@return integer rank_num 整数存档玩家排名
---获取整数存档玩家排名
function player:get_rank_num(key)
    return self.base():get_player_archive_rank_num(key)
end

---@param tech_id integer 科技id
---@return integer tech_level 科技等级
---获取科技等级
function player:get_tech_level(tech_id)
    return self.base():api_get_tech_level(tech_id)
end

---@return integer icon 平台头像
---获取玩家平台头像
function player:get_platform_icon()
    return game_api.get_role_platform_icon(self.base())
end

---@param id integer 平台道具id
---@return integer store_item_cnt 平台道具数量
---玩家平台道具数量
function player:get_store_item_number(id)
    return self.base():get_store_item_cnt(id)
end

---@return integer map_level 平台等级
---获取玩家地图等级
function player:get_map_level()
    return self.base():get_role_plat_map_level()
end

---@return boolean is_honor_vip 是否是会员
---获取玩家是否为平台荣耀会员
function player:is_honor_vip()
    return self.base():api_is_honor_vip()
end

---@return boolean is_author 是否是会员
---获取玩家是否为当前地图作者
function player:is_author()
    return self.base():api_is_cur_map_author()
end

---@return boolean deco_id 装饰id
---获取玩家装备的装饰类型的ID
function player:get_plat_deco(plat_deco_type)
    return self.base():api_get_equip_deco_id(plat_deco_type)
end

---@return integer played_times 累计局数
---获取玩家在该地图的累计局数
function player:get_played_times()
    return self.base():api_get_played_times()
end

---@return integer level_rank 等级排名（超过100则为0）
---获取玩家在该地图的等级排名
function player:get_map_level_rank()
    return self.base():api_get_map_level_rank()
end

---@return integer signin_days 签到天数 
---获取玩家在该地图的签到数据
function player:get_sign_in_data(signin_type)
    return self.base():api_get_sign_in_days_of_platform(signin_type)
end

---@return integer community_data 互动数据（布尔型数据1代表是，0代表否） 
---获取玩家在社区的互动数据
function player:get_community_data(community_type)
    return self.base():api_get_community_value(community_type)
end

---@param player_group player_group 玩家组
---@return boolean is_in_group 玩家在玩家组中
---玩家在玩家组中
function player:is_in_group(player_group)
    return global_api.judge_role_in_group(self.base(), player_group)
end


---@return unit_group unit_group 单位组
---属于某玩家的所有单位
function player:get_all_units()
    local py_unit_group = self.base():get_all_unit_id()
    return y3.unit_group.create_lua_unit_group_from_py(py_unit_group)
end


---@param unit_id number 单位类型
---@param point point 单位
---@param direction number 单位
---创建单位
function player:create_unit(unit_id, point, direction)
    game_api.create_unit(unit_id, point and point.base() or nil, direction, self.base())
end



---@param reason string 踢出原因
---强制踢出
function player:kick(reason)
    game_api.role_force_quit(self.base(), reason)
end

---@param key string 属性名
---@param id integer 图标id
---设置玩家属性图标
function y3.set_res_icon(key, id)
    game_api.change_role_res_icon_with_icon(key, id)
end

---@return integer model 模型id
---获取玩家平台外观模型
function player:get_platform_model()
    return game_api.get_role_platform_model(self.base())
end

---@return point point 点
---获取鼠标在游戏内的所在点
function player:get_mouse_pos()
    local py_point = game_api.get_player_pointing_pos(self.base())
    return y3.get_lua_point_from_py(py_point)
end

---@return number x_per X的占比
---获取玩家鼠标屏幕坐标X的占比
function player:get_mouse_ui_x_percent()
    return game_api.get_role_ui_x_per(self.base())
end

---@return number y_per Y的占比
---获取玩家鼠标屏幕坐标y的占比
function player:get_mouse_ui_y_percent()
    return game_api.get_role_ui_y_per(self.base())
end

---@return number pos_x X坐标
---获取鼠标在屏幕上的X坐标
function player:get_ui_pos_x()
    return game_api.get_player_ui_pos_x(self.base())
end

---@return number pos_y Y坐标
---获取鼠标在屏幕上的y坐标
function player:get_ui_pos_y()
    return game_api.get_player_ui_pos_y(self.base())
end

---@return string name 属性名称
---获取玩家唯一名称
function player:get_platform_name()
    return self.base():get_role__unique_name()
end

---@param key string 属性名
---@return integer icon 图标id
---获取玩家属性的货币图标
function y3.get_res_icon(key)
    return game_api.get_role_res_icon(key)
end

---@param key string 属性名
---@return string name 属性名称
---获取玩家属性名称
function y3.get_res_name(key)
    return game_api.get_role_res_name(key)
end

---@param unit player 玩家
---单位对玩家视野开放
function player:share_view_with_unit(unit)
    self.base():share_source_unit_vision_to_target(unit and unit.base() or nil)
end

---设置玩家小地图显示区域
function player:set_minimap_area(area)
    game_api.set_min_map_show_area(self.base(),area and area.base() or nil)
end

---@param type integer 指示器特效枚举
---@param key integer 特效key
---设置玩家的技能指示器特效
function player:set_skill_indicator(type,key)
    self.base():api_set_role_skill_indicator(type,key)
end

---@param CURSOR_STATE string 鼠标样式
---@param CURSOR_KEY string 鼠标类型
---设置玩家的鼠标样式
function player:api_set_role_cursor(CURSOR_STATE,CURSOR_KEY)
    self.base():api_set_role_cursor(CURSOR_STATE,CURSOR_KEY)
end

---@param channel integer 频道
---设置玩家发言频道
function player:set_voice_channel(channel)
    game_api.set_audio_chat_channel(self.base(),channel)
end

---@return  boolean is_return 是否回流
---玩家是否是回流玩家
function player:is_returning()
    return self.base():api_is_returning_player()
end

---@return  boolean is_mark 是否收藏
---玩家是否收藏当前地图
function player:is_mark()
    return self.base():api_is_bookmark_current_map()
end

---@return  boolean is_mark 是否收藏
---获取玩家鼠标真实x坐标
function player:get_mouse_x()
    return self.base():get_role_real_mouse_x()
end

---@return  boolean is_mark 是否收藏
---获取玩家鼠标真实y坐标
function player:get_mouse_y()
    return self.base():get_role_real_mouse_y()
end

---@param index integer 存档栏位
---@param value 值 鼠标类型
---增加整数型参数到玩家存档栏位
function player:add_save_data_int_value(index,value)
    self.base():add_save_data_int_value(index,value)
end

---@param index integer 存档栏位
---@param value 值 鼠标类型
---增加实数型参数到玩家存档栏位
function player:add_save_data_fixed_value(index,value)
    self.base():add_save_data_fixed_value(index,value)
end

---@param index integer 存档栏位
---@param value 值 鼠标类型
---乘量实数型参数到玩家存档栏位
function player:mult_save_data_value(index,value)
    self.base():mult_save_data_value(index,value)
end

---@return  string UUID 玩家UUID
---获取玩家UUID
function player:get_uuid()
    return self.base():get_encry_uuid(player.base())
end

---@return  integer points 玩家UUID
---获取玩家天梯的排位积分
function player:get_rank_points()
    return self.base():api_get_ladder_rank_points()
end

---@return  number money 累计充值
---获取玩家该地图累计充值
function player:get_role_total_consume()
    return self.base():api_get_role_total_consume()
end

---@return  boolean is_donated 是否打赏该地图
---获取玩家是否打赏该地图
function player:get_role_is_donated()
    return self.base():api_get_role_is_donated()
end

---@return  string color 颜色
---获取玩家颜色
function player:get_color()
    return self.base():api_get_role_color()
end