-module(sumo_basic_SUITE).

%% CT
-export([
  all/0,
  init_per_suite/1,
  end_per_suite/1,
  init_per_testcase/2
]).

%% Test Cases
-include_lib("mixer/include/mixer.hrl").
-mixin([
  {sumo_basic_test_helper, [
    find/1,
    find_all/1,
    find_by/1,
    delete_all/1,
    delete/1,
    check_proper_dates/1
  ]}
]).

-define(EXCLUDED_FUNS, [
  module_info,
  all,
  init_per_suite,
  init_per_testcase,
  end_per_suite
]).

-type config() :: [{atom(), term()}].

%%%=============================================================================
%%% Common Test
%%%=============================================================================

-spec all() -> [atom()].
all() ->
  Exports = ?MODULE:module_info(exports),
  [F || {F, _} <- Exports, not lists:member(F, ?EXCLUDED_FUNS)].

-spec init_per_suite(config()) -> config().
init_per_suite(Config) ->
  ok = sumo_test_utils:start_apps(),
  [{module, sumo_test_people_mnesia} | Config].

init_per_testcase(_, Config) ->
  {_, Module} = lists:keyfind(module, 1, Config),
  sumo_basic_test_helper:init_store(Module),
  Config.

-spec end_per_suite(config()) -> config().
end_per_suite(Config) ->
  Config.
