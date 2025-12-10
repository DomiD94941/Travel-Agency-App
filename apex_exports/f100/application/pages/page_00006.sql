prompt --application/pages/page_00006
begin
--   Manifest
--     PAGE: 00006
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
 p_id=>6
,p_name=>'Transport'
,p_alias=>'TRANSPORT'
,p_step_title=>'Transport'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9041854927814840)
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
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(9043134373817705)
,p_name=>'Available Transport'
,p_template=>4072358936313175081
,p_display_sequence=>60
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    transport_mode,',
'    transport_id,',
'    city_start,',
'    city_target,',
'    depart_time,',
'    col1 AS extra_info,',
'    col4 AS price,',
'    status',
'FROM vw_transport_options',
'WHERE city_start = :P6_CITY_START',
'  AND city_target = :P6_CITY_TARGET',
'  AND depart_time BETWEEN :P6_DATE_FROM AND :P6_DATE_TO',
'ORDER BY depart_time',
''))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9043267825817706)
,p_query_column_id=>1
,p_column_alias=>'TRANSPORT_MODE'
,p_column_display_sequence=>10
,p_column_heading=>'Transport Mode'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9043382088817707)
,p_query_column_id=>2
,p_column_alias=>'TRANSPORT_ID'
,p_column_display_sequence=>20
,p_column_heading=>'Transport Id'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9043462122817708)
,p_query_column_id=>3
,p_column_alias=>'CITY_START'
,p_column_display_sequence=>30
,p_column_heading=>'City Start'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9043534060817709)
,p_query_column_id=>4
,p_column_alias=>'CITY_TARGET'
,p_column_display_sequence=>40
,p_column_heading=>'City Target'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9043639920817710)
,p_query_column_id=>5
,p_column_alias=>'DEPART_TIME'
,p_column_display_sequence=>50
,p_column_heading=>'Depart Time'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9043718499817711)
,p_query_column_id=>6
,p_column_alias=>'EXTRA_INFO'
,p_column_display_sequence=>60
,p_column_heading=>'Extra Info'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9043866966817712)
,p_query_column_id=>7
,p_column_alias=>'PRICE'
,p_column_display_sequence=>70
,p_column_heading=>'Price'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(9043908305817713)
,p_query_column_id=>8
,p_column_alias=>'STATUS'
,p_column_display_sequence=>80
,p_column_heading=>'Status'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9044117375817715)
,p_button_sequence=>70
,p_button_name=>'BTN_ASSIGN_TRANSPORT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Assign Transport'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(9044371668817717)
,p_branch_name=>'Go to Page 7'
,p_branch_action=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.::P7_TRANSPORT_RES_ID,P7_RESERVATION_ID:&P6_TRANSPORT_RES_ID.,&P6_RESERVATION_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(5050320966551150)
,p_name=>'P6_RESERVATION_ID'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9042732686817701)
,p_name=>'P6_CITY_START'
,p_item_sequence=>20
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9042840339817702)
,p_name=>'P6_CITY_TARGET'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9042926266817703)
,p_name=>'P6_DATE_FROM'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9043020501817704)
,p_name=>'P6_DATE_TO'
,p_item_sequence=>50
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9044062903817714)
,p_name=>'P6_SELECTED_TRANSPORT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9043134373817705)
,p_prompt=>'Choose Transport Option'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    v.transport_mode',
'    || '' | '' || TO_CHAR(v.depart_time, ''YYYY-MM-DD HH24:MI'')',
unistr('    || '' | '' || v.col4 || '' \20AC'' AS display_value,'),
'    v.transport_mode AS return_value',
'FROM vw_transport_options v',
'WHERE v.city_start  = :P6_CITY_START',
'  AND v.city_target = :P6_CITY_TARGET',
'  AND v.depart_time BETWEEN :P6_DATE_FROM AND :P6_DATE_TO',
'  AND v.status = ''ACTIVE''',
'ORDER BY v.depart_time',
'',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9044297175817716)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Assign Transport'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF :P6_SELECTED_TRANSPORT IS NOT NULL THEN',
'        travel_agency_operations.set_transport_pref(',
'            p_reservation_id => :P6_RESERVATION_ID,',
'            p_preference     => :P6_SELECTED_TRANSPORT',
'        );',
'    ELSE',
'        travel_agency_operations.set_transport_pref(',
'            p_reservation_id => :P6_RESERVATION_ID,',
'            p_preference     => NULL',
'        );',
'    END IF;',
'',
'    travel_agency_operations.assign_transport(:P6_RESERVATION_ID);',
'END;',
'',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(9044117375817715)
,p_internal_uid=>9044297175817716
);
wwv_flow_imp.component_end;
end;
/
