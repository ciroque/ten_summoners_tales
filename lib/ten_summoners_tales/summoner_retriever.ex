defmodule TenSummonersTales.SummonerRetriever do
  @moduledoc false

  @behaviour TenSummonersTales.RetrieveSummonerBehaviour

  @impl true
  @doc """

    Returns:
      A list of maps containing the summoners and their associated puuids.

    Examples:
      `TenSummonersTales.SummonerRetriever.fetch_summoner_opponents("bigfatjuicer", "NA")`
      `TenSummonersTales.SummonerRetriever.fetch_summoner_opponents("bigfatjuicer", "NA")`
      `TenSummonersTales.SummonerRetriever.fetch_summoner_opponents("Jobless Canadian", "NA")`
  """
  def retrieve_summoner_opponents(summoner_name, region) do
    region = String.upcase(region)
    with {:ok, match_region: match_region} <- routing_map(region),
         {:ok, %{puuid: puuid}} <- riot_api().fetch_summoner(summoner_name, region),
        {:ok, participant_names: participant_names, participant_matches: participant_matches} <- retrieve_match_info(puuid, match_region)
      do
        {
          :ok,
          participant_names: participant_names,
          participant_matches: participant_matches,
          match_region: match_region
        }

    else
      # NOTE: ALl of these should include correlation ids that are also written to the logs to aid in debugging.
      # That is, don't return the actual error to the caller, but provide a means to correlate this error to log
      # entries that contain the details...
      {:error, :rate_limit_exceeded} -> {:error, message: "Exceeded rate limit"}
      {:error, :invalid_api_token} -> {:error, message: "Unauthorized, ensure the API token is valid"}
      {:error, :invalid_request} -> {:error, message: "The request was invalid"}
      {:error, :region_not_found} -> {:error, message: "Region '#{region}' was not found"}
      {:short, :no_matches} -> {:short, :no_matches}
    end
  end

  defp extract_participants(matches) do
    participants = matches
   |> Enum.flat_map(fn %{ info: %{ participants: participants }} -> participants end)
   |> Enum.map(fn %{puuid: puuid, summonerName: name} -> %{puuid: puuid, name: name} end)

    {:ok, participants: participants}
  end

  defp extract_participant_matches(matches, participants, region) do
    participant_matches = participants
    |> Enum.map(fn %{puuid: puuid, name: name} ->
      matches = puuid |> find_participant_matches(matches)
      %{puuid: puuid, name: name, matches: matches, region: region}
    end)

    {:ok, participant_matches: participant_matches |> Enum.sort |> Enum.uniq}
  end

  defp extract_participant_names(participants) do
    participant_names = participants |> Enum.map(fn %{name: name} -> name end)

    {:ok, participant_names: participant_names |> Enum.sort |> Enum.uniq }
  end

  defp find_participant_matches(puuid, matches) do
    matches
    |> Enum.filter(fn %{metadata: %{participants: participants}} ->
      participants |> Enum.member?(puuid)
    end)
    |> Enum.map(fn %{metadata: %{matchId: match_id}} -> match_id end)
  end

  defp retrieve_match_info(puuid, match_region) do
    with {:ok, match_ids} <- retrieve_match_ids(puuid, match_region),
    {:ok, matches: matches} <- retrieve_matches(match_ids, match_region),
    {:ok, participants: participants} <- matches |> extract_participants(),
    {:ok, participant_names: participant_names} <- participants |> extract_participant_names(),
    {:ok, participant_matches: participant_matches} <- matches |> extract_participant_matches(participants, match_region) do

      {:ok, participant_names: participant_names, participant_matches: participant_matches}
    end
  end

  defp retrieve_match_ids(puuid, region) do
    case riot_api().fetch_matches(puuid, region) do
      {:ok, []} -> {:short, :no_matches}
      {:ok, match_ids} -> {:ok, match_ids}
    end
  end

  defp retrieve_matches(match_ids, region) do
    matches = match_ids
    |> Enum.map(fn matchId ->
      {:ok, match} = riot_api().fetch_match(matchId, region)
      match
    end)

    {:ok, matches: matches}
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
      _ -> {:error, :region_not_found}
    end
  end
end
