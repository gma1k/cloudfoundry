#!/bin/bash

SPACES=($(cf spaces | awk '{print $1}' | tail -n +4))

echo "Choose a space:"
echo "0) All spaces"
for i in "${!SPACES[@]}"; do
  echo "$((i+1))) ${SPACES[$i]}"
done

read -p "Enter space number: " SPACE_NUMBER

if [ $SPACE_NUMBER -eq 0 ]; then
  for space in "${SPACES[@]}"; do
    echo "Space: $space"
    cf target -s $space
    APPS=($(cf apps | awk '{print $1}' | tail -n +5))
    for app in "${APPS[@]}"; do
      echo "  App: $app"
      DOCKER_CONTAINERS=$(cf curl /v3/apps/$(cf app $app --guid)/relationships/containers | jq -r '.data[].guid')
      if [[ -z "$DOCKER_CONTAINERS" ]]; then
        echo "    No Docker containers found for this app."
      else
        for container in $DOCKER_CONTAINERS; do
          echo "    Container ID: $container"
          env=$(docker inspect $container | grep JAVA_HOME)
          if [[ -z "$env" ]]; then
            echo "    Java is not defined in the environment of this container."
          else
            echo "$env"
          fi
        done
      fi
    done
  done
else
  SPACE_INDEX=$((SPACE_NUMBER-1))
  SPACE=${SPACES[$SPACE_INDEX]}
  echo "Space: $SPACE"
  cf target -s $SPACE
  APPS=($(cf apps | awk '{print $1}' | tail -n +5))
  for app in "${APPS[@]}"; do
    echo "  App: $app"
    DOCKER_CONTAINERS=$(cf curl /v3/apps/$(cf app $app --guid)/relationships/containers | jq -r '.data[].guid')
    if [[ -z "$DOCKER_CONTAINERS" ]]; then
      echo "    No Docker containers found for this app."
    else
      for container in $DOCKER_CONTAINERS; do
        echo "    Container ID: $container"
        env=$(docker inspect $container | grep JAVA_HOME)
        if [[ -z "$env" ]]; then
          echo "    Java is not defined in the environment of this container."
        else
          echo "$env"
        fi
      done
    fi
  done
fi
