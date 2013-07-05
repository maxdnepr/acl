-module(acl).

%% API
-export([start/0, stop/0]).

-export([register/2]).
-export([check_permissions/2, add_permissions/2]).

start() ->
    start(?MODULE).

stop() ->
    application:stop(?MODULE).


%% @private
start(AppName) ->
    F = fun({App, _, _}) -> App end,
    RunningApps = lists:map(F, application:which_applications()),
    ok = load(AppName),
    {ok, Dependencies} = application:get_key(AppName, applications),
    [begin
        ok = start(A)
    end || A <- Dependencies, not lists:member(A, RunningApps)],
    ok = application:start(AppName).

load(AppName) ->
    F = fun({App, _, _}) -> App end,
    LoadedApps = lists:map(F, application:loaded_applications()),
    case lists:member(AppName, LoadedApps) of
        true ->
            ok;
        false ->
            ok = application:load(AppName)
    end.

register(Key, Uid) when is_tuple(Key); is_list(Uid) ->
    UidB = list_to_binary(Uid),
    acl_permissions:register(Key, UidB);
register(Key, Uid) when is_tuple(Key); is_binary(Uid) ->
    acl_permissions:register(Key, Uid).

check_permissions(Key, Perms) when is_tuple(Key); is_list(Perms) ->
    KeyB = term_to_binary(Key),
    acl_permissions:check_permissions(KeyB, Perms).

add_permissions(Key, Perms) when is_tuple(Key); is_list(Perms) ->
    KeyB = term_to_binary(Key),
    PermsB = term_to_binary(Perms),
    acl_permissions:add_permissions(KeyB, PermsB);
add_permissions(Key, Perms) when is_binary(Key); is_binary(Perms) ->
    acl_permissions:add_permissions(Key, Perms).

role_add(Role, Permissions) when is_list(Role); is_list(Permissions) ->
    RoleB = list_to_binary(Role),
    PermissonsB = term_to_binary(Permissions),
    acl_role(RoleB, PermissionsB);
role_add(Role, Permissions) when is_binary(Role); is_binary(Permissions) ->
    acl_role(Role, Permissions).

check_role_permissions(Role, Object, Permissions) when is_list(Role) ->
    RoleB = list_to_binary(Role),
    acl_role:check_role_permissions(RoleB, Object, Permissions).

    

    




    

