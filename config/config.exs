import Config

config :ten_summoners_tales,
       riot_development_api_key: "RGAPI-58d010ed-666a-499a-9a0d-d4e10737ca42",
       riot_development_api_host: "api.riotgames.com",
       riot_development_api_summoner_path: "/lol/summoner/v4/summoners/by-name/",
       riot_development_api_match_path: "/lol/match/v5/matches/by-puuid/{puuid}/ids"

#config :ten_summoners_tales,
#  http_adapter: HTTPoison
