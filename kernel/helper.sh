#!/bin/bash

SWAP=false

DEV=$DEV0
GPU=$GPU0
HOST_IP=$HOST0_IP
PEER_IP=$PEER0_IP

KSFT_DIR="drivers/net/hw"

while getopts "0123456789r" opt; do
	case $opt in
		r) SWAP=true ;;
		0) ;;
		1)
			DEV="$DEV1"
			GPU="$GPU1"
			HOST_IP="$HOST1_IP"
			PEER_IP="$PEER1_IP"
			;;
		2)
			DEV="$DEV2"
			GPU="$GPU2"
			HOST_IP="$HOST2_IP"
			PEER_IP="$PEER2_IP"
			;;
		3)
			DEV="$DEV3"
			GPU="$GPU3"
			HOST_IP="$HOST3_IP"
			PEER_IP="$PEER3_IP"
			;;
		4)
			DEV="$DEV4"
			GPU="$GPU4"
			HOST_IP="$HOST4_IP"
			PEER_IP="$PEER4_IP"
			;;
		5)
			DEV="$DEV5"
			GPU="$GPU5"
			HOST_IP="$HOST5_IP"
			PEER_IP="$PEER5_IP"
			;;
		6)
			DEV="$DEV6"
			GPU="$GPU6"
			HOST_IP="$HOST6_IP"
			PEER_IP="$PEER6_IP"
			;;
		7)
			DEV="$DEV7"
			GPU="$GPU7"
			HOST_IP="$HOST7_IP"
			PEER_IP="$PEER7_IP"
			;;
		8)
			DEV="$DEV8"
			GPU="$GPU8"
			HOST_IP="$HOST8_IP"
			PEER_IP="$PEER8_IP"
			;;
		9)
			DEV="$DEV9"
			GPU="$GPU9"
			HOST_IP="$HOST9_IP"
			PEER_IP="$PEER9_IP"
			;;
	esac
done

shift $((OPTIND -1))

[[ -z "$HOST" ]] && { echo "HOST is undefined"; exit 1; }
[[ -z "$PEER" ]] && { echo "PEER is undefined"; exit 1; }
if [ ! "$1" = "generate_spec" ]; then
	[[ -z "$HOST_IP" ]] && { echo "HOST_IP is undefined - run generate_spec?"; exit 1; }
	[[ -z "$PEER_IP" ]] && { echo "PEER_IP is undefined - run generate_spec?"; exit 1; }
fi

NAME_SUFFIX=
if $SWAP; then
	tmp=$HOST
	HOST=$PEER
	PEER=$tmp

	tmp=$HOST_IP
	HOST_IP=$PEER_IP
	PEER_IP=$tmp
	NAME_SUFFIX=R
fi

# GENERIC

main() {
	local args
	local cmd

	for cmd in "$@"; do
		args=$(echo "$cmd" | cut -d: -f2- | tr ":" " ")
		cmd=$(echo "$cmd" | cut -d: -f1)

		# run command with $PEER as arg 1
		if [[ "$cmd" == peer@* ]]; then
			cmd=${cmd#peer@}
			eval $cmd $PEER $args
			continue
		fi

		# run command with $HOST as arg 1
		if [[ "$cmd" == host@* ]]; then
			cmd=${cmd#host@}
			eval $cmd $HOST $args
			continue
		fi

		# same as peer@cmd host@cmd
		if [[ "$cmd" == both@* ]]; then
			cmd=${cmd#both@}
			eval $cmd $HOST $args
			eval $cmd $PEER $args
			continue
		fi

		if [ "$cmd" = "$args" ]; then
			args=""
		fi

		eval $cmd $args
	done
}

run_in_pane() {
	local name="$1"
	local reset="$2"
	local server="$3"
	local client="$4"

	echo "$server"
	echo "$client"

	local name="run_$name$NAME_SUFFIX"
	tmux new-window -n "$name" "ssh -t root@$HOST 'echo reset; $reset; echo run; $server; sleep 30'" &
	sleep 5
	tmux split-window -h -t $name "ssh -t root@$PEER 'echo reset; $reset; echo run; $client; sleep 30'"
	wait
}

want_arg1() {
	if [ $# -lt 1 ]; then
		echo "HOST/PEER not provided"
		exit 1
	fi
}

want_arg2() {
	if [ $# -lt 2 ]; then
		echo "extra argument not provided"
		exit 1
	fi
}

want_no_args() {
	if [ $# -gt 0 ]; then
		echo "Invalid invocation (unexpected arguments)"
		exit 1
	fi
}

__dev_addr() {
	local host="$1"
	local dev="$2"

	ssh root@$host ip -6 addr show dev $dev | grep global | grep -v deprecated | awk '{ print $2 }' | awk -F/ '{print $1}'
}

generate_spec() {
	local host_ips=()
	local peer_ips=()
	local devs=()
	local ethn=4
	local bethn=4

	if [[ $ethn -gt 0 ]]; then
		for i in `seq 0 $(( $ethn - 1 ))`; do
			devs+=(eth${i})
			host_ips+=($(__dev_addr $HOST eth${i}))
			peer_ips+=($(__dev_addr $PEER eth${i}))
		done
	fi

	if [[ $bethn -gt 0 ]]; then
		for i in `seq 0 $(( $bethn -1 ))`; do
			devs+=(beth${i})
			host_ips+=($(__dev_addr $HOST beth${i}))
			peer_ips+=($(__dev_addr $PEER beth${i}))
		done
	fi

	for i in `seq 0 $(( ${#devs[@]} - 1 ))`; do
		echo DEV${i}=${devs[$i]}
		echo HOST${i}_IP=${host_ips[$i]}
		echo PEER${i}_IP=${peer_ips[$i]}
	done
}

cons() {
	local name="cons"

	tmux new-window -n "$name"
	tmux split-window -h -t $name
	tmux split-window -v -t $name
	tmux select-pane -t "${name}.1"
	tmux split-window -v

	tmux send-keys -t "${name}.1" "cons $HOST" 
	tmux send-keys -t "${name}.2" "cons $PEER"
	tmux send-keys -t "${name}.3" "ssh root@$HOST"
	tmux send-keys -t "${name}.4" "ssh root@$PEER"
}

# HELPERS

begin_trace() {
	want_arg1 "$@"

	ssh root@$1 "echo BEGIN > /sys/kernel/debug/tracing/trace_marker"
}

enable_tcphds() {
	want_arg1 "$@"

	ssh root@$1 ./ethtool -G $DEV tcp-data-split on
}

disable_tcphds() {
	want_arg1 "$@"

	ssh root@$1 ./ethtool -G $DEV tcp-data-split off
}

enable_hw_gro() {
	want_arg1 "$@"

	ssh root@$1 ethtool -K $DEV rx-gro-hw on
}

disable_hw_gro() {
	want_arg1 "$@"

	ssh root@$1 ethtool -K $DEV rx-gro-hw off
}

enable_gro() {
	want_arg1 "$@"

	ssh root@$1 ethtool -K $DEV generic-receive-offload on
}

disable_gro() {
	want_arg1 "$@"

	ssh root@$1 ethtool -K $DEV generic-receive-offload off
}

enable_irq_coal() {
	want_arg1 "$@"

	ssh root@$1 "ethtool -C $DEV rx-usecs 33 rx-frames 88 tx-usecs 19 tx-frames 128"
	ssh root@$1 "ethtool -c $DEV"
}

disable_irq_coal() {
	want_arg1 "$@"

	ssh root@$1 "ethtool -C $DEV rx-usecs 0 rx-frames 0 tx-usecs 0 tx-frames 0"
	ssh root@$1 "ethtool -c $DEV"
}

enable_gro_normal_batch() {
	want_arg1 "$@"

	ssh root@$1 "sysctl net.core.gro_normal_batch=8"
}

disable_gro_normal_batch() {
	want_arg1 "$@"

	ssh root@$1 "sysctl net.core.gro_normal_batch=1"
}

set_mtu() {
	want_arg1 "$@"

	# 4096+72 or +86?
	#ssh root@$1 ip link set mtu 4168 dev $DEV
	ssh root@$1 ip link set mtu 4096 dev $DEV
}

set_tcp_mem() {
	want_arg1 "$@"

	#ssh root@$1 "sysctl net.ipv4.tcp_moderate_rcvbuf=1"
	#ssh root@$1 "sysctl net.ipv4.tcp_rmem='4096 125000 67108864' net.ipv4.tcp_wmem='4096 125000 67108864'"

	#ssh root@$1 "sysctl net.ipv4.tcp_moderate_rcvbuf=1"
	ssh root@$1 "sysctl net.ipv4.tcp_rmem='4096 540000 15728640' net.ipv4.tcp_wmem='4096 262144 67108864'"
}

set_tcp_cc() {
	want_arg1 "$@"

	# default 120 200
	ssh root@$1 "sysctl net.ipv4.tcp_pacing_ca_ratio=120 net.ipv4.tcp_pacing_ss_ratio=200 net.ipv4.tcp_ecn=0"
	#ssh root@$1 "sysctl net.ipv4.tcp_pacing_ca_ratio=120 net.ipv4.tcp_pacing_ss_ratio=200 net.ipv4.tcp_ecn=1"
	# net.ipv4.tcp_dsack
}

stop_networkd() {
	want_arg1 "$@"

	ssh root@$1 systemctl stop systemd-networkd.service || :
}

add_lladdr() {
	local lladdr=$(ssh root@$HOST ip -6 neigh show dev $DEV | grep b00c | awk '{print $3}')

	echo ssh root@$HOST "ip -6 neigh add $PEER_IP lladdr $lladdr dev $DEV"
	echo ssh root@$PEER "ip -6 neigh add $HOST_IP lladdr $lladdr dev $DEV"

	echo "ip -6 neigh add $PEER_IP lladdr $lladdr dev $DEV"
	echo "ip -6 neigh add $HOST_IP lladdr $lladdr dev $DEV"
}

add_ssh_keys() {
	local host_key=$(ssh root@$HOST cat .ssh/id_rsa.pub)
	local peer_key=$(ssh root@$PEER cat .ssh/id_rsa.pub)

	echo "$host_key" | ssh root@$PEER tee -a .ssh/authorized_keys
	echo "$peer_key" | ssh root@$HOST tee -a .ssh/authorized_keys
}

add_routes() {
	local via="fe80::face:b00c"
	local pref="high"

	if [[ "$DEV" == beth* ]]; then
		local via="fe80::be:face:b00c"
	fi

	ssh root@$PEER "ip -6 route del $HOST_IP dev $DEV src $PEER_IP" || :
	ssh root@$HOST "ip -6 route del $PEER_IP dev $DEV src $HOST_IP" || :

	echo ssh root@$PEER "ip -6 route add $HOST_IP dev $DEV via $via src $PEER_IP $EXTRA_ROUTE pref $pref"
	echo ssh root@$HOST "ip -6 route add $PEER_IP dev $DEV via $via src $HOST_IP $EXTRA_ROUTE pref $pref"
	ssh root@$PEER "ip -6 route add $HOST_IP dev $DEV via $via src $PEER_IP $EXTRA_ROUTE pref $pref" || :
	ssh root@$HOST "ip -6 route add $PEER_IP dev $DEV via $via src $HOST_IP $EXTRA_ROUTE pref $pref" || :
}

ksft_copy() {
	want_no_args "$@"

	pushd $LINUX
	echo make
	make \
		-C tools/testing/selftests \
		TARGETS="$KSFT_DIR" \
		install INSTALL_PATH=~/tmp/ksft
	rsync -ra --delete ~/tmp/ksft root@${HOST}:
	#rsync -ra --delete ~/tmp/ksft root@${PEER}:
	popd
}

ksft_tcpx() {
	want_no_args "$@"

	pushd $LINUX

	local cfg
	cfg+="NETIF=${DEV}\n"
	cfg+="LOCAL_V6=${HOST_IP}\n"
	cfg+="REMOTE_V6=${PEER_IP}\n"
	cfg+="REMOTE_TYPE=ssh\n"
	cfg+="REMOTE_ARGS=root@${PEER}\n"

	echo -e "$cfg" | ssh root@$HOST "cat > ksft/$KSFT_DIR/net.config"
	ssh root@$HOST "export PATH=/bin:/usr/bin:/usr/sbin; cd ksft && ./run_kselftest.sh -t ${KSFT_DIR}:devmem.py"

	popd
}

build_kperf() {
	want_no_args "$@"

	pushd ~/src/kperf
	rm -rf ccan/src/generator
	rm ccan/libccan.a
	make
	popd
}

copy_kperf() {
	want_arg1 "$@"

	pushd ~/src/kperf
	ssh root@${1} pkill server || :
	scp client server root@${1}:
	popd
}

run_kperf() {
	local args=""
	args="$args --pin-off 1"
	#args="$args --msg-trunc"
	args="$args --devmem-rx"
	args="$args --msg-zerocopy"
	#args="$args --udmabuf-size-mb=64"
	args="$args $*"

	#args="$args --tcp-cc=bbr"
	#args="$args --tcp-cc=cubic"
	#args="$args --tcp-cc=dctcp"
	#args="$args --max-pace=2000000000" # 15Gbps
	#args="$args --time=10"
	#args="$args --time=30"
	#args="$args --time=300"
	#args="$args -n=8"
	#args="$args -n=16"

	#local server_args="--mrq"

	local server="./server -a ${HOST_IP} --no-daemon $server_args"
	local client="./server -a ${PEER_IP} --no-daemon & sleep 1; ./client --src ${PEER_IP} --dst ${HOST_IP} $args"
	local reset="./server --kill"

	run_in_pane kperf "$reset" "$server" "$client"
}

trace_pipe() {
	want_arg1 "$@"

	echo 1 | ssh root@$1 tee /sys/kernel/debug/tracing/tracing_on
	ssh root@$1 cat /sys/kernel/debug/tracing/trace_pipe
}

run_iperf3() {
	want_no_args "$@"

	local server="iperf3 -s -B ${HOST_IP}"
	local client="iperf3 -c ${HOST_IP} -Z -l 1024K -t 3600" # --congestion cubic"
	#local client="iperf3 -c ${HOST_IP} -Z -l 1024K -t 3600 --congestion bbr"
	#local client="iperf3 -c ${HOST_IP} -Z -l 1024K -t 60 --congestion cubic"
	local reset="pkill iperf3"
	#local reset="echo ok"

	run_in_pane iperf3 "$reset" "$server" "$client"
}

ynl_regen() {
	want_no_args "$@"

	# TODO: move to krn-regen-ynl?
	pushd ${LINUX}/tools/net/ynl/generated
	make regen
	make ethtool-user.h
	make ethtool-user.c
	make ethtool-user.o
}

dump_cpu_layout() {
	want_arg1 "$@"

	ssh root@$1 cat /proc/cpuinfo | krn-core-layout
}

dump_irq_affinity() {
	want_arg1 "$@"

	local affinities=()

	local irqs=$(ssh root@$1 "ls -1 /sys/class/net/$DEV/device/msi_irqs/")

	for irq in $irqs; do
		local affinity=$(ssh root@$1 "cat /proc/irq/$irq/effective_affinity_list")
		affinities+=($affinity)
	done

	local show="${affinities[@]/%/,}"
	echo "SHOW CORES: $show"
	ssh root@$1 cat /proc/cpuinfo | krn-core-layout -s "$show"
}

run_ssh() {
	want_arg1 "$@"

	ssh -t root@${1}
}

run_btop() {
	want_arg1 "$@"

	ssh -t root@${1} btop
}

run_strace() {
	want_arg1 "$@"

	ssh root@${1} 'strace  -e "!sched_yield" -p $(pgrep nccl_send)'
}

core_util() {
	want_arg1 "$@"

	scp ~/src/dotfiles/kernel/bin/krn-core-layout root@${1}:
	ssh -t root@${1} "./krn-core-layout -u"
}

core_util_top() {
	want_arg1 "$@"

	scp ~/src/dotfiles/kernel/bin/krn-core-layout root@${1}:
	ssh -t root@${1} "./krn-core-layout -u -t 5"
}

core_perf() {
	want_arg2 "$@"

	local cpu=$2
	local sleep=2

	ssh -t root@$1 "perf record -g -C $cpu -- sleep $sleep"
	ssh -t root@$1 perf report --children
}

run_skb_latency() {
	want_arg1 "$@"
	local h=$1
	shift

	pushd ~/src/skb_latency

	local scale="us"

	#if echo "$*" | grep -q "-s 1"; then
		scale="ns"
	#fi

	scp skb_latency root@${h}: && ssh root@$h ./skb_latency "$@" | ./plot -s $scale
	popd
}

run_bpftrace() {
	want_arg2 "$@"

	local host="$1"
	local script="$2"
	shift
	shift

	# TODO: support extra args
	set -- 2s

	cat ~/src/dotfiles/kernel/bpftrace/${script}.bpftrace | ssh -t root@${host} "timeout -s INT $* bpftrace -"
}
