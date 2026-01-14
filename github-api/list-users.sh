#!/bin/bash

API_URL="https://api.github.com"

# Fail if env variables are missing
: "${username:?Environment variable username not set}"
: "${token:?Environment variable token not set}"

USERNAME="$username"
TOKEN="$token"

REPO_OWNER="$1"
REPO_NAME="$2"

function github_api_get {
    local endpoint="$1"
    curl -s -u "${USERNAME}:${TOKEN}" \
         -H "Accept: application/vnd.github+json" \
         "${API_URL}/${endpoint}"
}

function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    collaborators=$(github_api_get "$endpoint" | jq -r '.[].login')

    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
