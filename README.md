# TenSummonersTales

Implementation to track Summoner's game play using the Riot Developer API.

## High level logic flow

![Summoner Lookup Sequence](./docs/summoner_lookup_sequence.svg)

## Run

```bash
git clone git@github.com:ciroque/ten_summoners_tales.git

cd ten_summoners_tales

mix deps.get

iex -S mix

iex(1)> TenSummonersTales.track_summoner("ciroque", "qwerty")
iex(1)> TenSummonersTales.track_summoner("ciroque", "na1")
iex(1)> TenSummonersTales.track_summoner("boycold", "na1")
```

## TODO
- More testing, especially around error conditions
- 
