-module(tiberius).

-export([main/1]).

main(Args) ->
	io:format("args: ~p~n", [Args]).
