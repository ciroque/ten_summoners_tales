defmodule TenSummonersTales do
  @moduledoc """
  Documentation for `TenSummonersTales`.
  """

  @doc """
  Given a valid summoner_name and region will fetch all summoners this summoner has
  played with in the last 5 matches. This data is returned to the caller as a list of
  summoner names.

  ## Examples

      iex> TenSummonersTales.track_summoner("boycold", "na1")

  """
  def track_summoner(summoner_name, region) do
    case fetcher().retrieve_summoner_opponents(summoner_name, region) do
      {:error, [message: message]} -> "An error occurred processing your request: #{message}"
      {:short, :no_matches} -> "#{summoner_name} has not participated in any matches."
      {:ok, participant_names: participant_names, participant_matches: participant_matches} ->

        participant_matches |> tracker().track_summoners()

        participant_names
    end
  end

  defp fetcher() do
    Application.get_env(:ten_summoners_tales, :fetcher, TenSummonersTales.SummonerRetriever)
  end

  defp tracker() do
    Application.get_env(:ten_summoners_tales, :tracker, TenSummonersTales.SummonerTracker)
  end
end
