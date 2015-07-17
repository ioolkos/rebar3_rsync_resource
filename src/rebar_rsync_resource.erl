-module(rebar_rsync_resource).

-behaviour(rebar_resource).

-export(
    [ lock/2
    , download/3
    , needs_update/2
    , make_vsn/1
    ]).

lock(Dir, Source) ->
    Source.

download(Dir, {rsync, Remote}, State) ->
    Out = os:cmd(io_lib:format("rsync --exclude _build -aW ~s ~s", [Remote, Dir])),
    io:format(Out),
    {ok, Out}.

needs_update(Dir, Source) ->
    false.

make_vsn(Dir) ->
    {plain, "42"}.
