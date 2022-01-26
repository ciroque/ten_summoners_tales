defmodule TenSummonersTales.RiotApiClient do
  @moduledoc false

  @behaviour TenSummonersTales.ServiceClientBehaviour

  @impl true
  @doc """
    TenSummonersTales.RiotApiClient.fetch_summoner("ciroque", "na1")
  """
  def fetch_summoner(summoner_name, region) do
    host = host(region)
    path = summoner_name_path(summoner_name)
    x_riot_token = ["X-Riot-Token": riot_api_key()]
    url = "#{host}#{path}"

    url
    |> http_adapter().get(x_riot_token)
    |> handle_response()
  end

  def riot_api_key() do
    Application.get_env(:ten_summoners_tales, :riot_development_api_key)
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code, body: body}})
    when status_code in [200],
    do: parse_body(body)

  defp parse_body(body) do
    with {:ok, body} <- Jason.decode(body, [keys: :atoms]) do
      body
    else
      _ -> body
    end
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
    Application.get_env(:ten_summoners_tales, :http_adapter, HTTPoison)
  end
end
