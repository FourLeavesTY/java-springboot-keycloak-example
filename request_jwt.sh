#!/bin/bash

response=$(curl -s -X POST "http://localhost:9941/realms/myrealm/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=defaultuser" \
  -d "password=password" \
  -d "grant_type=password" \
  -d "client_id=java-app")

JWT=$(echo $response | jq -r '.access_token')

export JWT

echo "Access Token: $JWT"
