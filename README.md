# cowboy_termiante_exit

This repository is providing minimal counterexample for

"The optional `terminate/3` callback will ultimately be called with the reason for the termination of the handler. Cowboy will terminate the process right after this. There is no need to perform any cleanup in this callback."

from

https://ninenines.eu/docs/en/cowboy/2.6/manual/cowboy_handler/


## Steps to reproduce

- Setup cowboy with `http` endpoint and terminate call in handler.
- The terminate call must last for a moment (like 1 second).
- Add calls counters in `init/2` and `terminate/3` calls.
- Make `http` request.
- Wait for reply (with status `200`) (like 3 second to make sure that `terminate/3` call had enough time to execute).
- Assert number of `init/2` and `terminate/3` calls.

## How to run example
```
rebar3 shell

% trace goes here

eunit:test(issue).
```
## Suspected issue

Add following tracing:
```erlang
dbg:tracer().
dbg:p(all, c).
dbg:p(all, p).
dbg:tpl(toppage_h, init, x).
dbg:tpl(toppage_h, terminate, x).
```
Notice that you get:
```
...
(<0.229.0>) exit {shutdown,{socket_error,closed,'The socket has been closed.'}}
...
```
More over if you uncomment
```
...
% process_flag(trap_exit, true),
...
```
in `src/toppage_h.erl` the issue will be solved.
