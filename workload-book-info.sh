#!/bin/bash

export LC_NUMERIC="en_US.UTF-8"

GATEWAY=${1}
TIMES=${2:-100}
EXPERIMENT_ID=${3:-no_id}


PRODUCT_PAGE_URL=${GATEWAY}/productpage

PRODUCT_PAGE_URL_OUTPUT="${EXPERIMENT_ID}_product_page"



function make_curl_request_and_save_times() {
	url=$1
	output_file_name=$2	
	
	curl_output=$(curl -w '\n time_namelookup: %{time_namelookup}s\n time_connect: %{time_connect}s\n time_appconnect: %{time_appconnect}s\n time_pretransfer: %{time_pretransfer}s\n time_redirect: %{time_redirect}s\n time_starttransfer: %{time_starttransfer}s\n ----------\n time_total: %{time_total}s\n' -o /dev/null -s ${url})
    
    	time_namelookup=$(echo "$curl_output" | grep "time_namelookup" | awk '{print $2}' | sed 's/s//')
    	time_connect=$(echo "$curl_output" | grep "time_connect" | awk '{print $2}' | sed 's/s//')
    	time_appconnect=$(echo "$curl_output" | grep "time_appconnect" | awk '{print $2}' | sed 's/s//')
    	time_pretransfer=$(echo "$curl_output" | grep "time_pretransfer" | awk '{print $2}' | sed 's/s//')
    	time_redirect=$(echo "$curl_output" | grep "time_redirect" | awk '{print $2}' | sed 's/s//')
    	time_starttransfer=$(echo "$curl_output" | grep "time_starttransfer" | awk '{print $2}' | sed 's/s//')
    	time_total=$(echo "$curl_output" | grep "time_total" | awk '{print $2}' | sed 's/s//')
    
    	echo "$time_namelookup,$time_connect,$time_appconnect,$time_pretransfer,$time_redirect,$time_starttransfer,$time_total" >> ${output_file_name}.csv
}



echo "Initializing csv output files"
echo "time_namelookup (seconds),time_connect (seconds),time_appconnect (seconds),time_pretransfer (seconds),time_redirect (seconds),time_starttransfer (seconds),time_total (seconds)" > ${INDEX_URL_OUTPUT}.csv


for ((i=1; i<=${TIMES}; i++)); do
	echo "Requesting product page"
	make_curl_request_and_save_times $PRODUCT_PAGE_URL $PRODUCT_PAGE_URL_OUTPUT
done

