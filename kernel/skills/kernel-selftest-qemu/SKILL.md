# Run Kernel Selftests

Run the in-tree kernel selftests (tools/testing/selftests/).

## Instructions

Use `krn-test` which supports the following options:

- krn-test "SELFTEST=(<path to selftest under tools/testing/selftests>)"
- krn-test "TARGETS=(<directory under tools/testing/selftests>)"

## Common targets

For networking, especially when working the netdev instance lock:
- net/rtnetlink.sh (SELFTEST)
- drivers/net/team (TARGETS)
- drivers/net/bonding (TARGETS)
- drivers/net/netdevsim (TARGETS)
