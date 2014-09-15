#!/bin/bash

# Contains:
#	stop_bridge()
#	create_bridge()
#	add_cont_int()
#	add_p2p_int()
#	clean_cont_int()

# Starts a new bridge interface, does not conern itself with docker or exitsing interfaces
# Accepts:	$1 - name of bridge interface
#		$2 - bridge ip/netmask in cidr form
# Returns:	0 - OK
#		1 - failed to create bridge
#		2 - failed to assign bridge ip range
#		3 - failed to set bridge up
#		-1 - unknown, should not be reached
create_bridge () {
	bname="${1}"
	bcidr="${2}"

	if [[ $(brctl addbr "${bname}") -ne 0 ]]; then
		return 1
	elif [[ $(ip addr add "${bcidr}" dev "${bname}") -ne 0 ]]; then
		return 2
	elif [[ $(ip link set dev "${bname}" up) -ne 0 ]]; then
		return 3
	else
		return 0
	fi

	return -1
}

# Stops and removes bridge interface, does not concern itself with docker or interfaces using it
# Accepts: bridge name to remove
# Returns:	0 - OK
#		1 - failed to down bridge
#		2 - failed to remove bridge
#		-1 - unknown, should not be reached
stop_bridge () {
	bname="${1}"

	if [[ $(ip link set dev "${bname}" down) -ne 0 ]]; then
		return 1
	elif [[ $(brctl delbr "${bname}") -ne 0 ]]; then
		return 2
	else
		return 0
	fi

	return -1
}

# Adds an interface to a socker container, on specified bridge
# Accepts	$1 - Name of interface inside container
#		$2 - Container PID
#		$3 - Container IP/subnet
#		$4 - Bridge name
#		$5 - Bridge IP
#		$6 - To default route or not to route... (anything works)
# Returns:	0 - OK
#		1 - Failed to find and create /var/run/netns
#		2 - Failed to find or create pid file
#		3 - Failed to create virt ints
#		4 - Failed to add host interface to bridge
#		5 - Failed to bring host interface up
#		6 - Failed to assign container interface to container
#		7 - Failed to assign proper name to container interface
#		8 - Failed to bring container interface up
#		9 - Failed to set container interface ip/subnet
#		10 - Failed to add route for container interface
#		-1 - unknown, should not be reached
add_cont_int () {
	cname="${1}"
	cpid="${2}"
	cip="${3}"
	bname="${4}"
	bip="${5}"
	route="${6}"
	hint="${cpid}-${RANDOM}"
	cint="${cpid}-${RANDOM}"

	if [[ ! -d "/var/run/netns/" ]] && [[ $(mkdir -p "/var/run/netns/") -ne 0 ]]; then
		return 1
	elif [[ ! -f "/var/run/netns/${cpid}" ]] && [[ $( ln -s /proc/$pid/ns/net /var/run/netns/$pid) -ne 0 ]]; then
		return 2
	elif [[ $(ip link add "${hint}" type veth peer name "${cint}") -ne 0 ]]; then
		return 3
	elif [[ $(brctl addif "${bname}" "${hint}") -ne 0 ]]; then
		return 4
	elif [[ $(ip link set "${hint}" up) -ne 0 ]]; then
		return 5
	elif [[ $(ip link set "${cint}" netns "${cpid}") -ne 0 ]]; then
		return 6
	elif [[ $(ip netns exec "${cpid}" ip link set dev "${cint}" name "${cname}") -ne 0 ]]; then
		return 7
	elif [[ $(ip netns exec "${cpid}" ip link set "${cname}" up) -ne 0 ]]; then
		return 8
	elif [[ $(ip netns exec "${cpid}" ip addr add "${cip}" dev "${cname}") -ne 0 ]]; then
		return 9
	elif [[ ! -z $route ]] &&  [[ $(ip netns exec "${cpid}" ip route add default via "${bip}") -ne 0 ]]; then
		return 10
	else
		return 0
	fi

	return -1
}

# Adds an interface between two containers directly
# Accepts:	$1 - Interface name on container 1
#		$2 - Container 1 pid
#		$3 - Interface IP on container 1
#		$4 - Interface name on container 2
#		$5 - Container 1 pid
#		$6 - Interface IP on container 2
# Returns:	0 - OK
#		1 - Failed to find and create /var/run/netns/
#		2 - Failed to find and create symlink for cpid1
#		3 - Failed to find and create symlink for cpid2
#		4 - Failed to create peered interfaces
#		5 - Failed to assign cint1 to cpid1
#		6 - Failed to assign address to cint1 within container 1
#		7 - Failed to set cint1 up within container 1
#		8 - Failed to set route to cint2 from container 1
#		9 - Failed to assign cint2 to cpid2
#		10 - Failed to assign address to cint2 withing container2
#		11 - Failed to set cint2 up within container 2
#		12 - Failed to set route to cint1 from container 1
#		-1 - unknown, should not reach
add_p2p_int () {
	cname1="${1}"
	cpid1="${2}"
	cip1="${3}"
	cname2="${4}"
	cpid2="${5}"
	cip2="${6}"
	cint1="${cpid1}-${RANDOM}"
	cint2="${cpid2}-${RANDOM}"

	if [[ ! -d "/var/run/netns/" ]] && [[ $(mkdir -p "/var/run/netns/") -ne 0 ]]; then
		return 1
	elif [[ ! -f "/var/run/netns/${cpid1}" ]] && [[ $(ln -s "/proc/${cpid2}/ns/net" "/var/run/netns/${cpid1}") -ne 0 ]]; then
		return 2
	elif [[ ! -f "/var/run/netns/${cpid2}" ]] && [[ $(ln -s "/proc/${cpid2}/ns/net" "/var/run/netns/${cpid2}") -ne 0 ]]; then
		return 3
	elif [[ $(ip link add "${cint1}" type veth peer name "${cint2}") -ne 0 ]]; then
		return 4
	elif [[ $(ip link set "${cint1}" netns "${cpid1}") -ne 0 ]]; then
		return 5
	elif [[ $(ip netns exec "${cpid1}" ip addr add "${cip1}" dev "${cint1}") -ne 0 ]]; then
		return 6
	elif [[ $(ip netns exec "${cpid1}" ip link set "${cint1}" up) -ne 0) -ne 0 ]]; then
		return 7
	elif [[ $(ip netns exec "${cpid1}" ip route add "${cip2}" dev "${cint1}") -ne 0 ]]; then
		return 8
	elif [[ $(ip link set "${cint2}" netns "${cpid2}") -ne 0 ]]; then
		return 9
	elif [[ $(ip netns exec "${cpid2}" ip addr add "${cip2}" dev "${cint2}") -ne 0 ]]; then
		return 10
	elif [[ $(ip netns exec "${cpid2}" ip link set "${cint2}" up) -ne 0 ]]; then
		return 11
	elif [[ $(ip netns exec "${cpid2}" ip route add "${cip1}" dev "${cint2}") -ne 0 ]]; then
		return 12
	else
		return 0
	fi

	return -1
}

# Cleans symlinks from old container interfaces
# Accepts:	Nothing
# Returns:	0
clean_cont_int () {
	find -L /var/run/netns -type l -delete
	return 0
}
