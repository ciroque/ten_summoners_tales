defmodule TenSummonersTales.TrackSummonerBehaviour do
  @moduledoc """
    Defines the behaviour expected to be implemented by a conforming implementation of a Summoner Tracker.
  """

  @doc """
    Kicks off a process to follow the given list of Summoners.

    ## Parameters

    - summoners: List of Maps representing the summoners that are to be tracked.
  """
  @callback track_summoners(list(map())) :: {:ok}
end
