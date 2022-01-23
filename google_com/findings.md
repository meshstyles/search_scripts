# Google (re)search

## baseurl

`https://www.google.com/search?q=${query}${timeframe}&dpr=1"`

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
this `timefilter` `&tbs=qdr:${fimefilter}` uses these timeframes

| timeframe  | filter      |
| ---------- | ----------- |
| last hour  | h           |
| last month | m           |
| last day   | d           |
| last year  | y           |
| last week  | w           |
| all        | leave blank |

# search path [pup]

`div#search div#rso div.g div.jtfYYd div.NJo7tc div.yuRUbf a attr{href}`

this will return possibly multiple results: the real link, webcache, translate, #

`:parent-of([class="LC20lb MBeuO DKV0Md"]) attr{href}` alternatively this could also be used since it only returns the matches.
