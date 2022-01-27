defmodule TenSummonersTales.SummonerTest do
  use ExUnit.Case

  alias TenSummonersTales.RiotDevelopmentClientMock, as: ServiceClientMock
  alias TenSummonersTales.Summoner

  import Mox

  @moduletag :capture_log

  doctest Summoner

  setup :verify_on_exit!

  test "module exists" do
    assert is_list(Summoner.module_info())
  end

  describe "fetch_summoner_opponents" do

    test "calls through to ServiceClient.fetch_summoner" do
      expect_fetch_summoner_on_mock()
      expect_fetch_matches_on_mock()
      expect_fetch_match_on_mock()

      Summoner.fetch_summoner_opponents(summoner_name(), region())
    end
  end

  defp expect_fetch_match_on_mock() do
    ServiceClientMock
    |> expect(
        :fetch_match,
        length(match_ids()),
        fn match_id, _region ->
          assert match_ids() |> Enum.member?(match_id)

          %{info: %{ participants: []}}
        end)
  end

  defp expect_fetch_matches_on_mock() do
    ServiceClientMock
    |> expect(:fetch_matches, fn puuid, _, _ ->
      assert puuid == puuid()

      match_ids()
    end)
  end

  defp expect_fetch_summoner_on_mock() do
    ServiceClientMock
    |> expect(:fetch_summoner, fn actual_summoner_name, _actual_region ->
      assert actual_summoner_name == summoner_name()
#      assert actual_region == region()  ## TODO: account for the mapping that needs to be done...

      %{name: summoner_name(), puuid: puuid()}
    end)
  end

  defp match_ids() do
    ["matchId1", "matchId2"]
  end

  defp puuid() do
    "puuid_#{summoner_name()}"
  end

  defp region() do
    "region"
  end

  defp summoner_name() do
    "summoner_name"
  end
end
