-module(acl_role).
-export([role_add/2, check_role_permissions/3]).

role_add(Role, Permissions) ->
    Object = riakc_obj:new(<<"role">>, Role, Permissions),
    ok = riakc_pb_socket:put(riak, Object).

check_role_permissions(Role, Data, Permissions) ->
    case riakc_pb_socket:get(riak, <<"role">>, Role) of
        {error, notfound} ->
            false;
        {ok, Object} ->
            ListB = riakc_obj:get_value(Object),
            PropList = binary_to_term(ListB),
            Value = proplists:get_value(Data, PropList),
            Value =:= Permissions
    end.
