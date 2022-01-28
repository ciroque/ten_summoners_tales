defmodule TenSummonersTales.SummonerTracker do
  @moduledoc """
    This module implements the TemSummonersTales.PollerBehaviour to allow polling Summoners from the TODO [API name]
  """

  @behaviour TenSummonersTales.TrackSummonerBehaviour

  require Logger

  use GenServer

  def track_summoners(_summoners) do

  end

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_info({:follow, summoners, polling_period, poll_count, summoners_matches}, state) do
    Logger.info("#{poll_count} :follow...")
    IO.inspect(summoners_matches)

    # TODO: Putting timing adjustments into this...
    if poll_count > 0 do
      Process.send_after(self(), {:follow, summoners, polling_period, poll_count - 1, summoners_matches}, polling_period)
    end

    {:noreply, state}
  end
end
