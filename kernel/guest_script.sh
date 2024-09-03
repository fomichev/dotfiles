#!/bin/bash

source $MYDIR/../guest_lib.sh

TP_EXCLUDE=(
	#cgroup_v1v2 # mount cgroup net_cls
	#test_bpffs # failed 255
	#send_signal # lockup
	#verif_scale_pyperf600 # too complex?
	#xdp_bonding # ?
)

TP_INCLUDE=(
	#sockop
	#sockopt sockopt_inherit sockopt_multi sockopt_sk
	#lsm_cgroup
	#xdp_metadata
)

SELFTEST=(
	#drivers/net/stats.py
	#drivers/net/hw/pp_alloc_fail.py

	#bpf/test_maps
	#bpf/test_verifier
	#bpf/test_flow_dissector.sh
	#bpf/test_kmod.sh
	#bpf/test_lwt_seg6local.sh
	#bpf/test_xsk.sh
	#bpf/test_offload.py
	#bpf/test_sock_addr.sh
)

tcpx_loopback() {
	local dev=eth0
	local addr=192.168.1.4

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

tcpx_selftest() {
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

CUSTOM=(
	#testsuite_bitcoin_miner
	#testsuite_virtio_perf
	#testsuite_netdev_sim
	#testsuite_ynl_cli
	#testsuite_tcpdirect
	#testsuite_bpftool_prog
	tcpx_loopback
	#tcpx_selftest
)

testsuite_run false # v2
