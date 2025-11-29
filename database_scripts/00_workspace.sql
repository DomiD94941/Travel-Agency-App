prompt === Ensure DB schema &TARGET_SCHEMA exists (set password if allowed, unlock always) ===

declare
  l_schema varchar2(128) := upper('&TARGET_SCHEMA');
  l_pass   varchar2(128) := '&TARGET_SCHEMA_PASS';
  l_cnt    number;
begin
  select count(*) into l_cnt
  from dba_users
  where username = l_schema;

  if l_cnt = 0 then
    execute immediate
      'create user '||l_schema||' identified by "'||
      replace(l_pass,'"','""')||'"';
  else
    begin
      execute immediate
        'alter user '||l_schema||' identified by "'||
        replace(l_pass,'"','""')||'"';
    exception
      when others then
        if sqlcode = -28007 then
          null; -- password reuse blocked, keep current one
        else
          raise;
        end if;
    end;
  end if;

  -- always unlock
  begin
    execute immediate 'alter user '||l_schema||' account unlock';
  exception when others then null;
  end;

  execute immediate
    'grant create session, create table, create view, create sequence,
            create procedure, create trigger, create type to '||l_schema;

  begin
    execute immediate 'alter user '||l_schema||' quota unlimited on data';
  exception when others then null;
  end;
end;
/
prompt === Force Builder Authentication to Database Accounts (instance-level) ===

begin
  apex_instance_admin.set_parameter(
    p_parameter => 'APEX_BUILDER_AUTHENTICATION',
    p_value     => 'DB'
  );
end;
/
prompt === Create/Update Workspace &TARGET_WORKSPACE and schema developer user ===

declare
  l_ws_id   number;
  l_user_id number;
  l_schema  varchar2(128) := upper('&TARGET_SCHEMA');
begin
  -- INTERNAL context for instance ops
  begin
    apex_util.set_security_group_id(
      apex_util.find_security_group_id(p_workspace => 'INTERNAL')
    );
  exception when others then null;
  end;

  -- workspace find/create
  begin
    l_ws_id := apex_util.find_security_group_id(
                p_workspace => upper('&TARGET_WORKSPACE'));
  exception when others then
    l_ws_id := null;
  end;

  if l_ws_id is null then
    apex_instance_admin.add_workspace(
      p_workspace      => upper('&TARGET_WORKSPACE'),
      p_primary_schema => l_schema
    );
    l_ws_id := apex_util.find_security_group_id(
                p_workspace => upper('&TARGET_WORKSPACE'));
  end if;

  apex_util.set_security_group_id(l_ws_id);

  -- make sure APEX user with same name as db user exists
  begin
    l_user_id := apex_util.get_user_id(p_username => l_schema);
  exception when others then
    l_user_id := null;
  end;

  if l_user_id is null then
    apex_util.create_user(
      p_user_name       => l_schema,
      p_web_password    => '&TARGET_SCHEMA_PASS',
      p_email_address   => 'ta_app@example.com',
      p_default_schema  => l_schema,
      p_developer_privs => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
      p_change_password_on_first_use => 'N'
    );
  else
    apex_util.edit_user(
      p_user_id         => l_user_id,
      p_user_name       => l_schema, -- required in APEX 24.2
      p_web_password    => '&TARGET_SCHEMA_PASS',
      p_new_password    => '&TARGET_SCHEMA_PASS',
      p_email_address   => 'ta_app@example.com',
      p_default_schema  => l_schema,
      p_developer_roles => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
      p_change_password_on_first_use => 'N',
      p_account_locked  => 'N'
    );
  end if;

  commit;
end;
/
prompt === DONE ===
