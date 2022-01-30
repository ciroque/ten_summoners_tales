defmodule TenSummonersTales.ServiceClientBehaviour do
  @moduledoc """
    Defines the behaviour expected to be implemented by a conforming implementation of a Riot Developer Api client.
  """

  @doc """
    Uses the Riot Development API to fetch information about the given summoner.

    ## Parameters

    - summoner_name: String representing the name of the Summoner.
    - region: String representing the name of the region to search.
  """
  @callback fetch_summoner(String.t(), String.t()) :: {:ok, map()} | {:error, String.t()}

  @doc """
    Uses the Riot Development API to fetch details of a match.

    ## Parameters

    - match_id: String representing the Match.
    - region: String representing the name of the region to search. NOTE: does nbot match region from Summoner endpoint.
  """
  @callback fetch_match(String.t(), String.t()) :: {:ok, map()} | {:error, String.t()}

  @doc """
    Uses the Riot Development API to fetch matches the given summoner has played.

    ## Parameters

    - puuid: String representing the puuid of the Summoner.
    - region: String representing the name of the region to search. NOTE: does nbot match region from Summoner endpoint.
    - match_count: Integer representing the number of matches to retrieve.
  """
  @callback fetch_matches(String.t(), String.t()) :: {:ok, list(String.t())} | {:error, String.t()}
end
