#!/bin/bash
# title           :testLoadBalancerWeights.sh
# description     :Test a load balancer's pool origin weights for a given hostname.
# author          :Nathan Rosa
# date            :21/2/2019
# version         :0.1
# usage           :bash testLoadBalancerWeights.sh <LB_HOSTNAME>
# notes           :Install Vim and Emacs to use this script.
# bash_version    :^4.0.0+
# ==============================================================================

declare -A COUNTER=()
SUM=0
GLB_HOSTNAME=$1
# Save cursor position
tput sc
while true; do
  ADDRESS=$(dig +short $GLB_HOSTNAME | tr '\r\n' '|');
  if [[ -v COUNTER[$ADDRESS] ]]; then
    COUNTER[$ADDRESS]=$(( COUNTER['$ADDRESS'] += 1 ));
  else
    COUNTER[$ADDRESS]=1;
  fi
  # Total number of requests
  SUM=$(( SUM += 1 ))
  # Return to the saved cursor position
  tput rc;
  # Clear the screen from cursor to bottom
  tput ed;
  for KEY in "${!COUNTER[@]}"; do
    RATIO="${COUNTER[$KEY]}/$SUM";
    PERCENTAGE=$(echo "scale=2; $RATIO" | bc);
    echo -e "WEIGHT: $PERCENTAGE --- $KEY --- ${COUNTER[$KEY]}";
  done
  sleep 1;
done