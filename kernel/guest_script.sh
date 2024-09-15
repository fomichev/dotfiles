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
	#bpf/test_sock_addr.sh

	#net/bpf_offload.py
)

CUSTOM=(
	#bitcoin_miner
	#virtio_perf
	#netdev_sim
	#ynl_cli
	#bpftool_prog
	#tcpx_loopback
	#tcpx_selftest
)

testsuite_run false # v2
