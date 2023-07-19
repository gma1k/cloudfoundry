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
    for app in $(cf apps | awk '{print $1}' | tail -n +5); do
      echo "  App: $app"
      env=$(cf env $app)
      if [[ $env == *"JAVA_HOME"* ]]; then
        echo "$env" | grep 'JAVA_HOME'
      else
        echo "Java is not defined in the environment of $app."
      fi
    done
  done
else
  SPACE_INDEX=$((SPACE_NUMBER-1))
  SPACE=${SPACES[$SPACE_INDEX]}
  echo "Space: $SPACE"
  cf target -s $SPACE
  for app in $(cf apps | awk '{print $1}' | tail -n +5); do
    echo "  App: $app"
    env=$(cf env $app)
    if [[ $env == *"JAVA_HOME"* ]]; then
      echo "$env" | grep 'JAVA_HOME'
    else
      echo "Java is not defined in the environment of $app."
    fi
  done
fi
