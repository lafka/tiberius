-module(tbr_cmd_config).

-export([
	  description/0
	, main/1
]).

description() -> "Manipulate code artifact configuration".

main(_Args) ->
	io:format("exec: ~p~n", [?MODULE]).
