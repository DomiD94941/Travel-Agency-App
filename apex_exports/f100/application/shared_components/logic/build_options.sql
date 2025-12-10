prompt --application/shared_components/logic/build_options
begin
--   Manifest
--     BUILD OPTIONS: 100
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.10'
,p_default_workspace_id=>2356212381289404
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'TA_APP'
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(4246444180122819)
,p_build_option_name=>'Commented Out'
,p_build_option_status=>'EXCLUDE'
,p_version_scn=>12077398
);
wwv_flow_imp.component_end;
end;
/
