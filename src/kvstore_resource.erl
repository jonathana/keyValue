%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(kvstore_resource).
-export([init/1, to_html/2]).
-export([content_types_provided/2]).
%%-export([resource_exists/2, content_types_accepted/2]).
%%-export([to_json/2, from_json/2]).
%%-export([generate_etag/2]).
-export([allowed_methods/2]).%%, delete_resource/2]).

-include_lib("webmachine/include/webmachine.hrl").

%%init([]) -> {ok, undefined}.
init([]) -> {ok, dict:new()}.

to_html(Req, State) ->
	case wrq:path_info(key, Req) of
    undefined ->
		{false, Req, State};
	Path ->
		case dict:find(Path, State) of
		error ->
			{io_lib:format("<html><body>Key [~s] not found</body></html>", [Path]), Req, State};
		{ok,Value} ->
			{io_lib:format("<html><body>Key [~s]=[~s]</body></html>", [Path, Value]), Req, State}
		end
	end.

from_json(Req, State) ->
	case wrq:path_info(key, Req) of
	undefined ->
			{false, Req, State};
	Path ->
		case dict:is_key(Path, State) of
			true ->
				{io_lib:format("{error:'key [~s] already exists'}", [Path]), Req, State};
			false ->
				dict:store(Path, wrq:get_qs_value("val", Req)),
				{io_lib:format("{key:'~s',value:'~s'}", [Path, dict:find(Path, State)]), Req, State}
		end
	end.

allowed_methods(Req, State) ->
  {['GET', 'PUT', 'DELETE', 'POST'], Req, State}.

%% GETs
content_types_provided(Req, State) ->
  {[{"application/json", to_json},{"text/html", to_html}], Req, State}.

%% POSTs and PUTs
content_types_accepted(Req, State) ->
	{[{"application/json", from_json}], Req, State}.
