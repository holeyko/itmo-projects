#!/bin/bash

# 1) Сделал 2 разных POST запроса в Google Chrome
# 2) Сделал diff разных запросов
# 3) Написал bash скрипт

for i in {1..100}
do
    square=$((i*i))
    curl 'http://1d3p.wp.codeforces.com/new' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
    -H 'Accept-Language: en-US,en;q=0.9,ru-RU;q=0.8,ru;q=0.7' \
    -H 'Cache-Control: max-age=0' \
    -H 'Connection: keep-alive' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'Cookie: __utmc=71512449; evercookie_png=bocggk8fogsjx90uom; evercookie_etag=bocggk8fogsjx90uom; evercookie_cache=bocggk8fogsjx90uom; 70a7c28f3de=bocggk8fogsjx90uom; __utma=71512449.1969037220.1663256726.1663259054.1663315680.3; __utmz=71512449.1663315680.3.2.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); JSESSIONID=D5959CCB90C2FFFB4D045C6FFEFC23EB' \
    -H 'Origin: http://1d3p.wp.codeforces.com' \
    -H 'Referer: http://1d3p.wp.codeforces.com/' \
    -H 'Upgrade-Insecure-Requests: 1' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36' \
    --data-raw "_af=34be50b38beccce4&proof=${square}&amount=${i}&submit=Submit" \
    --compressed \
    --insecure
done
