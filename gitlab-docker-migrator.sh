    #!/bin/bash

## Personal access token for GitLab API
declare -r AccessToken='XXXXX'

### Variables to define the source and destination project paths for docker migrations
declare -r originProj=1306
declare -r originProjPath="path/origin"
declare -r destProjPath="path/dest"

# Associative array to store repository details
declare -A Repositories
# Arrays to store tags and docker images
declare -a Tags=()
declare -a Dockers=()

# Function to get a list of repositories from the GitLab registry
getReposList() {
    # Using curl to fetch repository data and jq to parse JSON
    declare -a repos=( $(curl -s "https://your.gitdomain.com/api/v4/projects/${originProj}/registry/repositories?per_page=100&access_token=${AccessToken}"  | jq '.[] | "\(.id):\(.location)"  ' -r ) )

    # Loop through the repositories to populate the Repositories array
    for repo in ${repos[@]}; do
        Repositories[${repo%%:*}]=${repo#*:}
    done
    return 0
}

# Function to get tags for a repository
getTags() {
    # Fetch and parse tag data using curl and jq
    Tags=( $(curl -s "https://your.gitdomain.com/api/v4/projects/${originProj}/registry/repositories/${repo}/tags?per_page=100&access_token=${AccessToken}"  | jq '.[].name' -r) )
    return 0
}

# Function to filter and modify docker image names
filterShostingDockers() {
    # Check if destination Docker image matches a specific pattern and modify it
    [[ "${destDocker}" =~ ${destProjPath}/php-[0-9].[0-9] ]] \
        && destDocker=${destDocker/shosting-php-fpm/shosting-php-fpm/jail}

    # Further pattern matching and modifications for 'jb-shosting' images
    [[ "${destDocker}" =~ ${destProjPath}/jb-shosting ]] \
        && {
            phpVer=${destDocker##*:}
            tag=${phpVer/[0-9].[0-9]/}
            tag=${tag/dev-/}
            tag=${tag#.}

            destDocker="${destDocker/jb-shosting-ssh:/ssh}"
            destDocker="${destDocker/jb-shosting:/fpm}"
            destDocker="${destDocker%%[0-9].[0-9]*}"
            destDocker="${destDocker/dev-/}/${phpVer/.${tag:-latest}/}:${tag:-latest}"
        }

    # Handle cases where the Docker image name contains '/dev-' and modify accordingly
    [[ "${destDocker}" =~ ${destProjPath}/(ssh|fpm)/dev- ]] \
        && destDocker="${destDocker/\/dev-//}-dev"

    # Adjust Docker image names that match a specific date-based development tag format
    [[ "${destDocker}" =~ ${destProjPath}/(ssh|fpm|jail)/.*:[0-9]*-dev-[0-9]{8} ]] \
        && destDocker="${destDocker/-dev-/-}-dev"

    return 0
}

# Function to migrate docker images
migrateDockers() {
    # Loop through each docker image
    for d in ${Dockers[@]} ; do
        # Replace origin project path with destination project path in docker image name
        destDocker=${d/${originProjPath/\//\\\/}/${destProjPath}}
        # Call function to filter and modify docker image names
        filterShostingDockers
        # Log the migration process
        echo -e "${d} \t » ${destDocker}"

        # Pull the docker image, tag it with the new name, and push it to the registry
        docker pull ${d} || return 1
        docker tag ${d} ${destDocker}
        docker push ${destDocker} || return 1
        echo -e " * ${d} » ${destDocker} : Ok"
    done

    return 0
}

# Main script execution starts here
# Get the list of repositories
getReposList

# Loop through repositories to get tags and prepare docker images list
for repo in ${!Repositories[@]} ; do
    getTags
    for tag in ${Tags[@]}; do
        Dockers+=( ${Repositories[$repo]}:${tag} )
    done
    # Logging the progress
    echo -e "${#Dockers[@]}\t| $repo » ${Repositories[$repo]} \n\t|    »» ${Tags[@]} \n"
done

# Begin the migration of Docker images
echo -e "\n\tMigrate Dockers (${#Dockers[@]}): \n"
migrateDockers


gitlab-docker-migrator.sh
