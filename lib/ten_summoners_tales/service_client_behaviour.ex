defmodule TenSummonersTales.ServiceClientBehaviour do
  @moduledoc """
    Defines the behaviour expected to be implemented by a conforming implementation of a Riot Developer Api client.
  """

  @doc """
    Uses the Riot Development API to fetch information about the given summoner

    ## Parameters

    - summoner_name: String representing the name of the Summoner to look up.
    - region: String representing the name of the region to search.


  """
  @callback fetch_summoner(String.t(), String.t()) :: {:ok, map()} | {:error, String.t()}
end
