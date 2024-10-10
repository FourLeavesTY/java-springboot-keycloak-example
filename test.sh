#!/bin/bash

response=$(curl -s -X POST "http://localhost:9941/realms/myrealm/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=defaultuser" \
  -d "password=password" \
  -d "grant_type=password" \
  -d "client_id=java-app")

JWT=$(echo $response | jq -r '.access_token')

echo "Access Token: $JWT"
echo ""

function make_request() {
    local url=$1
    local token=$2
    temp_file=$(mktemp)

    if [ -z "$token" ]; then
        response=$(curl -s -o "$temp_file" -w "%{http_code}" "$url")
    else
        response=$(curl -s -o "$temp_file" -w "%{http_code}" -H "Authorization: Bearer $token" "$url")
    fi

    echo "Url: $url"
    echo "HTTP Status Code: $response"
    echo "Response: $(cat "$temp_file")"
    rm "$temp_file"
}

make_request "http://localhost:9942" ""
make_request "http://localhost:9942/protected/premium" ""
make_request "http://localhost:9942/protected/premium" "$JWT"
make_request "http://localhost:9942/protected/users" "$JWT"
