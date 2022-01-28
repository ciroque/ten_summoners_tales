defmodule TenSummonersTales.TrackSummonerBehaviour do
  @moduledoc """
    Defines the behaviour expected to be implemented by a conforming implementation of a Summoner Tracker.
  """

  @doc """
    Kicks off a process to follow the given list of Summoners.

    ## Parameters

    - participant_matches: List of objects mapping participants to matches.
    - region:
  """
  @callback track_summoners(list(map()), String.t()) :: {:ok}
end
