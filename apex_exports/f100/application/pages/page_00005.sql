prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
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
 p_id=>5
,p_name=>'Participants'
,p_alias=>'PARTICIPANTS'
,p_step_title=>'Participants'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(5047649867551123)
,p_plug_name=>'Add Participant'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(5048951484551136)
,p_name=>'Participants'
,p_template=>4072358936313175081
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    participant_id,',
'    first_name,',
'    last_name,',
'    birth_date,',
'    relation_to_client',
'FROM participants',
'WHERE reservation_id = :P5_RESERVATION_ID',
'ORDER BY participant_id;',
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
 p_id=>wwv_flow_imp.id(5049039328551137)
,p_query_column_id=>1
,p_column_alias=>'PARTICIPANT_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Participant Id'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(5049117891551138)
,p_query_column_id=>2
,p_column_alias=>'FIRST_NAME'
,p_column_display_sequence=>20
,p_column_heading=>'First Name'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(5049240737551139)
,p_query_column_id=>3
,p_column_alias=>'LAST_NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Last Name'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(5049374017551140)
,p_query_column_id=>4
,p_column_alias=>'BIRTH_DATE'
,p_column_display_sequence=>40
,p_column_heading=>'Birth Date'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(5049449064551141)
,p_query_column_id=>5
,p_column_alias=>'RELATION_TO_CLIENT'
,p_column_display_sequence=>50
,p_column_heading=>'Relation To Client'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(5648684834756365)
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
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(5050124341551148)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(5048951484551136)
,p_button_name=>'GO_TO_PAGE_6'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Continue -> Transport & Hotel'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'RIGHT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(5048466140551131)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(5047649867551123)
,p_button_name=>'ADD_PARTICIPANT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Add Participant'
,p_show_processing=>'Y'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(5050275250551149)
,p_branch_name=>'Go to Page 6'
,p_branch_action=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_COMPUTATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(5050124341551148)
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(5047554468551122)
,p_name=>'P5_RESERVATION_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(5047649867551123)
,p_use_cache_before_default=>'NO'
,p_source=>'P5_RESERVATION_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(5047747039551124)
,p_name=>'P5_FIRST_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(5047649867551123)
,p_use_cache_before_default=>'NO'
,p_prompt=>'First Name'
,p_source=>'P5_FIRST_NAME'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(5048009389551127)
,p_name=>'P5_LAST_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(5047649867551123)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Last Name'
,p_source=>'P5_LAST_NAME'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(5048166423551128)
,p_name=>'P5_BIRTH_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(5047649867551123)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Birth Date'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(5048244384551129)
,p_name=>'P5_RELATION'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(5047649867551123)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Relation to Client'
,p_source=>'P5_RELATION'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:SELF;Self,SPOUSE;Spouse,CHILD;Child,FRIEND;Friend,OTHER;Other'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(5048843632551135)
,p_validation_name=>'Birth date must be in the past'
,p_validation_sequence=>10
,p_validation=>':P5_BIRTH_DATE <= SYSDATE'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Birth date must not be in the future.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(5048592345551132)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add Participant Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'travel_agency_operations.add_participant(',
'    p_reservation_id => :P5_RESERVATION_ID,',
'    p_first_name     => :P5_FIRST_NAME,',
'    p_last_name      => :P5_LAST_NAME,',
'    p_birth_date     => :P5_BIRTH_DATE,',
'    p_relation       => :P5_RELATION',
');',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(5048466140551131)
,p_internal_uid=>5048592345551132
);
wwv_flow_imp.component_end;
end;
/
