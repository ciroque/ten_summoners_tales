defmodule TenSummonersTales.SummonerTracker do
  @moduledoc """
    This module implements the TemSummonersTales.PollerBehaviour to allow polling Summoners from the TODO [API name]
  """

  @behaviour TenSummonersTales.TrackSummonerBehaviour

  require Logger

  use GenServer

  ## ###################################################################################################################
  ## Public API

  @doc """
    TenSummonersTales.SummonerTracker.track_summoners([])
  """
  def track_summoners(participant_matches, match_region) do
    GenServer.cast(__MODULE__, {:track, participant_matches, match_region, polling_period(), poll_count()})
  end

  ## ###################################################################################################################
  ## GenServer callbacks

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

    Process.send_after(self(), :track, polling_period())

    {:noreply, state}
  end

  def handle_info(:track, %{count: count, participant_matches: participant_matches, match_region: match_region} = state) do
    IO.puts("#{DateTime.utc_now} Polling...")
    count = count - 1

    started = :os.system_time(:millisecond) # Poor man's drift compensation, meh.
    participant_matches = participant_matches |> update_matches(match_region)
    drift_correction = :os.system_time(:millisecond) - started

    state = state
    |> Map.put(:count, count)
    |> Map.put(:participant_matches, participant_matches)

    # TODO: Putting timing adjustments into this...
    # This will suffer from drift as the length of the calls to the Riot API fluctuate.
    # Could consider `spawn_link`, would then have to figure out how to handle updating state
    # Could also simply grab the time before and after calling `retrieve_new_matches` and subtracting the difference from the polling_period()
    if count > 0 do
      Process.send_after(self(), :track, polling_period() - (drift_correction))
    else
      IO.puts("Tracking complete.")
    end

    {:noreply, state}
  end

  ## ###################################################################################################################
  ## Privates

  defp poll_count() do
    Application.get_env(:ten_summoners_tales, :polling_count, 60)
  end

  defp polling_period() do
    Application.get_env(:ten_summoners_tales, :polling_period, 60 * 1_000)
  end

  defp update_matches(participant_matches, match_region) do
    participant_matches
    |> Enum.map(fn %{puuid: puuid, name: name, matches: matches} = participant ->
      :timer.sleep(80) ## TODO: Poor mans throttling, ideally the requests would be put into batches and throttled...
      case riot_api().fetch_matches(puuid, match_region, :all_matches) do
        {:ok, match_ids} ->
          new_matches = match_ids -- matches

          new_matches |> Enum.each(fn match_id ->
            IO.puts("Summoner <#{name}> completed match <#{match_id}>")
          end)

          participant |> Map.put(:matches, matches ++ new_matches)

        {:error, :rate_limit_exceeded} ->
          Logger.warn("Rate limit exceeded, subsequent Summoners may not be updated on this poll")
          participant
      end
    end)
  end

  defp riot_api() do
    Application.get_env(:ten_summoners_tales, :service_client, TenSummonersTales.RiotApiClient)
  end
end
