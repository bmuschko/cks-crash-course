#!/usr/bin/env bash

# Wait for control-plane node to transition into the "Ready" status
while true; do 
  JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}' && kubectl get nodes -o jsonpath="$JSONPATH" | grep "Ready=True" | grep "Ready=True" &> /dev/null
  if [[ "$?" -ne 0 ]]; then
    sleep 5
  else
    break
  fi
done

kubectl run network-call --image=alpine/curl:3.14 -- /bin/sh -c 'while true; do ping -c 1 google.com; sleep 5; done'
