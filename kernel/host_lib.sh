#!/bin/bash

set -e

KDIR=${KDIR:-$(git rev-parse --show-toplevel)}

cd $KDIR

say() {
	tput setaf 1
	echo "$@"
	tput sgr0
}

get_branch() {
	# format:
	# <tag>/<remote>/[RFC-]<name>[/revision]
	echo "$(git rev-parse --abbrev-ref HEAD)"
}

get_branch_tag() {
	echo "$(get_branch)" | cut -d'/' -f1
}

get_branch_remote() {
	echo "$(get_branch)" | cut -d'/' -f2
}

get_branch_name() {
	echo "$(get_branch)" | cut -d'/' -f3
}

remote_main_branch() {
	local remote="$1"
	local branch

	case "$remote" in
		net) branch="main" ;;
		net-next) branch="main" ;;
		*) branch="master" ;;
	esac
	echo "$remote/$branch"
}

get_remote() {
	local branch="$(get_branch)"

	if [[ $branch = my/* ]]; then
		# Prefer this: translates my/<remote> into <remote>
		echo "$branch" | sed -e 's@my/@@'
		return
	fi

	local tag="$(get_branch_tag)"
	local remote="$(get_branch_remote)"

	if [ "$tag" = "upstream" ]; then
		remote=$(remote_main_branch "$remote")
	elif [ "$tag" = "wip" ]; then
		remote=$(remote_main_branch "$remote")
	elif [ "$tag" = "rfc" ]; then
		remote=$(remote_main_branch "$remote")
	elif [ "$tag" = "net" ]; then
		remote=$(remote_main_branch "$remote")
	else
		echo "Invalid tag '$tag'" >&2
		exit 1
	fi

	echo "$remote"
}

get_reroll_count() {
	local branch="$(get_branch)"
	local cnt="$(echo "$branch" | rev | cut -d/ -f1 | rev)"
	re='^[0-9]+$'
	if [[ "$cnt" =~ $re ]]; then
		echo "$cnt"
		return
	fi
}

get_line() {
	sed "${1}q;d" "$2"
}

link_gconfig() {
	if [ ! -e $KDIR/$1 ]; then
		ln -sf $MYDIR/../gconfig/$1
	fi
}

link_file() {
	if [ ! -e $KDIR/$1 ]; then
		ln -sf $MYDIR/../$1
	fi
}

unset_config() {
	if grep "${1}=y" "$2"; then
		sed -i "s/^.*${1}=y.*$//" "$2"
	fi
}

linux_cleanup() {
	#git checkout tools/testing/selftests/bpf/Makefile
	#git checkout tools/include/uapi/linux/in.h
	#rm tools/include/asm-generic/bitops/find.h
	:
}

kernel_flavor() {
	local flavor=$(basename $(pwd))
	case $flavor in
		*) echo "linux" ;;
	esac
}


fixup_build_native() {
	rm $KDIR/Gconfig.* || :

	local flavor=$(kernel_flavor)
	case $flavor in
		linux) link_gconfig Gconfig.native ;;
	esac
}

kernel_release() {
	#local flavor=$(kernel_flavor)
	#case $flavor in
	#	icebreaker2|icebreaker) echo "5017.6.0.0"; return ;;
	#	linux) echo ""; return ;;
	#esac

	echo "DEV"
	return

	# TODO: FIXME

	local tag=$(git describe --abbrev=0 HEAD)
	local prod_ver=$(echo "$tag" | awk -F- '{print $2}')
	local release=$(echo "$prod_ver" | awk -F. '{print $1"."$2".999.999"}')

	echo $release
}

clangd_target() {
	if [[ -e $KDIR/compile_commands.json ]]; then
		return
	fi

	if grep -q compile_commands.json $KDIR/Makefile; then
		echo compile_commands.json
	fi
}

clangd_generate() {
	if [[ -e $KDIR/compile_commands.json ]]; then
		return
	fi

	script=$KDIR/scripts/clang-tools/gen_compile_commands.py
	if [ ! -e "$script" ]; then
		# fallback to upstream
		script="~/src/linux/scripts/clang-tools/gen_compile_commands.py"
	fi

	if [ -e "$script" ]; then
		echo $script -d "$KDIR" -o "$KDIR/compile_commands.json"
		$script -d "$KDIR" -o "$KDIR/compile_commands.json"
	fi
}

kernel_vmlinux() {
	find . -type f -name 'vmlinux' | xargs file | grep 'ELF 64-bit LSB executable' | awk -F: '{print $1}' | tail -n1
}

prefer_system_python() {
	export PATH=$(echo "$PATH" | sed -e "s@/usr/local/bin@@g" | sed -e "s@::@@g" | sed -e "s@^:@@")
}
