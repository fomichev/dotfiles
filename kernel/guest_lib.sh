#!/bin/bash

set -e

if [ -z "$HOME" ]; then
	echo "no HOME :-("
	exit 1
fi

TP_EXCLUDE=()
TP_INCLUDE=()
SELFTEST=()
CUSTOM=()

UNDER_GDB=false
FTRACE_SYMBOL=
#FTRACE_SYMBOL=$(ftrace_syscall bpf)
#FTRACE_SYMBOL=$(ftrace_syscall bind)
#FTRACE_SYMBOL=__sys_bind
#FTRACE_SYMBOL=bpf_raw_tp_link_attach

BISECT_ERR=
#BISECT_ERR="failed to load object"
#BISECT_ERR="name ct_sockops"

TP_BINARY=test_progs
#TP_BINARY=test_progs-no_alu32
TP_RUNS=1
TP_FLAGS=""
#TP_FLAGS="-v -v"
#TP_FLAGS="-j"
TP_NUM=""
#TP_NUM=62,98
#TEST_PROGS_RUNS=100

say() {
	tput setaf 2
	echo "$@"
	tput sgr0
}

adjust_ulimit() {
	ulimit -l unlimited |& >/dev/null # EINVAL when loading more than 3 bpf programs
	ulimit -n 819200 |& >/dev/null
	ulimit -a |& >/dev/null
}

UPSTREAM_KDIR=$HOME/src/linux

export_settings() {
	KDIR="$1"
	ST_DIR="$KDIR/tools/testing/selftests"
	SYZ_DIR=$HOME/go/src/github.com/google/syzkaller/bin/linux_amd64

	# for non-interactive (script) mode
	export PATH=$HOME/local/bin:$UPSTREAM_KDIR/tools/bpf/bpftool:$UPSTREAM_KDIR/tools/perf:$PATH

	export PATH=$UPSTREAM_KDIR/tools/bpf/bpftool:$PATH
	#export PATH=$HOME/tools/static:$PATH
	export PATH=$HOME/opt/sysroot/bin:$PATH
	export PATH=$HOME/opt/sysroot/sbin:$PATH

	# make sure config points to the right place
	mount -t tmpfs -o size=10M tmpfs /boot
	ln -s $KDIR/.config /boot/config-$(uname -r)

	mount -t tmpfs -o size=10M tmpfs /export/hda3/tmp || :
}

upstream_kernel() {
	export_settings "$@"
}

google_kernel() {
	export_settings $HOME/$1
	adjust_ulimit
	sysctl -q net.ipv4.use_google_ip_tos=1 || :
	echo "0 2147483647" > /proc/sys/net/ipv4/ping_group_range

	local MASK_ALL=$(cat /proc/ggl_ipv4_enable_constants | grep IPV4_ENABLE_MASK_ALL | cut -d= -f2)
	local MASK_TURN_OFF_IPV4=$(cat /proc/ggl_ipv4_enable_constants | grep IPV4_ENABLE_MASK_TURN_OFF_IPV4 | cut -d= -f2)

	mkdir -p /var/google/session/netbase/ipv4_enable
	echo "$MASK_ALL" > /var/google/session/netbase/ipv4_enable/ipv6_lameduck_v6host
	echo "$[ MASK_ALL & ~MASK_TURN_OFF_IPV4]" > /var/google/session/netbase/ipv4_enable/ipv6_only

	# networkd tests assume eth0
	ip link set enp0s7 down || :
	ip link set enp0s7 name eth0 || :
	ip link set eth0 up || :
}

detect_kernel() {
	local type=$(basename $PWD)
	if [ "$type" = "8xx" ]; then
		google_kernel 8xx
	elif [ "$type" = "9xx" -o "$type" = "9xx-2" ]; then
		google_kernel 9xx
	elif [ "$type" = "11xx" ]; then
		google_kernel 11xx
	elif [ "$type" = "12xx" ]; then
		google_kernel 12xx
	elif [ "$type" = "13xx" ]; then
		google_kernel 13xx
	elif [ "$type" = "linux" ]; then
		upstream_kernel $UPSTREAM_KDIR
	elif [ "$type" = "icebreaker" -o "$type" = "icebreaker2" ]; then
		google_kernel icebreaker
	elif [ "$type" = "bpf-next" ]; then
		type="linux"
		upstream_kernel $HOME/bpf-next
	else
		echo "Can't detect prodkernel vs upstream kernel! Assuming upstream!"
		type="linux"
		upstream_kernel $PWD
	fi

	export KERNEL_TYPE=$type
}

mount_bpffs() {
	mount -t bpf bpffs /sys/fs/bpf
}

mount_cgroup1() {
	sysctl kernel.allow_bpf_attach_netcg=1 || :
	sysctl net.core.enforce_netcg_bind_port_ranges=1 || :
	sysctl net.core.enforce_netcg_ipv6_only=1 || :
	sysctl net.core.enforce_netcg_tos_ranges=1 || :
	mkdir -p -m 0755 /dev/cgroup/net 2>/dev/null || :
	mount -t cgroup -o net none /dev/cgroup/net &>/dev/null
}

mount_cgroup2() {
	sysctl kernel.allow_bpf_attach_netcg=0 || :
	mount -t cgroup2 none /sys/fs/cgroup # cgroup bpf can be attached only to v2
}

poweroff() {
	exit
	#echo o > /proc/sysrq-trigger
}

mark_trace() {
	echo 1 > /sys/kernel/debug/tracing/tracing_on
	echo "$@" > /sys/kernel/debug/tracing/trace_marker
}

ftrace_syscall() {
	if [ "$KERNEL_TYPE" = "9xx" ]; then
		echo "SyS_$1"
		return
	fi
	echo "__x64_sys_$1"
}

#ignore+=" -g '*irq*'"
FTRACE_EXCLUDE+=" smp_irq_work_interrupt"
FTRACE_EXCLUDE+=" smp_apic_timer_interrupt"
FTRACE_EXCLUDE+=" do_IRQ"

FTRACE_EXCLUDE+=" vzalloc"
FTRACE_EXCLUDE+=" kvfree"
FTRACE_EXCLUDE+=" vmalloc"
FTRACE_EXCLUDE+=" vfree"
FTRACE_EXCLUDE+=" __vmalloc"
FTRACE_EXCLUDE+=" krealloc"
FTRACE_EXCLUDE+=" __kmalloc"
FTRACE_EXCLUDE+=" kfree"
FTRACE_EXCLUDE+=" pcpu_alloc"
FTRACE_EXCLUDE+=" mutex_lock_nested"
FTRACE_EXCLUDE+=" kmem_cache_alloc_trace"
FTRACE_EXCLUDE+=" kmem_cache_alloc"
FTRACE_EXCLUDE+=" kvmalloc_node"

FTRACE_EXCLUDE+=" _raw_spin_lock_bh"
FTRACE_EXCLUDE+=" _raw_spin_unlock_bh"

FTRACE_EXCLUDE+=" btf_check_all_metas"
FTRACE_EXCLUDE+=" btf_parse_vmlinux"

FTRACE_EXCLUDE+=" stack_trace_save"

FTRACE_EXCLUDE+=" __fdget"
FTRACE_EXCLUDE+=" __might_fault"

FTRACE_EXCLUDE+=" bpf_check"
FTRACE_EXCLUDE+=" filename_create"
FTRACE_EXCLUDE+=" done_path_create"
FTRACE_EXCLUDE+=" filename_lookup"
#FTRACE_EXCLUDE+=" irq_exit_rcu"
FTRACE_EXCLUDE+=" alloc_pages_current"
FTRACE_EXCLUDE+=" __text_poke"
FTRACE_EXCLUDE+=" arch_jump_label_transform_apply"
FTRACE_EXCLUDE+=" set_memory_ro"
FTRACE_EXCLUDE+=" bpf_int_jit_compile"
FTRACE_EXCLUDE+=" static_key_slow_inc"
FTRACE_EXCLUDE+=" anon_inode_getfile"
FTRACE_EXCLUDE+=" alloc_vmap_area"

FTRACE_EXCLUDE+=" rcu_read_lock_held"
FTRACE_EXCLUDE+=" rcu_read_lock_sched_held"
FTRACE_EXCLUDE+=" __rcu_read_lock"
FTRACE_EXCLUDE+=" __rcu_read_unlock"

ftrace_symbol_raw() {
	local include="$1"
	local ignore=""

	shift

	echo function_graph > /sys/kernel/debug/tracing/current_tracer
	echo $include > /sys/kernel/debug/tracing/set_graph_function

	for exclude in $FTRACE_EXCLUDE; do
		if ! grep -q $exclude /sys/kernel/debug/tracing/available_filter_functions; then
			continue
		fi
		echo $exclude >> /sys/kernel/debug/tracing/set_graph_notrace || echo "can't exclude $exclude"
	done

	trap "echo 0 > /sys/kernel/debug/tracing/tracing_on; cat /sys/kernel/debug/tracing/trace > $KDIR/perf_output.txt; echo CHECK OUT $KDIR/perf_output.txt" EXIT

	if [ -e /sys/kernel/debug/tracing/options/funcgraph-retval ]; then
		echo 1 > /sys/kernel/debug/tracing/options/funcgraph-retval
		echo 0 > /sys/kernel/debug/tracing/options/funcgraph-retval-hex
	fi

	echo 1 > /sys/kernel/debug/tracing/tracing_on
	echo > /sys/kernel/debug/tracing/trace
	eval "$@"
}

under_gdb() {
	gdb -ex r --args "$@"
}

maybe_gdb() {
	if $UNDER_GDB; then
		under_gdb "$@"
	else
		local binary="$1"
		shift
		$binary "$@"
	fi
}

maybe_ftrace() {
	local binary="$1"
	shift

	if [ ! -z "$FTRACE_SYMBOL" ]; then
		ftrace_symbol_raw $FTRACE_SYMBOL $binary "$@"
	else
		$binary "$@"
	fi
}


run_selftest() {
	local bin=$(basename "$1")
	local dir=$(dirname "$1")

	shift

	echo "(cd '$ST_DIR/$dir' && ./$bin '$@')"
	(cd "$ST_DIR/$dir" && maybe_ftrace maybe_gdb ./$bin "$@")
}

run_test_progs() {
	if [ $# -lt 2 ]; then
		return
	fi
	if [ -z "$2" ]; then
		# second argument is "filter" and can be empty
		return
	fi

	for x in $(seq $TP_RUNS); do
		run_selftest bpf/$TP_BINARY $TP_FLAGS "$@"
	done
}

die_on_panic_or_warning() {
	#dmesg -c | tail
	dmesg -c #| tail
	while :; do
		m="$(dmesg -c)"
		if [ -z "$m" ]; then
			echo -n .
		else
			echo "$m"
		fi

		if echo "$m" | grep -q panic; then
			echo PANIC!!!
			echo l > /proc/sysrq-trigger
		fi
		if echo "$m" | grep -q "WARNING:"; then
			echo WARNING!!!
			echo l > /proc/sysrq-trigger
		fi

		sleep 1

		if ! pgrep syz-executor &>/dev/null; then
			break
		fi
	done

}

testsuite_begin() {
	local init_netcg="$1"

	detect_kernel
	mount_bpffs || :
	mark_trace
	dmesg -C

	if [[ -e /proc/sys/net/core/bpf_bypass_getsockopt ]]; then
		echo 0 > /proc/sys/net/core/bpf_bypass_getsockopt
	fi

	if [[ ! "$KERNEL_TYPE" = "linux" ]]; then
		if $init_netcg; then
			mount_cgroup1 || :
		else
			mount_cgroup2 || :
		fi
	fi
}

bisect_run() {
	say "RUNNING IN BISECT MODE"

	"$@" |& tee $KDIR/bisect_log || :
	if grep "$BISECT_ERR" $KDIR/bisect_log; then
		bisect_fail
	else
		bisect_ok
	fi
}

bisect_ok() {
	say "BISECT OK"
	echo "ok" > $KDIR/bisect_status
}

bisect_fail() {
	say "BISECT FAIL"
	echo "fail" > $KDIR/bisect_status
}

testsuite_end() {
	echo 0 > /sys/kernel/debug/tracing/tracing_on

	trace=$(cat /sys/kernel/debug/tracing/trace | tail -n+12)
	if [ ! -z "$trace" ]; then
		say "ftrace:"
		echo "$trace"
		echo
	fi

	dmesg=$(dmesg -H)
	if [ ! -z "$dmesg" ]; then
		say "dmesg:"
		echo "$dmesg"
	fi

	poweroff
}

syz_execprog() {
	local path="$1"
	shift

	(cd /tmp && cp $SYZ_DIR/syz-executor . && $SYZ_DIR/syz-execprog "$@" $path)
}

run_syzkaller() {
	if [ ! -e "$1" ]; then
		return
	fi

	create_netdevsim netdevsim0

	ip link

	local repeat=${2:-1}
	local procs=$(grep procs $1 | sed -e 's/.*procs\":\([0-9]*\).*/\1/')

	echo syz_execprog $1 -threaded -collide -repeat=$repeat -procs=$procs &
	syz_execprog $1 -threaded -collide -repeat=$repeat -procs=$procs &
	#set +x

	die_on_panic_or_warning
	#set -x
}

run_syzkaller_c() {
	if [ ! -e "$1" ]; then
		return
	fi

	create_netdevsim netdevsim0

	echo "build rep.c"
	(cd $(dirname $1) && gcc $(basename $1) -lpthread)
	echo "run rep.c"
	dmesg -c
	$(dirname $1)/a.out &

	sleep 3

	ls /syzcgroup
	ls /syzcgroup/unified
	ls /syzcgroup/unified/syz0

	local bpftool=/usr/local/google/home/sdf/tools/bpftool
		$bpftool prog
		id=$($bpftool prog | grep cgroup_skb | awk -F: '{print $1}')
		$bpftool prog dump xlated id $id
		$bpftool prog dump jited id $id
		#$bpftool cgroup tree /syzcgroup/unified/szy0
		$bpftool cgroup tree
		$bpftool net
    #$bpftool prog dump jited id $id


	#set +x
	die_on_panic_or_warning
	#set -x
}

create_netdevsim() {
	local name="$1"

	echo 0 1 > /sys/bus/netdevsim/new_device

	dev_path=$(ls -d /sys/bus/netdevsim/devices/netdevsim0/net/*)
	dev=$(echo $dev_path | rev | cut -d/ -f1 | rev)

	/usr/local/google/home/sdf/src/iproute2_upstream/ip/ip link show dev eth1

	ip link set dev $dev name netdevsim0
	ip link set dev netdevsim0 up
}

__run_all_tests() {
	for custom in ${CUSTOM[@]}; do
		eval $custom
	done

	run_syzkaller_c $KDIR/rep.c || :
	run_syzkaller $KDIR/rep.syz || :

	for bin in ${SELFTEST[@]}; do
		run_selftest $(echo "$bin" | tr ':' ' ') || :
	done

	#rm -f $ST_DIR/bpf/bpf_testmod.ko
	run_test_progs -t "$(echo ${TP_INCLUDE[@]} | tr ' ' ',')" || :
	run_test_progs -b "$(echo ${TP_EXCLUDE[@]} | tr ' ' ',')" || :
	run_test_progs -n "$TP_NUM" || :
}

testsuite_run() {
	testsuite_begin "$@"

	if [ "$BISECT" = "y" ]; then
		bisect_run __run_all_tests
	else
		__run_all_tests
	fi

	testsuite_end
}

##### custom tests #####

bitcoin_miner() {
	cd /usr/local/google/home/sdf/src/xdp-btc-miner
	./mine
}

virtio_perf() {
	while :; do
		tcp_stream -B 65536 -Z --skip-rx-copy
	done

	# CONFIG=DBG

	# ethtool -l eth0
	# Combined: 1

	# q -f 8888,8889
	# Q: nc -l -p 8888
	# H: echo hi | nc 127.0.0.1 8888

	# q -f 8888,8889
	# Q: tcp_stream -C 8888 -P 8889
	# H: tcp_stream -C 8888 -P 8889 -c -H 127.0.0.1
	# throughput=2652.37 #Mbps

	# ip link set dev eth0 mtu 9198
	# throughput=2827.27

	# TAP_MQ=false q -n tap
	# Q: tcp_stream
	# H: tcp_stream -c -H 10.10.11.2
	# throughput=12770.49 #Mbps

	# TAP_MQ=true q -n tap
	# Q: tcp_stream
	# H: tcp_stream -c -H 10.10.10.2
	# throughput=7582.03 #Mbps

	# q -n tap
	# H: tcp_stream -B 65536 -Z --skip-rx-copy -c -H 10.10.10.2
	# throughput=17665.31 #Mbps

	# localhost traffic
	# throughput=17394.66 #Mbps

	# modprobe -r vhost_net
	# modprobe vhost_net experimental_zcopytx=1
	# q -n vhost
	# throughput=16224.34 #Mbps
	# perf script | ~/src/FlameGraph/stackcollapse-perf.pl > out.perf-folded
	# ~/src/FlameGraph/flamegraph.pl out.perf-folded > perf.svg
}

netdev_sim() {
	cd $KDIR/tools/testing/selftests/bpf
	./test_offload.py |& tee $KDIR/scratch.txt

	echo 0 1 > /sys/bus/netdevsim/new_device
	/usr/local/google/home/sdf/src/iproute2_upstream/ip/ip link show dev eth1
	/usr/local/google/home/sdf/src/iproute2_upstream/ip/ip link set dev eth1 xdpgeneric obj /usr/local/google/home/sdf/src/linux/tools/testing/selftests/bpf/sample_ret0.bpf.o sec .text

	echo 0 1 > /sys/bus/netdevsim/new_device
	dev_path=$(ls -d /sys/bus/netdevsim/devices/netdevsim0/net/*)
	dev=$(echo $dev_path | rev | cut -d/ -f1 | rev)
	dev=eth0

	./tools/net/ynl/ethtool $dev
	./tools/net/ynl/ethtool -g eth0
	./tools/net/ynl/ethtool -G eth0 rx 32 tx 32
	./tools/net/ynl/ethtool -G eth0 non-existent 23
	./tools/net/ynl/ethtool -S $dev
	ethtool -g eth0
}

ynl_cli() {
	ip6tables -I OUTPUT -o lo -p sctp --sport 10123 -j LOG
	ip6tables -A OUTPUT -o lo -p sctp --sport 10123 -j DROP
	$HOME/tmp/sctp_test --logtostderr
	ip link add veth0 type veth peer name veth1
	./tools/net/ynl/samples/netdev 12
	cd tools/net/ynl/
	./cli.py --spec $KDIR/Documentation/netlink/specs/netdev.yaml --dump dev-get --json='{"ifindex": 12}'
	testsuite_end
}

bpftool_prog() {
	pftool prog load ~/tmp/raw_tp.o /sys/fs/bpf/x
	bpftool prog loadall ./tools/testing/selftests/bpf/test_sk_lookup.bpf.o /sys/fs/bpf/x
	bpftool prog attach pinned /sys/fs/bpf/x/lookup_pass sk_lookup
	bpftool prog attach pinned /sys/fs/bpf/x/lookup_pass sk_lookup
}


tcpx_loopback() {
	local dev=eth0
	local addr=192.168.1.4

	cd $KDIR

	ip addr add $addr dev $dev
	ip link set $dev up
	local ret=$(echo -e "hello\nworld" | ./tools/testing/selftests/drivers/net/ncdevmem -L -f $dev -s ::ffff:$addr -p 5201)
	echo "[$ret]"

	local want=$(echo -e "hello\nworld")
	if [ "$ret" != "$want" ]; then
		echo "FAIL!"
		exit 1
	fi
}

tcpx_loopback2() {
	local dev=eth0
	local addr=192.168.1.4
	local bin=./tools/testing/selftests/drivers/net/ncdevmem
	#local bin=~/local/fbsource/buck-out/v2/gen/fbcode/scripts/dmm/netcat/netcat

	$bin -P -f $dev -s ::ffff:$addr -p 5201
	return

	ip addr add $addr dev $dev
	ip link set $dev up

	local length=4096
	random_string=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w $length | head -n 1)

	#echo $random_string

	echo "$random_string" > input.txt
	echo "$random_string" >> input.txt

	local ret=$(cat input.txt | $bin -L -f $dev -s ::ffff:$addr -p 5201)
	local want=$(cat input.txt)

	#local ret=$(echo -e "hello\nworld" | $bin -L -f $dev -s ::ffff:$addr -p 5201)
	#local want=$(echo -e "hello\nworld")

	#dmesg -C

	echo "[$ret]"
	if [ "$ret" != "$want" ]; then
		echo "FAIL!"
		exit 1
	fi
}

tcpx_selftest() {
	cd $KDIR

	make \
		-C tools/testing/selftests \
		TARGETS="drivers/net" \
		install INSTALL_PATH=$KDIR/ksft

	#cd $KDIR/ksft
	#./run_kselftest.sh -t drivers/net:devmem.py

	cd $KDIR/ksft/drivers/net
	local dev=eth0
	ip addr add 192.168.1.4 dev $dev
	ip link set $dev up
	./devmem.py
}
