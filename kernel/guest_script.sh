#!/bin/bash

source $MYDIR/../guest_lib.sh
#testsuite_begin true # v1
testsuite_begin false # v2

UNDER_GDB=false
#FTRACE_SYMBOL=$(ftrace_syscall bpf)
#FTRACE_SYMBOL=$(ftrace_syscall bind)
#FTRACE_SYMBOL=__sys_bind
#FTRACE_SYMBOL=bpf_raw_tp_link_attach

#TP_FLAGS="-v -v"
#TP_FLAGS="-j"
#TP_NUM=62,98
#TP_BINARY=test_progs-no_alu32
#TEST_PROGS_RUNS=100

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

#BISECT_ERR="failed to load object"
#BISECT_ERR="name ct_sockops"

run_all_tests () {
	for custom in ${CUSTOM[@]}; do
		eval $custom
	done

	testsuite_syzkaller_c $KDIR/rep.c || :
	testsuite_syzkaller $KDIR/rep.syz || :

	for bin in ${SELFTEST[@]}; do
		run_selftest bpf $bin || :
	done

	#rm -f $ST_DIR/bpf/bpf_testmod.ko
	run_test_progs -t "$(echo ${TP_INCLUDE[@]} | tr ' ' ',')" || :
	run_test_progs -b "$(echo ${TP_EXCLUDE[@]} | tr ' ' ',')" || :
	run_test_progs -n "$TP_NUM" || :
}

if [ "$BISECT" = "y" ]; then
	bisect_run run_all_tests
else
	run_all_tests
fi

testsuite_end
