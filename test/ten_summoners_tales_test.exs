defmodule TenSummonersTalesTest do
  use ExUnit.Case

  import Mox

  alias TenSummonersTales
  alias TenSummonersTales.FetchSummonerMock
  alias TenSummonersTales.TrackSummonerMock

  setup :verify_on_exit!

  describe "track_summoner" do
    test "..." do

      FetchSummonerMock
      |> expect(:retrieve_summoner_opponents, fn _, _ ->

        {:ok, participants: participants()}
      end)

      TrackSummonerMock
      |> expect(:track_summoners, fn _ ->
        {:ok}
      end)

      summoners = TenSummonersTales.track_summoner(summoner_name(), region())

      assert [summoner_name()] == summoners
    end
  end

  defp participants() do
    [
      %{
        name: summoner_name(),
        puuid: "puuid"
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
