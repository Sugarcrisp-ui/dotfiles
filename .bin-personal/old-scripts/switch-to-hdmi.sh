#!/bin/bash

echo "Setting HDMI sink as default..."
pactl set-default-sink alsa_output.pci-0000_00_1f.3.hdmi-stereo

echo "Moving streams to HDMI sink..."
while read stream; do
  if [ -z "$stream" ]; then
    break
  fi
  pactl move-sink-input "$stream" alsa_output.pci-0000_00_1f.3.hdmi-stereo
done < <(pactl list short sink-inputs)
