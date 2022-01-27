defmodule TenSummonersTales.Summoner do
  @moduledoc false

  @behaviour TenSummonersTales.FetchSummonerBehaviour

  @impl true
  @doc """
    Examples:
      `TenSummonersTales.Summoner.fetch_summoner_opponents("bigfatjuicer", "NA")`
      `TenSummonersTales.Summoner.fetch_summoner_opponents("bigfatjuicer", "NA")`
      `TenSummonersTales.Summoner.fetch_summoner_opponents("Jobless Canadian", "NA")`
  """
  def fetch_summoner_opponents(summoner_name, region) do

    %{summoner_region: summoner_region, match_region: match_region} = routing_map(region)

    %{name: _name, puuid: puuid} = riot_api().fetch_summoner(summoner_name, summoner_region)

    retrieve_participants(puuid, match_region)
    |> Enum.map(fn %{summonerName: summonerName, puuid: _puuid} ->
      #      %{puuid: puuid, name: participant_name}
      summonerName
    end)

  end

  defp retrieve_participants(puuid, region) do
    riot_api().fetch_matches(puuid, region, 5)
    |> Enum.flat_map(fn matchId ->
      %{info: %{ participants: participants }} = riot_api().fetch_match(matchId, region)

      participants
    end)
  end

  defp riot_api() do
    Application.get_env(:ten_summoners_tales, :service_client, TenSummonersTales.RiotApiClient)
  end

  defp routing_map(region) do
    case region do
      "NA" ->
        %{summoner_region: "NA1", match_region: "AMERICAS"}
      _ ->
        %{summoner_region: "NA1", match_region: "AMERICAS"}
    end
  end
end
