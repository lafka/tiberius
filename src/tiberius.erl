-module(tiberius).

-export([
	  main/1
	, err/1
	, err/2
	, err/3
]).

-define(CMD, "tbr_cmd_").
-define(CMDATOM(C), list_to_atom(?CMD ++ C)).

main([]) ->
	usage();

main(["help"]) ->
	usage();

main([Command | Args]) ->
	command(Command, Args).

command(Cmd, Args) ->
	Module = ?CMDATOM(Cmd),

	case code:ensure_loaded(Module) of
		{module, Module} ->
			Module:main(Args);
		{error, Err} ->
			err("Error processing command ~p", [Cmd], Err)
	end.

usage() ->
	Padding = lists:foldl(fun({_, C}, Acc) ->
		max(length(C), Acc)
	end, 4, commands()), % 4 =:= length(help)

	Fmt = "  ~-" ++ integer_to_list(Padding) ++ "s  -- ~s~n",

	HelpText = io_lib:format(Fmt, [help, "Show this help text"]),

	Cmds = [ HelpText | lists:foldr(fun({Mod0, Cmd}, Acc) ->
		Mod = list_to_atom(Mod0),
		[io_lib:format(Fmt, [Cmd, Mod:description()]) | Acc]
	end, [], commands())],

	io:format("usage: tiberius <command>~n~nCommands:~n~s~n" , [Cmds]).

err(Str) ->
	err(Str, [], []).

err(Str, Err) ->
	err(Str, [], Err).

err(Str, Args, Err) ->
	io:format(Str ++ "~n", Args),
	io:format("-- error:~n  ~p~n", [Err]).

commands() ->
	{ok, Paths} = erl_prim_loader:get_path(),

	lists:foldl(fun(Path, Commands) ->
		{ok, Beams} = erl_prim_loader:list_dir(Path),
		[ {filename:basename(File, ".beam"), extract_cmd(File)} || File
			<- Beams
			, filename:extension(File) == ".beam"
			, lists:prefix(?CMD, File)]
		++ Commands
	end, [], Paths).

extract_cmd(?CMD ++ Cmd) ->
	filename:basename(Cmd, ".beam").
