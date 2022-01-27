defmodule TenSummonersTales.FetchSummonerBehaviour do
  @moduledoc """
    Defines the behaviour expected to be implemented by a conforming implementation of a TenSummonersTales.Poller module.
  """

  @doc """
    Fetches the five most recent match players and initiates a polling operation to follow the returned summoners.

    ## Parameters

    - summoner_name: String representing the name of the Summoner to follow.
    - region: String representing the name of the region to search.

  """
  @callback fetch_summoner_opponents(String.t(), String.t()) :: {:ok, list(String.t())} | {:error, String.t()}
end
