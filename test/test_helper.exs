ExUnit.start()

Mox.defmock(TenSummonersTales.RiotDevelopmentClientMock, for: TenSummonersTales.ServiceClientBehaviour)
Mox.defmock(Http.Mock, for: TenSummonersTales.HttpBehaviour)

Application.put_env(:ten_summoners_tales, :http_adapter, Http.Mock)
Application.put_env(:ten_summoners_tales, :service_client, TenSummonersTales.RiotDevelopmentClientMock)
