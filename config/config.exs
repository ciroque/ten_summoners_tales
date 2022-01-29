import Config

config :ten_summoners_tales,
       riot_development_api_key: System.get_env("RIOT_API_KEY"),
       riot_development_api_host: "api.riotgames.com",
       riot_development_api_summoner_path: "/lol/summoner/v4/summoners/by-name/",
       riot_development_api_matches_path: "/lol/match/v5/matches/by-puuid/{puuid}/ids",
       riot_development_api_match_path: "/lol/match/v5/matches/{matchId}",
       polling_period: 60 * 1000,
       polling_count: 60

