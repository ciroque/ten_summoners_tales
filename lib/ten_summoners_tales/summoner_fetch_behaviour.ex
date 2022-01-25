defmodule TenSummonersTales.SummonerFetchBehaviour do
  @moduledoc """
    Defines the behaviour expected to be implemented by a conforming implementation of a TenSummonersTales.Poller module.
  """

  @doc """
    Fetches the five most recent match players and initiates a polling operation to follow the returned summoners.

    ## Parameters

    - summoner_name: String representing the name of the Summoner to follow.
    - polling_period: Integer specifying the polling frequency in milliseconds; i.e.: one second = 1_000, one minute = 60_000.
    - poll_count: Integer specifying the number of polling operations to perform.

    ## Examples

    - Follow a Summoner, polling every minute for one hour...
    iex> TenSummonersTales.Poller.follow_summoner("ABCD1234", 60_000, 60)

  """
  @callback fetch_summoners_opponents(String.t(), integer(), integer()) :: {:ok, list(String.t())} | {:error, String.t()}
end
