prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
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
 p_id=>2
,p_name=>'Available Trips'
,p_alias=>'AVAILABLE-TRIPS'
,p_step_title=>'Available Trips'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(4442069329151600)
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
 p_id=>wwv_flow_imp.id(4442790138151608)
,p_plug_name=>'Available Packages'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    p.package_id,',
'    p.package_name,',
'    p.city_start,',
'    p.city_target,',
'    p.base_days,',
'    p.base_budget,',
'',
'    -- list of transport modes',
'    (SELECT LISTAGG(m.transport_mode, '', '') ',
'            WITHIN GROUP (ORDER BY m.transport_mode)',
'     FROM trip_package_transport_modes m ',
'     WHERE m.package_id = p.package_id',
'    ) AS transport_modes,',
'',
'    -- list of hotels',
'    (SELECT LISTAGG(h.hotel_name, '', '')',
'            WITHIN GROUP (ORDER BY h.hotel_name)',
'     FROM trip_package_hotels tph',
'     JOIN hotels h ON h.hotel_id = tph.hotel_id',
'     WHERE tph.package_id = p.package_id',
'    ) AS hotels,',
'',
'    -- list of attractions',
'    (SELECT LISTAGG(a.attraction_name, '', '')',
'            WITHIN GROUP (ORDER BY a.attraction_name)',
'     FROM trip_package_attractions tpa',
'     JOIN attractions a ON a.attraction_id = tpa.attraction_id',
'     WHERE tpa.package_id = p.package_id',
'    ) AS attractions',
'',
'FROM trip_packages p',
'WHERE 1 = 1',
'  AND (:P2_CITY_START   IS NULL OR p.city_start = :P2_CITY_START)',
'  AND (:P2_CITY_TARGET  IS NULL OR p.city_target = :P2_CITY_TARGET)',
'  AND (:P2_MIN_DAYS     IS NULL OR p.base_days >= :P2_MIN_DAYS)',
'  AND (:P2_MAX_DAYS     IS NULL OR p.base_days <= :P2_MAX_DAYS)',
'  AND (:P2_MIN_BUDGET   IS NULL OR p.base_budget >= :P2_MIN_BUDGET)',
'  AND (:P2_MAX_BUDGET   IS NULL OR p.base_budget <= :P2_MAX_BUDGET)',
'',
'  AND (',
'        :P2_TRANSPORT IS NULL ',
'        OR EXISTS (',
'            SELECT 1',
'            FROM trip_package_transport_modes m',
'            WHERE m.package_id = p.package_id',
'              AND m.transport_mode = :P2_TRANSPORT',
'        )',
'      )',
'',
'  AND (',
'        :P2_HOTEL IS NULL',
'        OR EXISTS (',
'            SELECT 1',
'            FROM trip_package_hotels tph',
'            WHERE tph.package_id = p.package_id',
'              AND tph.hotel_id = :P2_HOTEL',
'        )',
'      )',
'',
'  AND (',
'        :P2_ATTRACTION IS NULL',
'        OR EXISTS (',
'            SELECT 1',
'            FROM trip_package_attractions tpa',
'            WHERE tpa.package_id = p.package_id',
'              AND tpa.attraction_id = :P2_ATTRACTION',
'        )',
'      )',
'',
'ORDER BY p.package_id;',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Available Trips'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(4442831343151608)
,p_name=>'Available Trips'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'TA_APP'
,p_internal_uid=>4442831343151608
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(4443586339151614)
,p_db_column_name=>'PACKAGE_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Package Id'
,p_column_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_PACKAGE_ID:#PACKAGE_ID#'
,p_column_linktext=>'#PACKAGE_ID#'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(4443991727151619)
,p_db_column_name=>'PACKAGE_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Package Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(4444332464151619)
,p_db_column_name=>'CITY_START'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'City Start'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(4444772983151619)
,p_db_column_name=>'CITY_TARGET'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'City Target'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(4445172903151620)
,p_db_column_name=>'BASE_DAYS'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Base Days'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(4445569875151620)
,p_db_column_name=>'BASE_BUDGET'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Base Budget'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(4445902892151621)
,p_db_column_name=>'TRANSPORT_MODES'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Transport Modes'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(4446330534151621)
,p_db_column_name=>'HOTELS'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Hotels'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(4446737320151621)
,p_db_column_name=>'ATTRACTIONS'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Attractions'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(4448043011196144)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'44481'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'PACKAGE_ID:PACKAGE_NAME:CITY_START:CITY_TARGET:BASE_DAYS:BASE_BUDGET:TRANSPORT_MODES:HOTELS:ATTRACTIONS'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(3047362912783018)
,p_button_sequence=>20
,p_button_name=>'P2_SEARCH'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Search'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3046464682783009)
,p_name=>'P2_CITY_START'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(4442790138151608)
,p_prompt=>'City Start'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DISTINCT city_start d, city_start r',
'FROM routes',
'ORDER BY 1;',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3046590243783010)
,p_name=>'P2_CITY_TARGET'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(4442790138151608)
,p_prompt=>'City Target'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DISTINCT city_target d, city_target r',
'FROM routes',
'ORDER BY 1;',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3046626677783011)
,p_name=>'P2_MIN_DAYS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(4442790138151608)
,p_prompt=>'Min Days'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3046863507783013)
,p_name=>'P2_MAX_BUDGET'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(4442790138151608)
,p_prompt=>'Max Budget'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3046947878783014)
,p_name=>'P2_TRANSPORT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(4442790138151608)
,p_prompt=>'Transport Mode'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DISTINCT transport_mode d, transport_mode r',
'FROM trip_package_transport_modes',
'ORDER BY 1;',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3047088088783015)
,p_name=>'P2_HOTEL'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(4442790138151608)
,p_prompt=>'Hotel'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT hotel_name d, hotel_id r',
'FROM hotels',
'ORDER BY hotel_name;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3047258116783017)
,p_name=>'P2_ATTRACTION'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(4442790138151608)
,p_prompt=>'Attraction'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT attraction_name d, attraction_id r',
'FROM attractions',
'ORDER BY attraction_name;',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp.component_end;
end;
/
