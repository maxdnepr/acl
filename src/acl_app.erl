-module(acl_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    {ok, Pid} = riakc_pb_socket:start_link("127.0.0.1", 8087),
    true = register(riak, Pid),
    acl_sup:start_link().

stop(_State) ->
    ok.
