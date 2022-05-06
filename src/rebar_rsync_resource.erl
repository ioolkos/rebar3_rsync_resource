-module(rebar_rsync_resource).

-behaviour(rebar_resource).

-export(
    [ init/2
    , lock/2
    , download/3
    , download/4
    , needs_update/2
    , make_vsn/1
    , make_vsn/2
    ]).

flags() -> "--exclude _build -aW".

init(Type, _RebarState) ->
    CustomState = #{},
    Resource = rebar_resource_v2:new(Type, ?MODULE, CustomState),
    {ok, Resource}.

%% Old
lock(Dir, Source) when is_tuple(Source) ->
    lock_(Dir, Source);
%% New
lock(AppInfo, _ResourceState) ->
    lock_(rebar_app_info:dir(AppInfo), rebar_app_info:source(AppInfo)).
lock_(_Dir, Source) ->
    Source.

%% Old
download(TmpDir, SourceTuple, RebarState) ->
    download_(TmpDir, SourceTuple, RebarState).
  
%% New
download(TmpDir, AppInfo, _ResourceState, RebarState) ->
    download_(TmpDir, rebar_app_info:source(AppInfo), RebarState).
  
download_(Dir, {rsync, Remote}, _State) ->
    Out = os:cmd(io_lib:format("rsync ~s ~s ~s", [flags(), Remote, Dir])),
    io:format(Out),
    {ok, Out}.

%% Old
needs_update(Dir, {MyTag, Path, _}) ->
    needs_update_(Dir, {MyTag, Path});
%% New
needs_update(AppInfo, _) ->
    needs_update_(rebar_app_info:dir(AppInfo), rebar_app_info:source(AppInfo)).

needs_update_(Dir, {rsync, Remote}) ->
    Out = os:cmd(io_lib:format("rsync --stats --dry-run ~s ~s ~s", [flags(), Remote, Dir])),
    case string:str(Out, "Total transferred file size: 0 bytes") of
        0 -> true;
        _ -> false
    end.

%% Old
make_vsn(_Dir) ->
    {plain, "42"}.
%% New
make_vsn(Dir, _ResourceState) ->
    make_vsn(Dir).