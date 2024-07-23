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
	xdp_metadata
)

SELFTEST=(
	#test_maps
	#test_verifier
	#test_flow_dissector.sh
	#test_kmod.sh
	#test_lwt_seg6local.sh
	#test_xsk.sh
	#test_offload.py
	#test_sock_addr.sh
)

CUSTOM=(
	#testsuite_bitcoin_miner
	#testsuite_virtio_perf
	#testsuite_netdev_sim
	#testsuite_ynl_cli
	#testsuite_tcpdirect
	#testsuite_bpftool_prog
)

testsuite_run false # v2
