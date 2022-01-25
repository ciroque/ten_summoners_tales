defmodule TenSummonersTales.RiotApiClient do
  @moduledoc false

  @behaviour TenSummonersTales.ServiceClientBehaviour

  @impl true
  def fetch_summoner(summoner_name, region) do
    host = host(region)
    path = summoner_name_path(summoner_name)
    x_riot_token = ["X-Riot-Token": riot_api_key()]
    url = "#{host}#{path}"

    http_adapter().get(url, x_riot_token)
  end

  def riot_api_key() do
    Application.get_env(:ten_summoners_tales, :riot_development_api_key)
  end

  defp host(region) do
    host = Application.get_env(:ten_summoners_tales, :riot_development_api_host)
    "https://#{region}.#{host}"
  end

  def summoner_name_path(summoner_name) do
    path = Application.get_env(:ten_summoners_tales, :riot_development_api_summoner_path)

    "#{path}#{summoner_name}"
  end

  defp http_adapter() do
    Application.get_env(:ten_summoners_tales, :http_adapter)
  end
end
