#!/bin/bash

SCRIPT=${SCRIPT:-./scripts/full_flow_docker_min.sh}

COMMAND="$SCRIPT"
for var in "$@"
do
    COMMAND="$COMMAND '$var'"
done
echo COMMAND=$COMMAND

IMAGE=${IMAGE:-philippvk/isaac-quickstart-min:latest}
CONFIG=${CONFIG:-cfg/flow/paper/cva5_reuseio.env}

WATCH=${WATCH:-0}

DISTINCT_ID=$RANDOM
echo DISTINCT_ID=$DISTINCT_ID

gh workflow run cicd.yml -f command="$COMMAND" -f distinct_id=$DISTINCT_ID -f docker-image=$IMAGE -f config=$CONFIG

sleep 5

RUN_ID=$(gh run list --workflow="cicd.yml" --json name,databaseId | jq "[.[] | select(.name | test(\"\\\\[${DISTINCT_ID}\\\\]\$\"))] | .[0].databaseId")
echo RUN_ID=$RUN_ID

if [[ "$WATCH" == "1" ]]
then
    gh run watch $RUN_ID
fi
