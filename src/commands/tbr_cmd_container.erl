-module(tbr_cmd_container).

-export([
	  description/0
	, main/1
]).

description() -> "Command for working with containers (spawn, delete, etc)".

main(_Args) ->
	io:format("exec: ~p~n", [?MODULE]).
