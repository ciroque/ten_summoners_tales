defmodule TenSummonersTales.SummonerTest do
  use ExUnit.Case

  alias TenSummonersTales.RiotDevelopmentClientMock, as: ServiceClientMock
  alias TenSummonersTales.SummonerFetcher

  import Mox

  @moduletag :capture_log

  doctest SummonerFetcher

  setup :verify_on_exit!

  test "module exists" do
    assert is_list(SummonerFetcher.module_info())
  end

  describe "fetch_summoner_opponents" do

    test "calls through to ServiceClient.fetch_summoner" do
      expect_fetch_summoner_on_mock()
      expect_fetch_matches_on_mock()
      expect_fetch_match_on_mock()

      SummonerFetcher.retrieve_summoner_opponents(summoner_name(), region())
    end
  end

  defp expect_fetch_match_on_mock() do
    ServiceClientMock
    |> expect(
        :fetch_match,
        length(match_ids()),
        fn match_id, _region ->
          assert match_ids() |> Enum.member?(match_id)

          empty_match_participants()
        end)
  end

  defp expect_fetch_matches_on_mock() do
    ServiceClientMock
    |> expect(:fetch_matches, fn puuid, _ ->
      assert puuid == puuid()

      match_ids()
    end)
  end

  defp expect_fetch_summoner_on_mock() do
    ServiceClientMock
    |> expect(:fetch_summoner, fn actual_summoner_name, actual_region ->
      assert actual_summoner_name == summoner_name()
      assert actual_region == region()

      %{name: summoner_name(), puuid: puuid()}
    end)
  end

  defp empty_match_participants() do
    %{info: %{ participants: []}}
  end

  defp match_ids() do
    ["matchId1", "matchId2"]
  end

  defp puuid() do
    "puuid_#{summoner_name()}"
  end

  defp region() do
    "NA1"
  end

  defp summoner_name() do
    "summoner_name"
  end
end
