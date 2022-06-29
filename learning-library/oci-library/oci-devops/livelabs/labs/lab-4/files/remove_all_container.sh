#!/bin/bash

if [ -z "`docker ps -qa`" ]; then
    echo "No Docker Container Running"
else
    docker rm -f $(docker ps -qa)
fi