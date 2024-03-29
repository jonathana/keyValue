%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the keyValue application.

-module(keyValue_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for keyValue.
start(_Type, _StartArgs) ->
    keyValue_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for keyValue.
stop(_State) ->
    ok.
