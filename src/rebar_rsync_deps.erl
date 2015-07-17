-module(rebar_rsync_deps).

-export([init/1]).

init(State) ->
    {ok, rebar_state:add_resource(State, {rsync, rebar_rsync_resource})}.