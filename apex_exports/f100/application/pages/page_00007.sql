prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.10'
,p_default_workspace_id=>2356212381289404
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'TA_APP'
);
wwv_flow_imp_page.create_page(
 p_id=>7
,p_name=>'Assign Seats & Options'
,p_alias=>'ASSIGN-SEATS-OPTIONS'
,p_step_title=>'Assign Seats & Options'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9442779530945601)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(4247097479122823)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9443461349945614)
,p_plug_name=>'Assign Seats & Options'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    td.detail_id,',
'    p.participant_id,',
'    p.first_name || '' '' || p.last_name AS participant_name,',
'    td.seat_no,',
'    td.section,',
'    pt.preferred_class,',
'    pt.preferred_meal,',
'    pt.preferred_cabin,',
'    pt.preferred_service',
'FROM participants p',
'LEFT JOIN transport_details td',
'       ON td.participant_id = p.participant_id',
'      AND td.transport_res_id = :P7_TRANSPORT_RES_ID',
'LEFT JOIN participant_transport_prefs pt',
'       ON pt.participant_id = p.participant_id',
'WHERE p.reservation_id = :P7_RESERVATION_ID',
'ORDER BY p.participant_id;'))
,p_plug_source_type=>'NATIVE_IG'
,p_prn_page_header=>'Assign Seats & Options'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(9444762770945628)
,p_name=>'DETAIL_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DETAIL_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>10
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(9445762930945632)
,p_name=>'PARTICIPANT_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PARTICIPANT_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>20
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(9446743589945633)
,p_name=>'PARTICIPANT_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PARTICIPANT_NAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Participant Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>30
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(9447707350945635)
,p_name=>'SEAT_NO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SEAT_NO'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Seat No'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
,p_max_length=>10
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(9448734026945636)
,p_name=>'SECTION'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SECTION'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Section'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'WITH t AS (',
'    SELECT transport_type, flight_id, train_id, coach_id ',
'    FROM transport_reservations ',
'    WHERE transport_res_id = :P7_TRANSPORT_RES_ID',
')',
'SELECT label, value FROM (',
'    -- FLIGHT',
'    SELECT ''ECONOMY'' label, ''ECONOMY'' value',
'      FROM transport_flights f, t',
'     WHERE t.transport_type = ''FLIGHT''',
'       AND f.flight_id = t.flight_id',
'       AND f.seats_econ_free > 0',
'    UNION ALL',
'    SELECT ''BUSINESS'',''BUSINESS''',
'      FROM transport_flights f, t',
'     WHERE t.transport_type = ''FLIGHT''',
'       AND f.flight_id = t.flight_id',
'       AND f.seats_bus_free > 0',
'    UNION ALL',
'    SELECT ''VIP'',''VIP''',
'      FROM transport_flights f, t',
'     WHERE t.transport_type = ''FLIGHT''',
'       AND f.flight_id = t.flight_id',
'       AND f.seats_vip_free > 0',
'',
'    UNION ALL',
'',
'    -- TRAIN',
'    SELECT ''STANDARD'',''STANDARD''',
'      FROM transport_trains tr, t',
'     WHERE t.transport_type = ''TRAIN''',
'       AND tr.train_id = t.train_id',
'       AND tr.seats_standard_free > 0',
'    UNION ALL',
'    SELECT ''QUIET'',''QUIET''',
'      FROM transport_trains tr, t',
'     WHERE t.transport_type = ''TRAIN''',
'       AND tr.train_id = t.train_id',
'       AND tr.seats_quiet_free > 0',
'    UNION ALL',
'    SELECT ''VIP'',''VIP''',
'      FROM transport_trains tr, t',
'     WHERE t.transport_type = ''TRAIN''',
'       AND tr.train_id = t.train_id',
'       AND tr.seats_vip_free > 0',
'',
'    UNION ALL',
'',
'    -- COACH',
'    SELECT ''STANDARD'',''STANDARD''',
'      FROM transport_coaches c, t',
'     WHERE t.transport_type = ''COACH''',
'       AND c.coach_id = t.coach_id',
'       AND c.seats_free > 0',
')',
''))
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(9449668966945637)
,p_name=>'PREFERRED_CLASS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PREFERRED_CLASS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Preferred Class'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(9450633340945638)
,p_name=>'PREFERRED_MEAL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PREFERRED_MEAL'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Preferred Meal'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'STATIC'
,p_lov_source=>'STATIC:Vegetarian;VEG,Standard;STD,KIds;KIDS,Halal;HAL,Kosher;KOS'
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_display_condition_type=>'EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT 1 FROM transport_reservations ',
'WHERE transport_res_id = :P7_TRANSPORT_RES_ID',
'  AND transport_type = ''FLIGHT''',
''))
,p_display_condition2=>'PLSQL'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(9451635764945639)
,p_name=>'PREFERRED_CABIN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PREFERRED_CABIN'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Preferred Cabin'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(9452692432945640)
,p_name=>'PREFERRED_SERVICE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PREFERRED_SERVICE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Preferred Service'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'send_on_page_submit', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>50
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(9443974906945615)
,p_internal_uid=>9443974906945615
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(9444311366945617)
,p_interactive_grid_id=>wwv_flow_imp.id(9443974906945615)
,p_static_id=>'94444'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(9444528725945618)
,p_report_id=>wwv_flow_imp.id(9444311366945617)
,p_view_type=>'GRID'
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(9445115722945630)
,p_view_id=>wwv_flow_imp.id(9444528725945618)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(9444762770945628)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(9446154935945632)
,p_view_id=>wwv_flow_imp.id(9444528725945618)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(9445762930945632)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(9447158391945633)
,p_view_id=>wwv_flow_imp.id(9444528725945618)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(9446743589945633)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(9448181346945635)
,p_view_id=>wwv_flow_imp.id(9444528725945618)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(9447707350945635)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(9449078616945636)
,p_view_id=>wwv_flow_imp.id(9444528725945618)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(9448734026945636)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(9450013579945637)
,p_view_id=>wwv_flow_imp.id(9444528725945618)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(9449668966945637)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(9451094743945638)
,p_view_id=>wwv_flow_imp.id(9444528725945618)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(9450633340945638)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(9452078846945639)
,p_view_id=>wwv_flow_imp.id(9444528725945618)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(9451635764945639)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(9453033718945640)
,p_view_id=>wwv_flow_imp.id(9444528725945618)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(9452692432945640)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp.component_end;
end;
/
