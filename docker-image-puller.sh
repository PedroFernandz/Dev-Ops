#!/bin/bash

# Define a Personal Access Token for authentication with GitLab
declare -r AccessToken='XXXXXXXX'

# Specify the GitLab Project ID where the Docker images are hosted
declare -r ProjectId='219'

# Function to retrieve a list of Docker repositories from GitLab
getDockerRepos() {
    # Use cURL to make an API request to GitLab and retrieve repository IDs
    curl -s "https://your.gitdomain.com/api/v4/projects/${ProjectId}/registry/repositories?per_page=100&private_token=${AccessToken}" | jq -r '.[] | .id'
}

# Function to retrieve tags for a specific Docker repository
getTagsFromRepo() {
    local repoId=$1

    # Use cURL to fetch the tags associated with the specified repository
    curl -s "https://your.gitdomain.com/api/v4/projects/${ProjectId}/registry/repositories/${repoId}/tags?per_page=100&private_token=${AccessToken}" | jq -r '.[].location'
}

# Function to download Docker images for a given repository and its tags
downloadDockerImages() {
    local repoId=$1
    local tags=($(getTagsFromRepo $repoId))

    # Iterate through the tags and pull Docker images one by one
    for tag in "${tags[@]}"; do
        echo "Fetching tags from repository: $repoId"
        echo "Downloading image: ${tag}"
        docker pull "${tag}"
    done
}

# Main function
main() {
    local repos=($(getDockerRepos))

    # Iterate through the list of repositories and download their images
    for repoId in "${repos[@]}"; do
        downloadDockerImages $repoId
    done
}

# Execute the main function to start the script
main

docker-image-puller.sh
