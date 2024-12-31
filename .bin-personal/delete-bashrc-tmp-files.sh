#!/bin/bash

# Find and remove bash_history.tmp files
find ~ -maxdepth 1 -name '.bash_history-*.tmp' -delete
