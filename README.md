# TenSummonersTales

Implementation to track Summoner's game play in the Riot Developer API.

## High level logic flow

![Summoner Lookup Sequence](./docs/summoner_lookup_sequence.svg)

## Running

```bash
iex -S mix

iex(1)> TenSummonersTales.track_summoner("ciroque", "NA")
```

## NOTES
- Going to need a map between the regions for the Summoner API and the Match API
  - The AMERICAS routing value serves NA, BR, LAN, LAS, and OCE. 
  - The ASIA routing value serves KR and JP. 
  - The EUROPE routing value serves EUNE, EUW, TR, and RU.
  
  [BR1, EUN1, EUW1, JP1, KR, LA1, LA2, NA1, OC1, RU, TR1]
- 
