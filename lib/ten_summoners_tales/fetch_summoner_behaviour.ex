defmodule TenSummonersTales.FetchSummonerBehaviour do
  @moduledoc """
    Defines the behaviour expected to be implemented by a conforming implementation of a TenSummonersTales.Poller module.
  """

  @doc """
    Fetches the summoners from the five most recent matches.

    ## Parameters

    - summoner_name: String representing the name of the Summoner to follow.
    - region: String representing the name of the region to search.

  """
  @callback fetch_summoner_opponents(String.t(), String.t()) :: {:ok, list(map())} | {:error, String.t()}
end
