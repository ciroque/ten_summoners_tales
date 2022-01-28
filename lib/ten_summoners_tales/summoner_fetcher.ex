defmodule TenSummonersTales.SummonerFetcher do
  @moduledoc false

  @behaviour TenSummonersTales.FetchSummonerBehaviour

  @impl true
  @doc """

    Returns:
      A list of maps containing the summoners and their associated puuids.

    Examples:
      `TenSummonersTales.SummonerFetcher.fetch_summoner_opponents("bigfatjuicer", "NA")`
      `TenSummonersTales.SummonerFetcher.fetch_summoner_opponents("bigfatjuicer", "NA")`
      `TenSummonersTales.SummonerFetcher.fetch_summoner_opponents("Jobless Canadian", "NA")`
  """
  def retrieve_summoner_opponents(summoner_name, region) do
    region = String.upcase(region)
    with {:ok, match_region: match_region} <- routing_map(region),
         %{name: _name, puuid: puuid} <- riot_api().fetch_summoner(summoner_name, region),
        {:ok, participant_names: participant_names, match_participants: match_participants} <- retrieve_match_info(puuid, match_region)
      do

        {:ok, participants: participant_names, match_participants: match_participants}

    else
      {:short, :no_matches} -> {:short, :no_matches}
      {:error, message} -> {:error, message}
    end
  end

  defp retrieve_match_info(puuid, region) do
    with {:ok, match_ids} <- retrieve_match_ids(puuid, region),
    {:ok, matches: matches} <- retrieve_matches(match_ids, region),
    {:ok, participant_names: participant_names} <- matches |> extract_participant_names(),
    {:ok, match_participants: match_participants} <- matches |> extract_match_participants() do

      {:ok, participant_names: participant_names, match_participants: match_participants}
    end
  end

  defp retrieve_match_ids(puuid, region) do
    case riot_api().fetch_matches(puuid, region) do
      [] -> {:short, :no_matches}
      match_ids -> {:ok, match_ids}
    end
  end

  defp retrieve_matches(match_ids, region) do
    matches = match_ids
    |> Enum.map(fn matchId ->
      riot_api().fetch_match(matchId, region)
    end)

    {:ok, matches: matches}
  end

  defp extract_participant_names(matches) do
    participant_names = matches
    |> Enum.flat_map(fn %{ info: %{ participants: participants }} -> participants end)
    |> Enum.map(fn %{summonerName: name} -> name end)

    {:ok, participant_names: participant_names}
  end

  defp extract_match_participants(matches) do
    match_participants = matches
    |> Enum.map(fn %{metadata: %{matchId: match_id}, info: %{ participants: participants}} ->
      participants_puuids = participants
      |> Enum.map(fn %{puuid: puuid, summonerName: name} -> %{puuid: puuid, name: name} end)
      %{match_id: match_id, participants: participants_puuids}
    end)

    {:ok, match_participants: match_participants}
  end

  defp riot_api() do
    Application.get_env(:ten_summoners_tales, :service_client, TenSummonersTales.RiotApiClient)
  end

  # Sauce: https://developer.riotgames.com/docs/lol#_routing-values
  defp routing_map(region) do
    case region do
      region when region in ["BR1", "LA1", "LA2", "LAS", "NA1", "OC1", "OCE"] -> {:ok, match_region: "AMERICAS"}
      region when region in ["KR", "JP1"] -> {:ok, match_region: "ASIA"}
      region when region in ["EUN1", "EUW1", "RU", "TR1"] -> {:ok, match_region: "EUROPE"}
      _ -> {:error, message: "Region '#{region}' was not found"}
    end
  end
end
