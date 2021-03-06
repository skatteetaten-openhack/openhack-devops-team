#!/bin/bash

declare -i duration=1
declare hasUrl=""
declare endpoint

usage() {
    cat <<END
    polling.sh [-i] [-h] endpoint
    
    Report the health status of the endpoint
    -i: include Uri for the format
    -h: help
END
}

while getopts "ih" opt; do 
  case $opt in 
    i)
      hasUrl=true
      ;;
    h) 
      usage
      exit 0
      ;;
    \?)
     echo "Unknown option: -${OPTARG}" >&2
     exit 1
     ;;
  esac
done

shift $((OPTIND -1))

if [[ $1 ]]; then
  endpoint=$1
else
  echo "Please specify the endpoint."
  usage
  exit 1 
fi 


healthcheck() {
    declare url=$1
    result=$(curl -i $url 2>/dev/null | grep HTTP/2)
    echo $result
}

while [[ true ]]; do
   sleep $duration
   status=$(curl -s -o /dev/null -w "%{http_code}" $endpoint) 
   
   curl_worked=$?

   if [[ $curl_worked -ne 0 ]]; then 
      status="N/A"
   else
      if [[ $status = 200  ]];
      then
        echo $status
        exit 0
      
      else
        echo $status
        exit 1
      fi

   fi 
   timestamp=$(date "+%Y%m%d-%H%M%S")
   if [[ -z $hasUrl ]]; then
     echo "$timestamp | $status "
   else
     echo "$timestamp | $status | $endpoint " 
   fi 
  
done