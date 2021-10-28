#!/bin/bash

# run_check.sh creates a file and appends to it whenever it runs

touch /tmp/run_checker.log

echo $(date) > /tmp/run_checker.log
