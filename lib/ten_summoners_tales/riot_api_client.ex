defmodule TenSummonersTales.RiotApiClient do
  @moduledoc false

  @behaviour TenSummonersTales.ServiceClientBehaviour

  require Logger

  @impl true
  @doc """

    ## Examples
      `TenSummonersTales.RiotApiClient.fetch_match("NA1_4187683997", "AMERICAS")`
  """
  def fetch_match(match_id, region) do
    url(region, match_by_id_path(match_id)) |> fetch()
  end

  @impl true
  @doc """

    ## Examples
      `TenSummonersTales.RiotApiClient.fetch_matches("Q2OArd-PlZFka3pmtHfXrjY9M8nAlRtfa8iCb_c3Jk5kXmDAKxjy7U4DpT5Hcm-6WQvaX4lVfEFbCQ", "AMERICAS")`
  """
  def fetch_matches(puuid, region, match_count \\ 5)

  def fetch_matches(puuid, region, :all_matches) do
    matches_by_puuid_path(puuid) |> fetch_the_matches(region)
  end

  def fetch_matches(puuid, region, match_count) do
    matches_by_puuid_path(puuid, match_count) |> fetch_the_matches(region)
  end

  @impl true
  @doc """

    ## Examples
      `TenSummonersTales.RiotApiClient.fetch_summoner("ciroque", "na1")`
  """
  def fetch_summoner(summoner_name, region) do
    url(region, summoner_name_path(summoner_name)) |> fetch()
  end

  defp fetch(url) do
    url
    |> http_adapter().get(riot_api_key_header())
    |> handle_response()
  end

  defp fetch_the_matches(url, region) do
    url(region, url) |> fetch()
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code, body: body}}) do
    case status_code do
      status_code when status_code == 200 -> {:ok, parse_body(body)}
      status_code when status_code == 400 ->
        Logger.error("#{__MODULE__} Invalid Request") # TODO: add correlation id
        {:error, :invalid_request}
      status_code when status_code == 403 ->
        Logger.error("#{__MODULE__} Unauthorized") # TODO: add correlation id
        {:error, :invalid_api_token}
      status_code when status_code == 429 ->
        Logger.error("#{__MODULE__} Exceeded rate limit") # TODO: add correlation id
        {:error, :rate_limit_exceeded}
    end
  end

  defp host(region) do
    host = Application.get_env(:ten_summoners_tales, :riot_development_api_host)
    "https://#{region}.#{host}"
  end

  defp http_adapter() do
    Application.get_env(:ten_summoners_tales, :http_adapter, HTTPoison)
  end

  defp match_by_id_path(matchId) do
    Application.get_env(:ten_summoners_tales, :riot_development_api_match_path)
    |> String.replace("{matchId}", matchId)
  end

  defp matches_by_puuid_path(puuid) do
    Application.get_env(:ten_summoners_tales, :riot_development_api_matches_path)
    |> String.replace("{puuid}", puuid)
  end

  defp matches_by_puuid_path(puuid, count) do
    "#{matches_by_puuid_path(puuid)}?count=#{count}"
  end

  defp parse_body(body) do
    with {:ok, body} <- Jason.decode(body, [keys: :atoms]) do
      body
    else
      _ -> body
    end
  end

  defp riot_api_key() do
    Application.get_env(:ten_summoners_tales, :riot_development_api_key)
  end

  defp riot_api_key_header() do
    ["X-Riot-Token": riot_api_key()]
  end

  defp summoner_name_path(summoner_name) do
    path = Application.get_env(:ten_summoners_tales, :riot_development_api_summoner_path)

    "#{path}#{summoner_name}"
  end

  defp url(region, path) do
    host = host(region)
    "#{host}#{path}"
  end
end
