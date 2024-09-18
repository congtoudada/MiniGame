---@class ui
local ui = {}
ui.__index = ui
y3.ui = ui
ui.type = 'ui'

local UI = {}

---@param  py_ui string 
---@return table 返回在lua层初始化后的lua层技能实例
---通过py层的界面实例获取lua层的界面实例
function ui.get_lua_ui_from_py(player ,py_ui)
    if not py_ui then
        return
    end
    local py = py_obj.new(py_ui)
    if not UI[player.id] then UI[player.id] = {} end
    if not UI[player.id][py_ui] then
        local new_ui = {}
        setmetatable(new_ui, ui)
        new_ui.base = py
        new_ui.player = player
        UI[player.id][py_ui] = new_ui
    end
    return UI[player.id][py_ui]
end


---@param  player player 玩家
---@param  parent_ui string ui控件
---@param  comp_type integer ui控件
---@return table ui 返回在lua层初始化后的lua层技能实例
--创建界面控件
function ui.create_ui(player,parent_ui,comp_type)
    print(type(parent_ui))
    if type(parent_ui) == 'string' then
    else
        parent_ui = parent_ui.base()
    end
    local py_ui = game_api.create_ui_comp(player.base(),parent_ui,comp_type)
    return y3.ui.get_lua_ui_from_py(player ,py_ui)
end

---@param  player player 玩家
---@param  ui_path string ui对象路径，自画板一级开始，父节点与子节点使用“.”链接
function ui.get_ui(player,ui_path)
    local py_ui = game_api.get_comp_by_absolute_path(player.base(),ui_path)
    return y3.ui.get_lua_ui_from_py(player,py_ui)
end

---@param  event number 界面事件类型
---@param  str string 事件名
--创建界面事件
function ui:add_event(event,name)
    game_api.create_ui_comp_event_ex_ex(self.base(),event,name)
end

---@param  visible boolean 显示/隐藏
--设置UI控件显隐
function ui:set_visible(visible)
    game_api.set_ui_comp_visible(self.player.base(), visible, self.base())
end

--[[

game_api.set_ui_comp_opacity(game_api.get_role_by_role_id(1), "e35b1ffe-3472-443b-801a-96244184e296", Fix32(1.0))

]]

---@param  img integer 图片id
--设置图片
function ui:set_image(img)
    game_api.set_ui_comp_image_with_icon(self.player.base(), self.base(), img)
end


---@param  str string 文本
--设置文本
function ui:set_text(str)
    game_api.set_ui_comp_text(self.player.base(), self.base(), str)
end


---@param  value float 透明度
--设置控件透明度
function ui:set_alpha(value)
    game_api.set_ui_comp_opacity(self.player.base(), self.base(), Fix32(value))
end

--设置界面模型控件背景色
function ui:set_show_room_background_color(r,g,b,a)
    game_api.set_show_room_background_color(self.player.base(), self.base(), Fix32(r), Fix32(g), Fix32(b), Fix32(a))
end


---@param  isdrag boolean 是否可拖动
--设置控件是否可拖动
function ui:set_is_draggable(isdrag)
    game_api.set_ui_comp_drag(self.player.base(), self.base(), isdrag)
end


---@param  intercepts boolean 是否拦截操作
--设置控件是否拦截操作
function ui:set_intercepts_operations(intercepts)
    game_api.set_ui_comp_swallow(self.player.base(), self.base(), intercepts)
end


---@param  deep float 深度
--设置控件深度
function ui:set_z_order(deep)
    game_api.set_ui_comp_z_order(self.player.base(), self.base(), deep)
end


---@param  progress float 进度条最大值
--设置进度条最大值
function ui:set_max_progress_bar_value(progress)
    game_api.set_progress_bar_max_value(self.player.base(), self.base(), progress)
end


---@param  progress float 进度条当前值
---@param  time float 渐变时间
--设置进度条当前值
function ui:set_current_progress_bar_value(progress, time)
    game_api.set_progress_bar_current_value(self.player.base(), self.base(), progress, Fix32(time))
end


---@param  enable boolean 启用/禁用按钮
--启用/禁用按钮
function ui:set_button_enable(enable)
    game_api.set_ui_comp_enable(self.player.base(), self.base(), enable)
end


---@param  width float 宽度
---@param  height float 高度
--设置控件尺寸
function ui:set_ui_size(width, height)
    game_api.set_ui_comp_size(self.player.base(), self.base(), width, height)
end


---@param  size float 字体大小
--设置文本字体大小
function ui:set_font_size(size)
    game_api.set_ui_comp_font_size(self.player.base(), self.base(), size)
end

--让输入框获取焦点
function ui:set_input_field_focus()
    game_api.set_input_field_focus(self.player.base(), self.base())
end


---@param  skill ability 技能对象
--绑定技能对象到控件
function ui:set_skill_on_ui_comp(skill)
    game_api.set_skill_on_ui_comp(self.player.base(), skill.base(), self.base())
end


---@param  unit unit 单位
--绑定单位到魔法效果显示栏组件
function ui:set_buff_on_ui(unit)
    game_api.set_buff_on_ui_comp(self.player.base(), unit.base(), self.base())
end


---@param  item item 物品对象
-- 绑定物品对象到物品组件
function ui:set_item_on_ui(item)
    game_api.set_item_on_ui_comp(self.player.base(), item.base(), self.base())
end

---@param  player player 玩家
---@param  visible boolean 游戏界面的开关
--设置默认游戏界面的开关
function ui.set_prefab_ui_visible(player,visible)
    game_api.set_prefab_ui_visible(player.base(), visible)
end


---@param  modelid string 模型id
--设置模型控件的模型
function ui:set_ui_model_id(modelid)
    game_api.set_ui_model_id(self.player.base(), self.base(), modelid)
end



--改变小地图图片
---@param  player player 玩家
---@param  img integer 图片id
function ui.change_mini_map_img(player,img)
    game_api.change_mini_map_img_with_icon(player.base(), img)
end


---@param  unit unit 图片id
---@param  field integer 背包槽位类型名
---@param  index integer 格子位置
--设置物品组件绑定单位
function ui:set_ui_unit_slot(unit, field, index)
    game_api.set_ui_comp_unit_slot(self.player.base(), self.base(), unit.base(), field, index)
end


---@param  key integer 快捷键
--设置按钮快捷键
function ui:set_button_shortcut(key)
    game_api.set_btn_short_cut(self.player.base(), self.base(), key)
end
--

---@param  key number 辅助按键
--设置按钮组合快捷键
function ui:set_btn_meta_key(key)
    game_api.set_btn_func_short_cut(self.player.base(), self.base(), key)
end


---@param  key number 快捷键
--设置智能施法快捷键
function ui:set_skill_btn_smart_cast_key(key)
    game_api.set_skill_btn_smart_cast_key(self.player.base(), self.base(), key)
end


---@param  key number 辅助按键
--设置智能施法组合快捷键
function ui:set_skill_btn_func_meta_key(key)
    game_api.set_skill_btn_func_smart_cast_key(self.player.base(), self.base(), key)
end


---@param  isopen boolean 播放/停止技能按钮激活动效
--播放/停止技能按钮激活动效
function ui:set_skill_btn_action_effect(isopen)
    game_api.set_skill_btn_action_effect(self.player.base(), self.base(), isopen)
end


---@param  r float 红色
---@param  g float 红色
---@param  b float 红色
---@param  a float 红色
--设置文本颜色
function ui:set_text_color(r,g,b,a)
    game_api.set_ui_comp_font_color(self.player.base(), self.base(), Fix32(r), Fix32(g), Fix32(b), Fix32(a))
end


---@param  fov float 视野范围
--设置模型控件的镜头视野
function ui:change_showroom_fov(fov)
    game_api.change_showroom_fov(self.player.base(), self.base(), fov)
end


---@param  x float x轴
---@param  y float y轴
---@param  z float z轴
--设置模型控件的镜头坐标
function ui:change_showroom_cposition(x,y,z)
    game_api.change_showroom_cposition(self.player.base(), self.base(), Fix32(x), Fix32(y), Fix32(z))
end


---@param  x float x轴
---@param  y float y轴
---@param  z float z轴
--设置模型控件的镜头旋转
function ui:change_showroom_crotation(x,y,z)
    game_api.change_showroom_crotation(self.player.base(), self.base(), Fix32(x), Fix32(y), Fix32(z))
end


---@param  event number 界面事件类型
---@param  str string 事件名
--创建界面事件
function ui.create_ui_event(event,str)
    game_api.create_ui_comp_event_ex_ex(self.base(),event,str)
end

---@param  player player 玩家
---@param  msg string 消息
---@param  time float 持续时间
--系统消息提示
---@param  isSupportLanguage boolean 是否支持语言环境
function ui.display_system_information_message(player,msg,time,isSupportLanguage)
    game_api.show_tips_text(player.base(),msg,time,isSupportLanguage)
end

--设置界面模型控件背景色
function ui:set_show_room_background_color(r,g,b,a)
    game_api.set_show_room_background_color(self.player.base(), self.base(), Fix32(r), Fix32(g), Fix32(b), Fix32(a))
end

---@param  rot float 角度
--设置控件相对旋转
function ui:set_widget_relative_rotation(rot)
    game_api.set_ui_comp_rotation(self.player.base(),self.base(), Fix32(rot))
end


---@param  x float x轴
---@param  y float y轴
--设置控件绝对坐标
function ui:set_widget_absolute_coordinates(x,y)
    game_api.set_ui_comp_world_pos(self.player.base(),self.base(), Fix32(x), Fix32(y))
end


---@param  rot float 角度
--设置控件绝对旋转
function ui:set_widget_absolute_rotation(rot)
    game_api.set_ui_comp_world_rotation(self.player.base(),self.base(), Fix32(rot))
end


---@param  x float x轴
---@param  y float y轴
--设置控件绝对缩放
function ui:set_widget_absolute_scale(x,y)
    game_api.set_ui_comp_world_scale(self.player.base(),self.base(), Fix32(x), Fix32(y))
end


---@param  x float x轴
---@param  y float y轴
--设置控件相对缩放
function ui:set_widget_relative_scale(x,y)
    game_api.set_ui_comp_scale(self.player.base(),self.base(), Fix32(x), Fix32(y))
end



---@param  player player 玩家
---@param  type integer 小地图显示模式
--设置小地图显示模式
function ui.change_minimap_display_mode(player,type)
    game_api.change_mini_map_color_type(player.base(),type)
end


---@param  percent float 滑动条的进度
--设置滑动条的进度
function ui:set_slider_value(percent)
    game_api.set_slider_cur_percent(self.player.base(),self.base(), Fix32(percent))
end

--解绑控件
function ui:unbind_widget()
    game_api.unbind_ui_comp(self.player.base(),self.base())
end

--遍历某个界面控件的子节点
---@return  table boolean 遍历到的ui对象
function ui:get_ui_comp_children()
    local lua_table = {}
    local py_list = game_api.get_ui_comp_children(self.player.base(),self.base())
    for i = 0, python_len(py_list)-1 do
        local iter_ui = python_index(py_list,i)
        table.insert(lua_table,ui.get_lua_ui_from_py(self.player ,iter_ui))
    end
    return lua_table
end

---@param  player player 玩家
---@param  anim string 动画
---@param  speed float 播放速度
---@param  isloop boolean 是否循环
--播放时间轴动画
function ui.play_timeline_animation(player,anim,speed,isloop)
    game_api.play_ui_comp_anim(player.base(),anim,speed,isloop)
end


---@param  x float x轴
---@param  y float y轴
---@param  z float z轴
--设置模型控件观察点
function ui:set_ui_model_focus_pos(x,y,z)
    game_api.set_ui_model_focus_pos(self.player.base(),self.base(),Fix32(x), Fix32(y), Fix32(z))
end

---@param  uiAttr integer 界面控件属性
---@param  attr integer 单位属性
---@param  accuracy integer 小数精度
--绑定单位属性到玩家界面控件的属性
function ui:bind_unit_attribute_to_player_ui_widget_attribute(uiAttr,attr,accuracy)
    game_api.set_ui_comp_bind_attr(self.player.base(),self.base(),uiAttr,attr,accuracy)
end

---@param  uiAttr integer 界面控件属性
---@param  globalVar string 全局属性
---@param  accuracy integer 小数精度
--绑定全局变量到玩家界面控件的属性
function ui:bind_global_variable_to_player_ui_widget_attribute(uiAttr,globalVar,accuracy)
    game_api.set_ui_comp_bind_var(self.player.base(),self.base(),uiAttr,globalVar,accuracy)
end

---@param  uiAttr integer 界面控件属性
--解绑界面控件属性绑定
function ui:unbind_ui_widget_attribute(uiAttr)
    game_api.ui_comp_unbind(self.player.base,self.base(),uiAttr)
end

---@param  unit unit 单位
--界面控件属性绑定指定单位
function ui:ui_widget_attribute_bound_to_specified_unit(unit)
    game_api.ui_comp_bind_unit(self.player.base(),self.base(),unit.base())
end

---@param  img integer 图片id
--设置禁用图片(图片类型)
function ui:set_disable_image_type(img)
    game_api.set_ui_comp_disabled_image(self.player.base(),self.base(),img)
end

---@param  img integer 图片id
--设置悬浮图片(图片类型)
function ui:set_hover_image_type(img)
    game_api.set_ui_comp_suspend_image(self.player.base(),self.base(),img)
end

---@param  img integer 图片id
--设置按下图片(图片类型)
function ui:set_press_image_type(img)
    game_api.set_ui_comp_press_image(self.player.base(),self.base(),img)
end

---@param  uiAttr string 界面控件属性
---@param  playerAttr string 玩家属性
---@param  accuracy integer 小数精度
--绑定玩家属性到玩家界面控件的属性
function ui:bind_player_attribute_to_ui_widget_attribute(uiAttr,playerAttr,accuracy)
    game_api.set_ui_comp_bind_attr(self.player.base(),self.base(),uiAttr,playerAttr,accuracy)
end

---@param  type integer 对齐方式
--设置界面组件的对齐方式
function ui:set_alignment_type_for_ui_widget(type)
    game_api.set_ui_comp_align(self.player.base(),self.base(),type)
end

---@param  player player 玩家
---@param  unit unit 单位
--开启绘制单位路径线
function ui.enable_drawing_unit_path(player,unit)
    game_api.enable_unit_path_drawing(player.base(),unit.base())
end

---@param  player player 玩家
---@param  unit unit 单位
--关闭绘制单位路径线
function ui.disable_drawing_unit_path(player,unit)
    game_api.disable_unit_path_drawing(player.base(),unit.base())
end

--删除界面控件
function ui:remove_ui_comp()
    game_api.del_ui_comp(self.player.base(),self.base())
end


---@param  uiAttr string 界面控件属性
---@param  skill ability 技能
--绑定技能冷却时间到玩家界面控件的属性
function ui:set_ui_comp_bind_ability_cd(uiAttr,skill)
    game_api.set_ui_comp_bind_ability_cd(self.player.base(),self.base(),uiAttr,skill)
end

---@param  uiAttr string 界面控件属性
---@param  magicEffect modifier 魔法效果
--绑定魔法效果剩余时间到玩家界面控件的属性
function ui:set_ui_comp_bind_modifier_cd(uiAttr,magicEffect)
    game_api.set_ui_comp_bind_modifier_cd(self.player.base(),self.base(),uiAttr,magicEffect)
end

---@param  enable boolean 开启/禁用发送聊天功能
--开启/禁用发送聊天功能
function ui:set_chat_send_enabled(enable)
    game_api.set_chat_send_enabled(self.player.base(),self.base(),enable)
end

---@param  enable boolean 显示/隐藏聊天框
---@param  player player 目标玩家
--显示/隐藏聊天框
function ui:set_player_chat_show(player,enable)
    game_api.set_player_chat_show(self.player.base(),self.base(),player.base(),enable)
end

--清空聊天信息
function ui:clear_player_chat_panel()
    game_api.clear_player_chat_panel(self.player.base(),self.base())
end

---@param  player player 玩家
---@param  msg string 信息
--发送私聊信息
function ui:send_chat_to_role(player,msg)
    game_api.send_chat_to_role(self.player.base(),self.base(),player.base(),msg)
end


---@param  point point 点
---@param  harm_type integer 跳字类型
---@param  str string 文字
---@param  player_group player_group 玩家组
---@param  jump_word_track integer 跳字轨迹
--创建悬浮文字
function ui.create_floating_text(point,harm_type,str,player_group,jump_word_track)
    game_api.create_harm_text_ex(point.base(),harm_type,str,player_group.base(),jump_word_track or 0)
end

---@param  player player 玩家
---@param  window_mode integer 窗口类型
--设置窗口
function ui.set_window_mode(player,window_mode)
    game_api.set_window_type(player.base(),window_mode)
end

---@param  player player 玩家
---@param  quality integer 画质
--设置画质
function ui.set_graphics_quality(player,quality)
    game_api.set_image_quality(player.base(),quality)
end

---@param  player player 玩家
---@param  x float x轴
---@param  y float y轴
--屏幕分辨率
function ui.set_screen_resolution(player,x,y)
    game_api.set_screen_resolution(player.base(),Fix32(x),Fix32(y))
end


---@return float x x相对坐标
--获取本地控件相对坐标的X
function ui:get_widget_relative_x_coordinate()
    return game_api.get_ui_comp_pos_x(self.base())
end

---@return float y y坐标
--获取本地控件相对坐标的Y
function ui:get_widget_relative_y_coordinate()
    return game_api.get_ui_comp_pos_y(self.base())
end

---@return float x x绝对坐标
--获取本地控件绝对坐标的X
function ui:get_widget_absolute_x_coordinate()
    return game_api.get_ui_comp_world_pos_x(self.base())
end

---@return float y y绝对坐标
--获取本地控件绝对坐标的Y
function ui:get_widget_absolute_y_coordinate()
    return game_api.get_ui_comp_world_pos_y(self.base())
end

---@return float rot 相对旋转
--获取本地控件相对旋转
function ui:get_widget_relative_rotation()
    return game_api.get_ui_comp_rotation(self.base())
end

---@return float rot 绝对旋转
--获取本地控件绝对旋转
function ui:get_widget_absolute_rotation()
    return game_api.get_ui_comp_world_rotation(self.base())
end

---@return float x x相对缩放
--获取本地控件相对缩放的X
function ui:get_widget_relative_scale_x_coordinate()
    return game_api.get_ui_comp_scale_x(self.base())
end

---@return float y y绝对缩放
--获取本地控件相对缩放的Y
function ui:get_widget_relative_scale_y_coordinate()
    return game_api.get_ui_comp_scale_y(self.base())
end

---@return float x x绝对缩放
--获取本地控件绝对缩放的X
function ui:get_widget_absolute_scale_x_coordinate()
    return game_api.get_ui_comp_world_scale_x(self.base())
end

---@return float y y绝对缩放
--获取本地控件绝对缩放的Y
function ui:get_widget_absolute_scale_y_coordinate()
    return game_api.get_ui_comp_world_scale_y(self.base())
end


---@return string str 字符串
--界面控件转化为字符串
function ui:convert_ui_widget_to_string()
    return global_api.comp_to_str(self.base())
end

---@return float slider_value 滑动条当前值
--获取滑动条当前值
function ui:get_slider_current_value()
    return game_api.get_slider_cur_percent(self.base())
end
-- --当前遍历到的界面控件
-- ---@return table
-- function ui:currently_picked_ui_widget(ui)
--     return game_api.get_ui_comp_children(game_api.get_role_by_role_id(1), "76364f96-ce50-49c3-8468-c61e4b2c7e0a")
-- end
--[[

]]

---@return string  uiname 控件名
--获得界面控件名
function ui:get_ui_widget_name()
    return game_api.get_ui_comp_name(self.player.base(),self.base())
end

---@return ui ui_comp ui控件 
--获取指定命名的子控件
function ui:get_child_widget_of_specified_name(name)
    return game_api.get_comp_by_path(self.player.base(),self.base(),name)
end

---@return float width 控件宽度
--获得控件宽度
function ui:get_widget_width()
    return game_api.get_ui_comp_width(self.base())
end

---@return float height 控件高度
--获得控件高度
function ui:get_widget_height()
    return game_api.get_ui_comp_height(self.base())
end

---@return number horizontal_res 横向分辨率
--获取屏幕横向分辨率
function ui.get_screen_horizontal_resolution()
    return game_api.get_screen_x_resolution()
end

---@return number vertical_res 纵向分辨率
--获取屏幕纵向分辨率
function ui.get_screen_vertical_resolution()
    return game_api.get_screen_y_resolution()
end

---@return ui ui_comp ui控件
--获得界面控件的父控件
function ui:get_parent_widget_of_ui_widget()
    return game_api.get_ui_comp_parent(self.player.base(),self.base())
end


---@return string msg 文本内容
--获得玩家输入框文本内容
function ui:get_input_field_content()
    return game_api.get_input_field_content(self.player.base(),self.base())
end

---@return boolean ui_visible 控件可见性
--获得控件可见性
function ui:get_ui_comp_visible()
    return game_api.get_ui_comp_visible(self.player.base(),self.base())
end

---@param  x float x轴
---@param  y float y轴
---设置ui坐标
function ui:set_pos(x,y)
    game_api.set_ui_comp_pos_no_trans(self.player.base(),self.base(),Fix32(x),Fix32(y))
end

---@param  x float x轴
---@param  y float y轴
---设置界面控件的锚点
function ui:set_ui_anchor(x,y)
    game_api.set_ui_comp_anchor(self.player.base(),self.base(),x,y)
end

---@param  switch boolean 九宫开关
---开关九宫
function ui:set_ui_comp_scale_9_enable(switch)
    game_api.set_ui_scale_9_enable(self.player.base(),self.base(),switch)
end

---@param  x float x轴
---@param  y float y轴
---@param  width float 长
---@param  height float 高
---设置九宫参数
function ui:set_ui_comp_cap_insets(x,y,width,height)
    game_api.set_ui_cap_insets(self.player.base(),self.base(),x,y,width,height)
end

---@param  switch boolean 开关
---设置聊天频道
function ui:set_nearby_micro_switch(switch)
    game_api.set_ui_comp_chat_channel(self.player.base(),self.base(),switch)
end

---@param  anim boolean 循环开关
---@param  speed number 播放速度
---@param  start_time number 开始时间
---@param  end_time number 结束时间
---@param  is_loop boolean 循环开关
---@param  is_back_normal boolean 是否回到原始动作
---播放模型控件动画
function ui:play_model_anim(anim,speed,start_time,end_time,is_loop,is_back_normal)
    game_api.play_ui_model_anim(self.player.base(),self.base(),anim,speed,start_time,end_time,is_loop,is_back_normal)
end

---@param  sequence sequence 序列帧
---设置序列帧
function ui:set_ui_seq(sequence)
    game_api.set_ui_comp_sequence(self.player.base(),self.base(),sequence)
end

---@param  is_loop boolean 循环开关
---@param  play_break number 播放间隔
---@param  start_fps integer 开始帧
---@param  end_fps integer 结束帧
---播放序列帧
function ui:play_ui_seq(is_loop,play_break,start_fps,end_fps)
    game_api.play_ui_comp_sequence(self.player.base(),self.base(),is_loop,play_break,start_fps,end_fps)
end

---停止序列帧
function ui:stop_ui_seq()
    game_api.stop_ui_comp_sequence(self.player.base(),self.base())
end

---@param  start_x number 开始x
---@param  start_y number 开始y
---@param  end_x number 结束x
---@param  end_y number 结束y
---@param  duration number 持续时间
---@param  ease_type integer 曲线类型
---设置动画移动
function ui:set_ui_anim_pos(start_x, start_y, end_x, end_y, duration, ease_type)
    game_api.set_ui_comp_anim_pos(self.player.base(),self.base(),start_x, start_y, end_x, end_y, duration, ease_type or 0)
end
---@param  start_alpha number 开始alpha
---@param  end_alpha number 结束alpha
---@param  duration number 持续时间
---@param  ease_type integer 曲线类型
---设置动画透明度
function ui:set_ui_anim_opacity(start_alpha, end_alpha, duration, ease_type)
    game_api.set_ui_comp_anim_opacity(self.player.base(),self.base(), start_alpha, end_alpha, duration, ease_type or 0)
end

---@param  start_x number 开始x
---@param  start_y number 开始y
---@param  end_x number 结束x
---@param  end_y number 结束y
---@param  duration number 持续时间
---@param  ease_type integer 曲线类型
---设置动画缩放
function ui:set_ui_anim_scale(start_x, start_y, end_x, end_y, duration, ease_type)
    game_api.set_ui_comp_anim_scale(self.player.base(),self.base(),start_x, start_y, end_x, end_y, duration, ease_type or 0)
end

---@param  start_rotation number 开始旋转
---@param  end_rotation number 结束旋转
---@param  duration number 持续时间
---@param  ease_type integer 曲线类型
---设置动画旋转
function ui:set_ui_anim_rotate(start_rotation, end_rotation, duration, ease_type)
    game_api.set_ui_comp_anim_rotate(self.player.base(),self.base(), start_rotation, end_rotation, duration, ease_type or 0)
end

---@param  percent number 百分比
---设置列表滚动到百分比位置
function ui:set_list_view_per(percent)
    game_api.set_list_view_percent(self.player.base(),self.base(), percent)
end

---@param  fx_id integer 控件动效工程id
---@param  ani_name string 动效名
---@param  loop boolean 循环
---播放ui动效
function ui:play_ui_fx(fx_id, ani_name, loop)
    game_api.play_ui_comp_fx(self.player.base(),self.base(),fx_id, ani_name, loop)
end

---@param  format string 公式
---设置ui控件绑定公式
function ui:bind_format(format)
    game_api.set_ui_comp_bind_format(self.player.base(),self.base(),format)
end

---@param  direction integer 方向
---@param  value number 距离
---设置控件相对父级位置
function ui:set_adapt_option(direction, value)
    game_api.set_ui_comp_adapt_option(self.player.base(),self.base(),direction, value)
end

---@param  name string 事件名
---使玩家触发界面事件
function ui:trigger_ui_event(name)
    game_api.trigger_ui_event(self.player.base(),self.base(),name)
end

---@param  is_follow boolean 是否跟随
---设置控件是否跟随鼠标
function ui:set_follow(is_follow,offset_x, offset_y)
    game_api.set_ui_comp_follow_mouse(self.player.base(),self.base(),is_follow,offset_x, offset_y)
end

---@param  camera_mod integer 镜头模式
---设置模型控件的镜头模式
function ui:set_model_comp_camera_mod(camera_mod)
    game_api.set_model_comp_camera_mod(self.player.base(),self.base(),camera_mod)
end

---@param  btn_status integer 按钮状态
---@param  btn_text string 文本
---设置不同状态下的按钮文本
function ui:set_ui_btn_status_string(btn_status, btn_text)
    game_api.set_ui_btn_status_string(btn_status, btn_text)
end

---@param  btn_status integer 按钮状态
---@param  btn_image integer 图片
---设置不同状态下的按钮文本
function ui:set_ui_btn_status_image(btn_status, btn_image)
    game_api.set_ui_btn_status_image(btn_status, btn_image)
end

---@param  scrollview_type integer 布局方式
---设置列表控件的布局方式
function ui:set_ui_scrollview_type(scrollview_type)
    game_api.set_ui_scrollview_type(scrollview_type)
end

---@param  flag boolean 是否跟随子控件变化
---设置列表控件的尺寸是否跟随子控件变化
function ui:set_scroll_change_by_children(flag)
    game_api.set_ui_scrollview_size_change_according_children(flag)
end

---@param  r number 红色
---@param  g number 绿色
---@param  b number 蓝色
---@param  a number 透明度
---设置图片颜色
function ui:set_img_color(r, g, b, a)
    game_api.set_ui_image_color(r, g, b, a)
end

---@return number width  长度
---获取控件的真实长度
function ui:get_real_width()
    return game_api.get_role_ui_comp_real_width()
end

---@return number width  长度
---获取控件的真高度
function ui:get_real_height()
    return game_api.get_role_ui_comp_real_height()
end
