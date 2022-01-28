defmodule TenSummonersTalesTest do
  use ExUnit.Case

  import Mox

  alias TenSummonersTales
  alias TenSummonersTales.RetrieveSummonerMock
  alias TenSummonersTales.TrackSummonerMock

  setup :verify_on_exit!

  describe "track_summoner" do
    test "happy path" do

      RetrieveSummonerMock
      |> expect(:retrieve_summoner_opponents, fn _, _ ->

        {:ok, participant_names: participant_names(), participant_matches: participant_matches(), match_region: region()}
      end)

      TrackSummonerMock
      |> expect(:track_summoners, fn actual_participant_matches, _ ->
        assert actual_participant_matches == participant_matches()

        {:ok}
      end)

      summoners = TenSummonersTales.track_summoner(summoner_name(), region())

      assert [summoner_name()] == summoners
    end
  end

  defp participant_names() do
    [summoner_name()]
  end

  defp participant_matches() do
    [
      %{
        name: summoner_name(),
        puuid: "puuid",
        matches: []
      }
    ]
  end

  defp region() do
    "na1"
  end

  defp summoner_name() do
    "summoner"
  end
end
