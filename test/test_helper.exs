ExUnit.start()

Mox.defmock(Http.Mock, for: TenSummonersTales.HttpBehaviour)
Mox.defmock(TenSummonersTales.RetrieveSummonerMock, for: TenSummonersTales.RetrieveSummonerBehaviour)
Mox.defmock(TenSummonersTales.TrackSummonerMock, for: TenSummonersTales.TrackSummonerBehaviour)
Mox.defmock(TenSummonersTales.RiotDevelopmentClientMock, for: TenSummonersTales.ServiceClientBehaviour)

Application.put_env(:ten_summoners_tales, :http_adapter, Http.Mock)
Application.put_env(:ten_summoners_tales, :retriever, TenSummonersTales.RetrieveSummonerMock)
Application.put_env(:ten_summoners_tales, :tracker, TenSummonersTales.TrackSummonerMock)
Application.put_env(:ten_summoners_tales, :service_client, TenSummonersTales.RiotDevelopmentClientMock)

Application.put_env(:ten_summoners_tales, :riot_development_api_key, ";kajnervpaiuernv;piuabn2345r;likubn")
