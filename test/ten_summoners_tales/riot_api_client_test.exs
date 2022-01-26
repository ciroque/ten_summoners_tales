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
    test "assembles url correctly" do
      summoner_name = "summoner"
      response_body = "{\"id\":\"s_tnTARp5nndcFOl4tjOc3JxxIqoLJX-VwVHTBRXumBsa8k\",\"accountId\":\"WJIad3koRjnn6DlrGrxPsvTN1f8hFVMl_YxCLfDcFGtFXg\",\"puuid\":\"a6KL4-VnQsIu7KbHE4b2oOMyC21tKar_u33_5Qi-YwWnwq1oR8H934MnUSfFDu6DMKW0rQsWSUUq0Q\",\"name\":\"#{summoner_name}\",\"profileIconId\":12,\"revisionDate\":1495785743000,\"summonerLevel\":8}"

      expect(MockHttp, :get, fn url, headers ->
        assert url == "https://NA1.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{summoner_name}"
        assert headers[:"X-Riot-Token"] != nil

        {:ok, %HTTPoison.Response{status_code: 200, body: response_body}}
      end)

      %{name: name} = RiotApiClient.fetch_summoner(summoner_name, "NA1")

      assert name == summoner_name
    end
  end
end
