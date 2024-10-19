#!/bin/bash

echo $OWNER
echo $REPO

REG_TOKEN=$(curl -sX POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/${OWNER}/${REPO}/actions/runners/registration-token | jq .token --raw-output)

cd /home/$DOCKER_USER/action-runner

./config.sh --url https://github.com/${OWNER}/${REPO} --token ${REG_TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!