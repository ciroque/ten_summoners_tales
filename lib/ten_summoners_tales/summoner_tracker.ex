defmodule TenSummonersTales.SummonerTracker do
  @moduledoc """
    This module implements the TemSummonersTales.PollerBehaviour to allow polling Summoners from the TODO [API name]
  """

  @behaviour TenSummonersTales.TrackSummonerBehaviour

  require Logger

  use GenServer

  @doc """
    TenSummonersTales.SummonerTracker.track_summoners([])
  """
  def track_summoners(participant_matches, match_region) do
    GenServer.cast(__MODULE__, {:track, participant_matches, match_region, polling_period(), poll_count()})
  end

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_cast({:track, participant_matches, match_region, period, count}, state) do
    state = state
    |> Map.put(:participant_matches, participant_matches)
    |> Map.put(:period, period)
    |> Map.put(:count, count)
    |> Map.put(:match_region, match_region)

    Process.send_after(self(), :follow, polling_period())

    {:noreply, state}
  end

  def handle_info(:follow, %{count: count, participant_matches: participant_matches, match_region: match_region} = state) do
    count = count - 1
    Logger.info(":follow... count(#{count})")
    participant_matches = participant_matches
    |> Enum.map(fn %{puuid: puuid, name: name, matches: matches} = participant ->
      case riot_api().fetch_matches(puuid, match_region) do
        {:ok, match_ids} ->
          new_matches = match_ids -- matches

          new_matches |> Enum.each(fn match_id ->
            IO.puts("Summoner <#{name}> completed match <#{match_id}>")
          end)

          updated_matches = matches ++ new_matches

#          IO.puts("#{name}, matches(#{matches |> Enum.join(",")}), updated_matches(#{updated_matches |> Enum.join(",")})")

          participant |> Map.put(:matches, updated_matches)

        {:error, :rate_limit_exceeded} ->
          participant
      end
    end)

    state = state
    |> Map.put(:count, count)
    |> Map.put(:participant_matches, participant_matches)

    # TODO: Putting timing adjustments into this...
    if count > 0 do
      IO.puts("rescheduling work...")
      Process.send_after(self(), :follow, polling_period())
    end

    {:noreply, state}
  end

  defp polling_period() do
    Application.get_env(:ten_summoners_tales, :polling_period, 1_000)
  end

  defp poll_count() do
    Application.get_env(:ten_summoners_tales, :polling_count, 60)
  end

  defp riot_api() do
    Application.get_env(:ten_summoners_tales, :service_client, TenSummonersTales.RiotApiClient)
  end
end
