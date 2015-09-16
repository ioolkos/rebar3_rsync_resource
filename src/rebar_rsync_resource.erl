-module(rebar_rsync_resource).

-behaviour(rebar_resource).

-export(
    [ lock/2
    , download/3
    , needs_update/2
    , make_vsn/1
    ]).

flags() -> "--exclude _build -aW".

lock(Dir, Source) ->
    Source.

download(Dir, {rsync, Remote}, State) ->
    Out = os:cmd(io_lib:format("rsync ~s ~s ~s", [flags(), Remote, Dir])),
    io:format(Out),
    {ok, Out}.

needs_update(Dir, {rsync, Remote}) ->
    Out = os:cmd(io_lib:format("rsync --stats --dry-run ~s ~s ~s", [flags(), Remote, Dir])),
    case string:str(Out, "Total transferred file size: 0 bytes") of
        0 -> true;
        _ -> false
    end.

make_vsn(Dir) ->
    {plain, "42"}.
