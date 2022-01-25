defmodule TenSummonersTales.RiotApiClientTest do
  use ExUnit.Case, async: true

  alias TenSummonersTales.RiotApiClient

  alias Http.Mock, as: MockHttp

  import Mox

  @moduletag :capture_log

  doctest RiotApiClient

  setup :verify_on_exit!

  test "module exists" do
    assert is_list(RiotApiClient.module_info())
  end

  describe "fetch_summoner/2" do
    test "assembles host correctly" do

      expect(MockHttp, :get, fn url, headers ->
        assert url == "https://NA1.api.riotgames.com/lol/summoner/v4/summoners/by-name/summoner"
#        assert headers[0] == "X-Riot-Token"
      end)

      RiotApiClient.fetch_summoner("summoner", "NA1")
    end
  end
end
