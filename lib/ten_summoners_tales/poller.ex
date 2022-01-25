defmodule TenSummonersTales.Poller do
  @moduledoc """
    This module implements the TemSummonersTales.PollerBehaviour to allow polling Summoners from the TODO [API name]
  """

  require Logger

  @behaviour TenSummonersTales.SummonerFetchBehaviour

  use GenServer

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

  def fetch_summoners_opponents(summoner_id, polling_period \\ 60_000, poll_count \\ 60) do
    Logger.info("fetch_summoners_opponents : #{summoner_id}")

    # TODO: Fetch the list of recent summoners
    summoners = []

    summoners_matches = summoners |> Enum.map(fn summoner -> %{summoner: summoner, opponents: %{}} end)

    # kick off the polling process
    Process.send(__MODULE__, {:follow, summoners, polling_period, poll_count, summoners_matches}, [])

    {:ok, summoners}
  end
end

##
