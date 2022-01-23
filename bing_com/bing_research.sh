#!/bin/bash

# ATTENTION don't forget to set your discord.sh and/or telgram.sh settings down there

# query
# if you don't want to search on a specific site than clear out search_site
# this will result in more results which will make it more likely to get rate limited
search_site="wikipedia.org"
query="Linux"

# | timeframe  | filter                |   
# | ---------- | --------------------- |   | past month | ez3                   |
# | past 24h   | ez1                   |   | past year  | ez5 (unsure)          |
# | past week  | ez2                   |   | all        | not include that part |

# recomended:ez3 for low frequency updates
timeframe='ez3'

# Notification tool settings
## discord
discord_webhook="WEBHOOK GOES HERE"
# insert any url for images here 
avatar_url="https://avatars.githubusercontent.com/u/31791872?s=200"
## telegram
TELEGRAM_TOKEN="TOKEN GOES HERE"
TELEGRAM_CHAT="CHAT ID GOES HERE"

# useragent to be used
useragent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36 OPR/82.0.4227.23"

# if the search site is empty just pass query else put the site:searchsite infront of it
if [[ "$search_site" != "" ]]; then
    if [[ "$query" != "" ]]; then
        search_request="site:${search_site}%20${query}"
    else
        search_request="site:${search_site}"
    fi
else
    search_request="${query}"
fi 

# timeframe input validation
if [[ "$timeframe" != "" ]]; then
    if [[ "$timeframe" == @(ez1|ez2|ez3|ez5) ]]; then
        echo "$(date): timeframe correctly set" >> $runtime_log
        echo "timeframe: $timeframe"
        timefilter="&filters=ex1%3a\"${timeframe}\""
    else
        # on bad input default timeframe 1 week is used
        echo "$(date): WARNING BAD timeframe set" >> $runtime_log
        echo "$(date): WARNING week set as timeframe" >> $runtime_log
        echo "WARNING BAD timeframe set"
        timefilter="&filters=ex1%3a\"ez2\""
    fi
else
    timefilter=""
    echo "timeframe: no timeframe set"
    echo "$(date +%s): no timeframe set"
fi

# escaping queries
query=$(echo "${query}" | sed "s/:/%3a/g ; s/\//%2f/g ; s/?/%3f/g ; s/&/%26/g ; s/=/%3d/g") 
echo "query: $query"

# file to contain old matches
# calculate queryhash; make folder and files if they don't exist
query_hash=$(echo "$query" | base64)
[ -d ~/.local/cache/ ] || mkdir ~/.local/cache/
old_matches_file="/home/$(whoami)/.local/cache/results_${query_hash}.match"
[ -f "$old_matches_file" ] || touch "$old_matches_file"
runtime_log="/home/$(whoami)/.local/cache/runtime_log_${query_hash}.log"
[ -f "$runtime_log" ] || touch "$runtime_log"

# adding new match to the old match file and posting
func_add_new() {
    echo "$new_url" >> $old_matches_file
    echo "$(date): sending messages with https://$new_url" >> $runtime_log
    echo "messages sent with link $new_url"
    
    if [[ "$discord_webhook" != 'WEBHOOK GOES HERE' ]]; then
        discord.sh --webhook-url="$discord_webhook" --text "https://$new_url" --avatar "$avatar_url"
    fi 

    if [[ "$TELEGRAM_TOKEN" != 'TOKEN GOES HERE' ]]; then
        telegram.sh -t "$TELEGRAM_TOKEN" -c "$TELEGRAM_CHAT" "https://$new_url"
    fi
}

# first page will always be fetched
func_search() {
    echo "https://www.bing.com$search_url"
    page=$(curl "https://www.bing.com$search_url" \
    -H 'authority: www.bing.com' \
    -H 'cache-control: max-age=0' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-arch: "x86"' \
    -H 'sec-ch-ua-bitness: "64"' \
    -H 'upgrade-insecure-requests: 1' \
    -H "user-agent: $useragent" \
    -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*' \
    -H 'sec-fetch-site: none' \
    -H 'sec-fetch-mode: navigate' \
    -H 'sec-fetch-user: ?1' \
    -H 'sec-fetch-dest: document' \
    -H 'accept-language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7' \
    --compressed)

    link_result_raw=$(echo "$page" | pup 'div#b_content ol#b_results li.b_algo h2 a attr{href}')
    
    SAVEIFS=$IFS   # Save current IFS
    IFS=$'\n'      # Change IFS to new line
    link_result_array=($link_result_raw)
    IFS=$SAVEIFS 

    #link_result_array
    for new_url in "${link_result_array[@]}"
    do
        # remove http or https (shouldn't need to but idk mabye comes in handy later)
        # sed statement remove all the stuff after last slash because we don't need more arguments in out life
        new_url=$( echo "${new_url#*://}" | sed 's:/*$::')
        sleep 2
        echo "$new_url"
        grep "$new_url" $old_matches_file > /dev/null || func_add_new 
    done

    ref_link=$( echo "$page" cat index.html | pup 'li.b_pag ul.sb_pagF li a.sb_pagN attr{href}' | sed 's/\&amp;/\&/g' )
    if [[ "$ref_link" != "" ]]; then
        search_url="$ref_link"
        echo "$search_url"
        func_search
    else
        echo "done"
    fi
}

# first page will always be fetched
search_url="/search?q=${search_request}${timefilter}"
echo "$search_url"
func_search

echo "$(date): done runnig bing" >> $runtime_log
