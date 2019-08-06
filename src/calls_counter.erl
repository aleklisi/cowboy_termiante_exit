-module(calls_counter).

-define(TABLE_NAME, calls_counter).

-export([
    init_calls_counter_ets/0,
    init_fun_calls_couter/2,
    get_fun_calls_couter/2,
    increase_fun_calls_couter/2
    ]).

init_calls_counter_ets() ->
    ets:new(?TABLE_NAME, [set, public, named_table]).

init_fun_calls_couter(Mod, Fun) ->
    ets:insert(?TABLE_NAME, {{Mod, Fun}, 0}).

get_fun_calls_couter(Mod, Fun) ->
    [{_, Count}] = ets:lookup(?TABLE_NAME, {Mod, Fun}),
    Count.

increase_fun_calls_couter(Mod, Fun) ->
    Count = get_fun_calls_couter(Mod, Fun),
    ets:insert(?TABLE_NAME, {{Mod, Fun}, Count + 1}).