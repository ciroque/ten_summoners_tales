defmodule TenSummonersTales.StandardPoller do
  @moduledoc """
    This module implements the TemSummonersTales.PollerBehaviour to allow polling Summoners from the TODO [API name]
  """

  @behaviour TenSummonersTales.PollerBehaviour

  use GenServer

  def start_link(state, opts) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  def follow_summoner(summoner_id, polling_period = 60_000, poll_count = 60) do
    {:ok}
  end
end
