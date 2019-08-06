-module(issue).

-include_lib("eunit/include/eunit.hrl").

-define(SERVER, "http://localhost:8080").

-export([make_calls_test/0]).

-import(calls_counter, [
    init_calls_counter_ets/0,
    init_fun_calls_couter/2,
    get_fun_calls_couter/2
    ]).

make_calls_test() ->
    init_calls_counter_ets(),
    init_fun_calls_couter(toppage_h, init),
    init_fun_calls_couter(toppage_h, terminate),
    %% Given
    Host = ?SERVER,
    Path = <<"/">>,
    Method = "GET",
    Headers = [],
    Body = [],
    NumOfReqs = 50,

    %% When
    Codes = [begin
                Response = execute_request(Host, Path, Method, Headers, Body),
                to_status_code(Response)
            end || _ <- lists:seq(1, NumOfReqs)],

    %% Then
    ExpectedCodes = lists:duplicate(NumOfReqs, 200), %% NumOfReqs times code 200
    case Codes of
        ExpectedCodes ->
            ok;
        _ ->
            ct:fail(#{reason => bad_codes,
                      codes => Codes,
                      expected_codes => ExpectedCodes})
    end,
    timer:sleep(timer:seconds(3)),
    RealInitCallsCount = get_fun_calls_couter(toppage_h, init),
    RealTerminateCallsCount = get_fun_calls_couter(toppage_h, terminate),
    io:fwrite("RealInitCallsCount = ~p\n", [RealInitCallsCount]),
    io:fwrite("RealTerminateCallsCount = ~p\n", [RealTerminateCallsCount]),
    ?assert(RealInitCallsCount =:= NumOfReqs),
    ?assert(RealTerminateCallsCount =:= NumOfReqs).

execute_request(Host, Path, Method, Headers, Body) ->
    {ok, Pid} = fusco:start_link(Host, []),
    Response = fusco:request(Pid, Path, Method, Headers, Body, 5000),
    fusco:disconnect(Pid),
    Response.

to_status_code({ok, {{CodeBin, _}, _, _, _, _}}) ->
    binary_to_integer(CodeBin).
