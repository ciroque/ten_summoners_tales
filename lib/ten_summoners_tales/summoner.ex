defmodule TenSummonersTales.Summoner do
  @moduledoc false

  @behaviour TenSummonersTales.FetchSummonerBehaviour

  @impl true
  @doc """

    Returns:
      A list of maps containing the summoners and their associated puuids.

    Examples:
      `TenSummonersTales.Summoner.fetch_summoner_opponents("bigfatjuicer", "NA")`
      `TenSummonersTales.Summoner.fetch_summoner_opponents("bigfatjuicer", "NA")`
      `TenSummonersTales.Summoner.fetch_summoner_opponents("Jobless Canadian", "NA")`
  """
  def fetch_summoner_opponents(summoner_name, region) do
    region = String.upcase(region)
    with {:ok, match_region: match_region} <- routing_map(region),
         %{name: _name, puuid: puuid} <- riot_api().fetch_summoner(summoner_name, region) do

      participants = retrieve_participants(puuid, match_region) |> extract_participant_fields

      {:ok, participants: participants}
    else
      {:error, message} -> {:error, message}
    end
  end

  defp extract_participant_fields(participants) do
    participants
    |> Enum.map(fn %{summonerName: summonerName, puuid: puuid} ->
      %{puuid: puuid, name: summonerName}
    end)
  end

  defp retrieve_participants(puuid, region) do
    riot_api().fetch_matches(puuid, region)
    |> Enum.flat_map(fn matchId ->
      %{info: %{ participants: participants }} = riot_api().fetch_match(matchId, region)

      participants
    end)
  end

  defp riot_api() do
    Application.get_env(:ten_summoners_tales, :service_client, TenSummonersTales.RiotApiClient)
  end

  @doc """
    Sauce: https://developer.riotgames.com/docs/lol#_routing-values
  """
  defp routing_map(region) do
    case region do
      region when region in ["BR1", "LA1", "LA2", "LAS", "NA1", "OC1", "OCE"] -> {:ok, match_region: "AMERICAS"}
      region when region in ["KR", "JP1"] -> {:ok, match_region: "ASIA"}
      region when region in ["EUN1", "EUW1", "RU", "TR1"] -> {:ok, match_region: "EUROPE"}
      _ -> {:error, message: "Region '#{region}' was not found"}
    end
  end
end
