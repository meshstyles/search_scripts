# Bing (re)search

## baseurl

`https://www.bing.com/search?q=${query}${timefilter}`

## query

`query` can be anything even site searches.  
site searches need to be escaped
quick overview, these will be escaped for you.

| letter | html escaped |
| ------ | ------------ |
| :      | %3a          |
| /      | %2f          |
| ?      | %3f          |
| &      | %26          |
| -      | %3d          |

## Timeframes

timeframes need to be set and the timefilter will be generated automatically.  
if the timeframe is not set, then timefilter will be empty.
this `timefilter` `&filters=ex1%3a\"${timeframe}\"` uses these timeframes

| timeframe  | filter                |
| ---------- | --------------------- |
| past 24h   | ez1                   |
| past week  | ez2                   |
| past month | ez3                   |
| past year  | ez5 (unsure)          |
| all        | not include that part |
