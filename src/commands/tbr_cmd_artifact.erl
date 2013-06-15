-module(tbr_cmd_artifact).

-export([
	  description/0
	, main/1
]).

description() -> "Manipulate code artifacts".

main(_Args) ->
	io:format("exec: ~p~n", [?MODULE]).
