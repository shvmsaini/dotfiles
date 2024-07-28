#!/bin/bash

# Perform triple left click
# xdotool click 1 4
for j in {1..10}; do
  for i in {1..3}; do
    xdotool click 1
      sleep 0.1
  done

  # Wait for 0.2 seconds (200 milliseconds)
  sleep 0.2

  # Simulate Ctrl+V keypress
  xdotool key ctrl+v

  sleep 0.2

  xdotool click 5

done
