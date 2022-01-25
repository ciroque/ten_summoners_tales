ExUnit.start()

Mox.defmock(Http.Mock, for: TenSummonersTales.HttpBehaviour)
Application.put_env(:ten_summoners_tales, :http_adapter, Http.Mock)
