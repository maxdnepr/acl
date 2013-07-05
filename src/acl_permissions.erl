-module(acl_permissions).
-export([register/2]).
-export([check_permissions/2, add_permissions/2]).

-include("acl.hrl").

register({Login, Passwd} = Key, Uid) ->
    User = #user_v1{uid = Uid, login = Login, passwd = Passwd},
    UserB = term_to_binary(User),
    KeyB = term_to_binary(Key),
    ok = new_object(<<"users">>, KeyB, UserB).

check_permissions(Key, Perms) ->
    case riakc_pb_socket:get(riak, <<"permissions">>, Key) of
        {error, notfound} ->
            false;
        {ok, Object} ->
            ListB = riakc_obj:get_value(Object),
            List = binary_to_term(ListB),
            lists:member(Perms, List)
    end.

add_permissions(Key, Perms) ->
    ok = new_object(<<"permissions">>, Key, Perms).
   
new_object(Table, Key, Data) ->
    Object = riakc_obj:new(Table, Key, Data),
    ok = riakc_pb_socket:put(riak, Object).
     
