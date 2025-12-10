prompt --application/plugin_settings
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.10'
,p_default_workspace_id=>2356212381289404
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'TA_APP'
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(4242295525122814)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_DISPLAY_SELECTOR'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'include_slider', 'Y')).to_clob
,p_version_scn=>12077398
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(4242571601122815)
,p_plugin_type=>'DYNAMIC ACTION'
,p_plugin=>'NATIVE_OPEN_AI_ASSISTANT'
,p_version_scn=>12077398
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(4242852154122816)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_DATE_PICKER_APEX'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'appearance_behavior', 'MONTH-PICKER:YEAR-PICKER:TODAY-BUTTON',
  'days_outside_month', 'VISIBLE',
  'show_on', 'FOCUS',
  'time_increment', '15')).to_clob
,p_version_scn=>12077398
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(4243188017122816)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_GEOCODED_ADDRESS'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'background', 'default',
  'display_as', 'LIST',
  'map_preview', 'POPUP:ITEM',
  'match_mode', 'RELAX_HOUSE_NUMBER',
  'show_coordinates', 'N')).to_clob
,p_version_scn=>12077398
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(4243480957122816)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_MAP_REGION'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_vector_tile_layers', 'Y')).to_clob
,p_version_scn=>12077398
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(4243758210122816)
,p_plugin_type=>'WEB SOURCE TYPE'
,p_plugin=>'NATIVE_BOSS'
,p_version_scn=>12077398
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(4244070101122817)
,p_plugin_type=>'WEB SOURCE TYPE'
,p_plugin=>'NATIVE_ADFBC'
,p_version_scn=>12077398
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(4244326835122817)
,p_plugin_type=>'PROCESS TYPE'
,p_plugin=>'NATIVE_GEOCODING'
,p_attribute_01=>'RELAX_HOUSE_NUMBER'
,p_version_scn=>12077398
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(4244615938122817)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_SINGLE_CHECKBOX'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'checked_value', 'Y',
  'unchecked_value', 'N')).to_clob
,p_version_scn=>12077398
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(4244985290122817)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_IR'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'actions_menu_structure', 'IG')).to_clob
,p_version_scn=>12077398
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(4245217975122818)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_SELECT_MANY'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_values_as', 'separated')).to_clob
,p_version_scn=>12077398
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(4245524325122818)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_COLOR_PICKER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'mode', 'FULL')).to_clob
,p_version_scn=>12077398
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(4245857001122818)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_STAR_RATING'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'default_icon', 'fa-star',
  'tooltip', '#VALUE#')).to_clob
,p_version_scn=>12077398
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(4246150032122818)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_YES_NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_style', 'SWITCH_CB',
  'off_value', 'N',
  'on_value', 'Y')).to_clob
,p_version_scn=>12077398
);
wwv_flow_imp.component_end;
end;
/
