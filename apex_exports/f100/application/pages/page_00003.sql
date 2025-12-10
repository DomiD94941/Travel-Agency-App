prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
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
 p_id=>3
,p_name=>'Trip Package Details'
,p_alias=>'TRIP-PACKAGE-DETAILS'
,p_step_title=>'Trip Package Details'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Report-pagination,',
'.a-IRR-pagination {',
'    display: none !important;',
'}',
'',
'/* Styl nowoczesnych kart */',
'.t-Region {',
'    border-radius: 12px !important;',
'    box-shadow: 0 2px 10px rgba(0,0,0,0.08) !important;',
'    padding: 10px !important;',
'}',
'',
unistr('/* Nag\0142\00F3wki region\00F3w */'),
'.t-Region-title {',
'    font-size: 18px !important;',
'    font-weight: 600 !important;',
'    color: #1a1a1a !important;',
'}',
'',
unistr('/* D\0142u\017Csze odst\0119py mi\0119dzy regionami */'),
'.t-Region + .t-Region {',
'    margin-top: 25px !important;',
'}',
'',
unistr('/* \0141adne t\0142o formularza */'),
'.t-Form-fieldContainer {',
'    margin-bottom: 12px !important;',
'}',
'',
unistr('/* Zaokr\0105glenia p\00F3l */'),
'input[type="text"], ',
'select {',
'    border-radius: 6px !important;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(3047685815783021)
,p_plug_name=>'Package Info'
,p_title=>'Package Overview'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(3048373486783028)
,p_name=>'Available Hotels'
,p_template=>4072358936313175081
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    h.hotel_name,',
'    h.city,',
'    h.rating,',
'    h.family_rooms',
'FROM trip_package_hotels tph',
'JOIN hotels h ',
'    ON h.hotel_id = tph.hotel_id',
'WHERE tph.package_id = :P3_PACKAGE_ID',
'ORDER BY h.hotel_name',
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
 p_id=>wwv_flow_imp.id(3050301127783048)
,p_query_column_id=>1
,p_column_alias=>'HOTEL_NAME'
,p_column_display_sequence=>10
,p_column_heading=>'Hotel Name'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(3050484136783049)
,p_query_column_id=>2
,p_column_alias=>'CITY'
,p_column_display_sequence=>20
,p_column_heading=>'City'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(3050503078783050)
,p_query_column_id=>3
,p_column_alias=>'RATING'
,p_column_display_sequence=>30
,p_column_heading=>'Rating'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(5045463093551101)
,p_query_column_id=>4
,p_column_alias=>'FAMILY_ROOMS'
,p_column_display_sequence=>40
,p_column_heading=>'Family Rooms'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(3048711694783032)
,p_name=>'Available Attractions'
,p_template=>4072358936313175081
,p_display_sequence=>40
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    a.attraction_name,',
'    a.category,',
'    a.description,',
'    a.price_per_person,',
'    a.rating',
'FROM trip_package_attractions tpa',
'JOIN attractions a',
'    ON a.attraction_id = tpa.attraction_id',
'WHERE tpa.package_id = :P3_PACKAGE_ID',
'ORDER BY a.attraction_name',
'',
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
 p_id=>wwv_flow_imp.id(3049859796783043)
,p_query_column_id=>1
,p_column_alias=>'ATTRACTION_NAME'
,p_column_display_sequence=>10
,p_column_heading=>'Attraction Name'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(3049983613783044)
,p_query_column_id=>2
,p_column_alias=>'CATEGORY'
,p_column_display_sequence=>20
,p_column_heading=>'Category'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(3050047953783045)
,p_query_column_id=>3
,p_column_alias=>'DESCRIPTION'
,p_column_display_sequence=>30
,p_column_heading=>'Description'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(3050146497783046)
,p_query_column_id=>4
,p_column_alias=>'PRICE_PER_PERSON'
,p_column_display_sequence=>40
,p_column_heading=>'Price Per Person'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(3050264435783047)
,p_query_column_id=>5
,p_column_alias=>'RATING'
,p_column_display_sequence=>50
,p_column_heading=>'Rating'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(3049143050783036)
,p_name=>'Available Transport Modes'
,p_template=>4072358936313175081
,p_display_sequence=>50
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    transport_mode',
'FROM trip_package_transport_modes',
'WHERE package_id = :P3_PACKAGE_ID',
'ORDER BY transport_mode',
'',
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
 p_id=>wwv_flow_imp.id(3049412003783039)
,p_query_column_id=>1
,p_column_alias=>'TRANSPORT_MODE'
,p_column_display_sequence=>30
,p_column_heading=>'Transport Mode'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(4451286921296506)
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
 p_id=>wwv_flow_imp.id(3049718834783042)
,p_button_sequence=>60
,p_button_name=>'P3_BOOK'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>unistr('Rezerwuj t\0119 wycieczk\0119')
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::P4_PACKAGE_ID,P4_PACKAGE_NAME,P4_CITY_START,P4_CITY_TARGET,P4_DAYS,P4_BUDGET:&P3_PACKAGE_ID.,&P3_NAME.,&P3_CITY_START.,&P3_CITY_TARGET.,&P3_DAYS.,&P3_BUDGET.'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3047411255783019)
,p_name=>'P3_PACKAGE_ID'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3047702367783022)
,p_name=>'P3_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(3047685815783021)
,p_prompt=>'Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT package_name ',
'FROM trip_packages ',
'WHERE package_id = :P3_PACKAGE_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3047802011783023)
,p_name=>'P3_CITY_START'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(3047685815783021)
,p_prompt=>'City Start'
,p_source=>'SELECT city_start FROM trip_packages WHERE package_id = :P3_PACKAGE_ID'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3048055838783025)
,p_name=>'P3_CITY_TARGET'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(3047685815783021)
,p_prompt=>'City Target'
,p_source=>'SELECT city_target FROM trip_packages WHERE package_id = :P3_PACKAGE_ID'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3048165156783026)
,p_name=>'P3_DAYS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(3047685815783021)
,p_item_default=>'SELECT base_days FROM trip_packages WHERE package_id = :P3_PACKAGE_ID'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Days'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3048256515783027)
,p_name=>'P3_BUDGET'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(3047685815783021)
,p_item_default=>'SELECT base_budget FROM trip_packages WHERE package_id = :P3_PACKAGE_ID'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Budget'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp.component_end;
end;
/
