#!/bin/bash

# Contains:
#	get_cont_pid()

# Finds PID of particular container
# Accepts:      $1 - container id, name, or other identifier
# Returns:      $PID - pid of container on success
#               1 - could not poll docker for container id
#               2 - could not find pid in results
#               -1 - unknown, should not be reached
get_cont_pid () {
	cid="${1}"

	result=$(docker inspect "${cid}" -f '{{.State.Pid}}')
	if [[ $? -ne 0 ]]; then
		return 1
	fi

	cpid=$(echo ${result} | grep "Pid" | sed 's/.*\"Pid\":\s//g' | sed 's/,.*//g')
	if [[ -z $cpid ]]; then
		return 2
	else
		return "${cpid}"
	fi

	return -1
}
