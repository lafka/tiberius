-module(tbr_cmd_foreground).

-export([
	  description/0
	, main/1
]).

description() -> "Start Tiberius server in foreground".

main(_Args) ->
	io:format("exec: ~p~n", [?MODULE]).
