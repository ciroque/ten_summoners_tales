# TenSummonersTales

Implementation to track Summoner's game play in the [TODO] API.

## High level logic flow

![Polling Sequence](./docs/poller_sequence.svg)

## Running

```bash
iex -S mix

iex(1)> TenSummonersTales.Poller.fetch_summoners_opponents("ciroque", 500)
```



## NOTES
- Going to need a map between the regions for the Summoner API and the Match API
  - The AMERICAS routing value serves NA, BR, LAN, LAS, and OCE. 
  - The ASIA routing value serves KR and JP. 
  - The EUROPE routing value serves EUNE, EUW, TR, and RU.
  
  [BR1, EUN1, EUW1, JP1, KR, LA1, LA2, NA1, OC1, RU, TR1]
- 
