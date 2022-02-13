#!/bin/bash

echo -n "Bearer: "
read -r bearer
echo -n "Username: "
read -r username
echo -n "Delay (in sec): "
read -r delay
curl_out="$(curl -s https://api.coolkidmacho.com/droptime/$username)"
echo "[DEBUG] curl output: $curl_out"
droptime_unix="$(echo $curl_out | jq '.UNIX')"
curr_unix="$(date +%s%N | cut -b1-13)"
droptime="$(expr $( expr $droptime_unix \* 1000 ) - $curr_unix)"
sleepTime="$(echo "$droptime / 1000" | bc -l)"
echo "Drop time: $sleepTime"
waitTime="$(echo $sleepTime - $delay | bc -l)"
echo "Waiting: $waitTime"
sleep $waitTime
( curl -I -X PUT --header "Bearer $bearer" "https://api.minecraftservices.com/minecraft/profile/name/$username" | tee request1.log ; date +%s%N | cut -b1-13 ) &
curl -I -X PUT --header "Bearer $bearer" "https://api.minecraftservices.com/minecraft/profile/name/$username" | tee request2.log
date +%s%N | cut -b1-13