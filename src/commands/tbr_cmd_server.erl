-module(tbr_cmd_server).

-export([
	  description/0
	, main/1
]).

description() -> "Start/stop a Tiberius daemon".

main(_Args) ->
	io:format("exec: ~p~n", [?MODULE]).
