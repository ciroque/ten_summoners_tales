defmodule TenSummonersTales do
  @moduledoc """
  Documentation for `TenSummonersTales`.
  """

  alias TenSummonersTales.Summoner

  @doc """
  Given a valid summoner_name and region will fetch all summoners this summoner has
  played with in the last 5 matches. This data is returned to the caller as a list of
  summoner names.

  ## Examples

      iex> TenSummonersTales.track_summoner("boycold", "na1")

  """
  def track_summoner(summoner_name, region) do
    case Summoner.retrieve_summoner_opponents(summoner_name, region) do
      {:error, [message: message]} -> "An error occurred processing your request: #{message}"
      {:ok, participants: []} -> "#{summoner_name} has not participated in any matches."
      {:ok, participants: participants} ->
        participants
        |> queue_polling()
        |> format_results()
    end
  end

  defp queue_polling(participants) do
    # TODO: Track summoners...
    participants
  end

  defp format_results(participants), do: participants |> Enum.map(fn %{name: name} -> name end) |> Enum.uniq |> Enum.sort
end
