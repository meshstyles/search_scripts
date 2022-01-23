# search scripts

these are search scripts that were made to be static search terms automated with cronjobs.
The new results are written to a file to keep track of what already has been found and there are sample implementations of the discord.sh and telegram.sh scripts.
This allows for the results to be posted into discord channels via webhook and telegram chats/groups via bot.

## how to use

both scripts are contain helpful comment but simply speaking:

-   edit the search_site and query to adjust what should be searched
    -   leave query blank if you just want to see the result of the site
    -   leave search_site blank if you just want to search for a term
    -   search_site may not need to include the `site:` keyword
-   edit the timeframe to change the timeframe of the results
-   enter the tokens for the service you want to use and leave the others as is
    -   if the token is left as is the scripts will not be called
    -   to use the scripts the must be `on path` or a path/to/script must be edited in
    -   to not use either discord.sh or telegram.sh just leave them as is

## why is there no X script

the selection of search engines used is a product of them being commonly used and therefore the results being relevant to know. Generally other search engines aren't used locally. Alternative search engines like DuckDuckGo and Yahoo search use data from Bing and therefore are already covered. Bing was used instead of DuckDuckGo because it's easier to use.

### Yandex

Yandex uses captchas which practically work as rate limiters, and partial functionality is not worth the development time.

### Sogou, Baidu and co.

The results are heavily filtered and aren't relevant to most people.
if there is no rate limiting you can add them if you like.
