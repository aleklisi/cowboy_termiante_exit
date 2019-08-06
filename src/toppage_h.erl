-module(toppage_h).

-export([init/2, terminate/3]).

init(Req0, Opts) ->
	Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain">>
	}, <<"Hello world!">>, Req0),
    calls_counter:increase_fun_calls_couter(?MODULE, ?FUNCTION_NAME),
	{ok, Req, Opts}.

terminate(_,_,_) ->
    timer:sleep(timer:seconds(1)),
    calls_counter:increase_fun_calls_couter(?MODULE, ?FUNCTION_NAME),
    ok.