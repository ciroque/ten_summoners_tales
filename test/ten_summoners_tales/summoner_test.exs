defmodule TenSummonersTales.SummonerTest do
  use ExUnit.Case

  alias TenSummonersTales.RiotDevelopmentClientMock, as: ServiceClientMock
  alias TenSummonersTales.SummonerRetriever

  import Mox

  @moduletag :capture_log

  doctest SummonerRetriever

  setup :verify_on_exit!

  test "module exists" do
    assert is_list(SummonerRetriever.module_info())
  end

  describe "fetch_summoner_opponents" do

    test "calls through to ServiceClient.fetch_summoner" do
      expect_fetch_summoner_on_mock()
      expect_fetch_matches_on_mock()
      expect_fetch_match_on_mock()

      SummonerRetriever.retrieve_summoner_opponents(summoner_name(), region())
    end
  end

  defp expect_fetch_match_on_mock() do
    {:ok, mids} = match_ids()
    ServiceClientMock
    |> expect(
        :fetch_match,
        length(mids),
        fn match_id, _region ->
          assert mids |> Enum.member?(match_id)

          {:ok, empty_match_participants()}
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

      {:ok, %{name: summoner_name(), puuid: puuid()}}
    end)
  end

  defp empty_match_participants() do
    %{metadata: %{matchId: "matchId2112"}, info: %{ participants: []}}
  end

  defp match_ids() do
  {:ok, ["matchId1", "matchId2"]}
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
