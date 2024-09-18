RoleResKey = {}

ToString ={
    [100000] = function (value)
        return global_api.float_to_str(value)
    end,
    [100001] = function (value)
        return global_api.bool_to_str(value)
    end,
    [100002] = function (value)
        return global_api.int64_to_str(value)
    end,
    [100003] = function (value)
        return value
    end,
    [100004] = function (value)
        return global_api.vector3_to_str(value.base())
    end,
    [100210] = function (value)
        return global_api.unit_command_type_to_str(value)
    end,
    [100219] = function (value)
        return global_api.ability_cast_type_to_str(value)
    end,
    [100191] = function (value)
        return game_api.link_sfx_key_to_str(value)
    end,
    [100150] = function (value)
        return global_api.poly_area_to_str(value.base())
    end,
    [100203] = function (value)
        return global_api.projectile_group_to_str(value)
    end,
    [1000204] = function (value)
        return global_api.role_relation_to_str(value)
    end,
    [100038] = function (value)
        return global_api.unit_key_pool_to_str(value)
    end,
    [100010] = function (value)
        return global_api.unit_type_to_str(value)
    end,
    [100181] = function (value)
        return global_api.timer_to_str(value.base())
    end,
    [100006] = function (value)
        return global_api.unit_to_str(value.base())
    end,
    [100026] = function (value)
        return global_api.unit_group_to_str(value)
    end,
    [100116] = function (value)
        return game_api.unit_key_to_str(value)
    end,
    [100042] = function (value)
        return game_api.unit_attr_to_str(value)
    end,
    [100031] = function (value)
        return global_api.item_to_str(value.base())
    end,
    [100171] = function (value)
        return global_api.item_group_to_str(value)
    end,
    [100032] = function (value)
        return game_api.item_key_to_str(value)
    end,
    [100025] = function (value)
        return global_api.role_to_str(value and value.base() or nil)
    end,
    [100027] = function (value)
        return global_api.role_group_to_str(value)
    end,
    [100037] = function (value)
        return game_api.role_res_to_str(value)
    end,
    [100180] = function (value)
        return global_api.role_status_to_str(value)
    end,
    [100179] = function (value)
        return global_api.role_type_to_str(value)
    end,
    [100014] = function (value)
        return global_api.ability_to_str(value.base())
    end,
    [100039] = function (value)
        return game_api.ability_key_to_str(value)
    end,
    [100182] = function (value)
        return global_api.ability_type_to_str(value)
    end,
    [100009] = function (value)
        return global_api.rect_area_to_str(value.base())
    end,
    [100023] = function (value)
        return global_api.circle_area_to_str(value.base())
    end,
    [100024] = function (value)
        return global_api.road_to_str(value.base())
    end,
    [100205] = function (value)
        return global_api.dest_to_str(value.base())
    end,
    [100207] = function (value)
        return game_api.dest_key_to_str(value)
    end,
    [100077] = function (value)
        return global_api.project_to_str(value.base())
    end,
    [100062] = function (value)
        return game_api.project_key_to_str(value)
    end,
    [100148] = function (value)
        return game_api.sfx_to_str(value)
    end,
    [100066] = function (value)
        return game_api.particle_sfx_key_to_str(value)
    end,
    [100172] = function (value)
        return game_api.tech_key_to_str(value)
    end,
    [100202] = function (value)
        return game_api.link_sfx_to_str(value)
    end,
    [100147] = function (value)
        return game_api.model_entity_to_str(value)
    end,
    [100122] = function (value)
        return game_api.model_key_to_str(value)
    end,
    [100076] = function (value)
        return global_api.modifier_entity_to_str(value.base())
    end,
    [100186] = function (value)
        return global_api.modifier_type_to_str(value)
    end,
    [100174] = function (value)
        return global_api.modifier_effect_type_to_str(value)
    end,
    [100046] = function (value)
        return game_api.modifier_key_to_str(value)
    end,
    [100020] = function (value)
        return global_api.camp_to_str(value)
    end,
    [100201] = function (value)
        return global_api.random_pool_to_str(value)
    end,
    [200220] = function (value)
        return global_api.keyboard_key_to_str(value)
    end,
    [200221] = function (value)
        return global_api.mouse_key_to_str(value)
    end,
    [100134] = function (value)
        return game_api.store_key_to_str(value)
    end,
    [100178] = function (value)
        return global_api.trigger_to_str(value)
    end,
    [100073] = function (value)
        return game_api.camera_to_str(value)
    end,
    [100011] = function (value)
        return global_api.table_to_str(value)
    end,
    [100064] = function (value)
        return global_api.damage_type_to_str(value)
    end,
    [100300] = function (value)
        return global_api.unit_attr_type_to_str(value)
    end,
    [100214] = function (value)
        return game_api.sound_entity_to_str(value)
    end,
    [100070] = function (value)
        return game_api.ui_comp_to_str(value)
    end,
    [100084] = function (value)
        return game_api.audio_key_to_str(value)
    end,
    [200222] = function (value)
        return global_api.mouse_wheel_to_str(value)
    end,
    [100263] = function (value)
        return global_api.mover_entity_to_str(value)
    end,
}

AbilityTypeId = {
    [0] = 'Hide', [1] = 'Normal', [2] = 'Common', [3] = 'Hero'
}

AbilityCastType = {
    ['Normal'] = 1,
    ['Active'] = 2,
    ['Passive'] = 3,
    ['Build'] = 4,
    ['Gather'] = 5,
}

AbilityCastTypeId = {
    'Normal', 'Active', 'Passive', 'Build', 'Gather'
}

KvType = {
    ['real'] = 'float',
    ['str'] = 'string',
    ['int'] = 'integer',
    ['string'] = 'string',
    ['integer'] = 'integer',
    ['bool'] = 'boolean',
    ['boolean'] = 'boolean',
    ['ui'] = 'ui_comp',
    ['unit'] = 'unit_entity',
    ['unitName'] = 'unit_name',
    ['unitType'] = 'unit_name',
    ['unitGroup'] = 'unit_group',
    ['item'] = 'item_entity',
    ['itemName'] = 'item_name',
    ['itemType'] = 'item_name',
    ['abilityType'] = 'ability_type',
    ['abilityCast'] = 'ability_cast_type',
    ['abilityName'] = 'ability_name',
    ['model'] = 'model',
    ['tech'] = 'tech_key',
    ['buff'] = 'modifier',
}

---data的枚举类,包含所有data字段
DATA_ENUM={
    ['name'] = "__name",
['area'] = "__area",
['unit'] = "__unit",
['unit2'] = "__unit2",
['other_unit'] = "__other_unit",
['src_unit'] = "__source_unit",
['target_unit'] = "__target_unit",
['click_unit'] = "__click_unit",
['owner_unit'] = "__owner_unit",
['unit_for_dest'] = "__unit_for_dest",
['day_vision'] = "vision_rng",
['night_vision'] = "vision_night",
['unit_id'] = "__unit_id",
['unit_key'] = "unit_key",
['build_unit_id'] = "__build_unit_id",
['high_light_unit_id'] = "__high_light_unit_id",
['unit_group_id_list'] = "__unit_group_id_list",
['unit_stuff_id'] = "__unit_stuff_id",
['shop_unit_id'] = "__shop_unit_id",
['from_unit_id'] = "__from_unit_id",
['mover_unit_id'] = "__mover_unit_id",
['collide_unit_id'] = "__collide_unit_id",
['trigger_id'] = "__trigger_id",
['area_id'] = "__area_id",
['role_id'] = "__role_id",
['src_role_id'] = "__src_role_id",
['dst_role_id'] = "__dst_role_id",
['role_res_key'] = "__role_res_key",
['unit_tag'] = "__unit_tag",
['item'] = "__item",
['target_item'] = "__target_item",
['item_id'] = "__item_id",
['item_no'] = "__item_no",
['item_stuff_id'] = "__item_stuff_id",
['item_unit_id'] = "__item_unit_id",
['tab_idx'] = "__tab_idx",
['compose_id'] = "__compose_id",
['owner'] = "__owner",
['relation'] = "__relation",
['container'] = "__container",
['store_key'] = "__store_key",
['shop_key'] = "__shop_key",
['shop_item_iter'] = "shop_item_iter",
['modifier'] = "__modifier",
['modifier_id'] = "__modifier_id",
['old_modifier'] = "__old_modifier",
['new_modifier'] = "__new_modifier",
['modifier_iter'] = "modifier_iter",
['destructible'] = "__destructible",
['destructible_id'] = "__destructible_id",
['destructible_iter'] = "destructible_iter",
['unit_id_of_dest_killer'] = "__unit_id_of_dest_killer",
['unit_id_in_dest_event'] = "__unit_id_in_dest_event",
['res_chg_cnt_in_dest_event'] = "__res_chg_cnt_in_dest_event",
['ability_in_dest_event'] = "__ability_in_dest_event",
['item_id_in_dest_event'] = "__item_id_in_dest_event",
['role_res_cnt_in_event'] = "__role_res_cnt_in_event",
['unit_id_of_hurt_dest'] = "__unit_id_of_hurt_dest",
['damage_value_of_hurt_dest'] = "__damage_value_of_hurt_dest",
['ability'] = "__ability",
['ability_id'] = "__ability_id",
['ability_index'] = "__ability_index",
['ability_type'] = "__ability_type",
['ability_seq'] = "__ability_seq",
['ability_iter'] = "ability_iter",
['ability_runtime_id'] = "__ability_runtime_id",
['skill_pointer_type'] = "__skill_pointer_type",
['attr'] = "__attr",
['attr_key'] = "__attr_key",
['add_exp'] = "__add_exp",
['activation_code_group'] = "__activation_code_group",
['cmd_type'] = "__cmd_type",
['cnt'] = "__cnt",
['use_cnt'] = "__use_cnt",
['curr_lv'] = "__curr_lv",
['curr_stock'] = "__curr_stock",
['damage'] = "__damage",
['damage_type'] = "__damage_type",
['cured_value'] = "__cured_value",
['is_critical_hit'] = "__is_critical_hit",
['is_normal_hit'] = "__is_normal_hit",
['damage_result_state'] = "__damage_result_state",
['delta'] = "__delta",
['delta_lv'] = "__delta_lv",
['delta_cnt'] = "__delta_cnt",
['left'] = "__left",
['layer_change_values'] = "__layer_change_values",
['msg'] = "__msg",
['res_key'] = "__res_key",
['res_value'] = "__res_value",
['res_type'] = "__res_type",
['res_cost'] = "__res_cost",
['stack'] = "__stack",
['tech_no'] = "__tech_no",
['tech_iter'] = "__tech_iter",
['total'] = "__total",
['icon_id'] = "__icon_id",
['is_middle_join'] = "__is_middle_join",
['is_forbidden'] = "__is_forbidden",
['is_silent'] = "__is_silent",
['comp_name'] = "__comp_name",
['event_name'] = "__event_name",
['ui_event_name'] = "__ui_event_name",
['touch_id'] = 'touch_id',
['curr_key'] = '__current_key',
['team_id'] = '__team_id',
['pos'] = '__pos',
['tar_x'] = '__tar_x',
['tar_y'] = '__tar_y',
['point'] = '__point',
['int1'] = '__int1',
['float1'] = '__float1',
['bool1'] = '__bool1',
['str1'] = '__str1',
['args'] = '__args',
['c_param_1'] = '__c_param_1',
['c_param_2'] = '__c_param_2',
['c_param_3'] = '__c_param_3',
['c_param_4'] = '__c_param_4',
['c_param_5'] = '__c_param_5',
['c_param_dict'] = '__c_param_dict',
['pointing_world_pos'] = '__pointing_world_pos',
['mouse_wheel'] = '__mouse_wheel',
['cur_dynamic_trigger_ins'] = '__cur_dyna_trigger_ins',
['is_day_to_night'] = '__is_day_to_night',
['random_pool_iter'] = 'random_pool_iter',
['iter_int'] = '__iter_int',
['iter_index'] = '__iter_index',
['iter_road'] = 'iter_road',
['poly_area_iter'] = 'poly_area_iter',
['trigger_owner'] = 'trigger_owner',
['cur_ability'] = '__cur_ability',
['cur_unit'] = '__cur_unit',
['cur_item'] = '__cur_item',
['cur_modifier'] = '__cur_modifier',
['cur_projectile'] = '__cur_projectile',
['iter_table_item'] = '__ITER_TABLE_ITEM',
['jump_word_type'] = '__jump_word_type',
['forbid_critical_hit'] = '__forbid_critical_hit',
['ui_comp_iter'] = 'ui_comp_iter',
['ui_vx_handler'] = '__ui_vx_handler',
['ui_prefab_id'] = '__ui_prefab',
['ui_prefab_ins'] = '__ui_prefab_ins',
['const_arg'] = '__const_arg',
['time'] = '__time',
['element_id'] = '__element_id',
['eca_key'] = 'eca_key',
['arg_type'] = 'arg_type',
['sub_type'] = 'sub_type',
['break'] = 'BREAK',
['return'] = 'RETURN',
['trigger_type'] = 'trigger_type',
['group_id'] = 'group_id',
['func_trigger_id'] = 'func_trigger_id',
['is_func'] = 'is_func',
}