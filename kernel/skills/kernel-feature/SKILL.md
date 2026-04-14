# Set Up Kernel Feature Development Tree

Set up a new git worktree for kernel feature development, build the kernel,
run selftests for a baseline, and optionally execute a feature plan.

Arguments: `<feature-name> [feature-plan.md]`

- `feature-name` (required): name of the feature (e.g. AF_XDP_DEVMEM)
- `feature-plan.md` (optional): path to a .md file with the feature description/plan

## Instructions

### 1. Parse arguments

The user provides a feature name and an optional .md file path. If the .md
file is not provided, skip the plan execution step at the end.

If the .md file path is relative, resolve it relative to `~/src/kernel-scripts/Kernel/tasks/`.

### 2. Create a git worktree

Create a new worktree from `~/src/linux` in `~/src` with a branch based on
`upstream/net-next/main`:

```
cd ~/src/linux
git worktree add -b upstream/net-next/<feature-name>/1 ~/src/linux-<feature-name> upstream/net-next/main
```

Where `<feature-name>` is the feature name provided by the user.

After creating the worktree, `cd` into it (`~/src/linux-<feature-name>`).

### 3. Build the kernel

Use the `/kernel-build-qemu` skill (from `~/src/dotfiles/kernel/skills`)
to build the kernel in the new worktree. Make sure the build succeeds.

### 4. Run selftests for a baseline

Use the `/kernel-selftest-qemu` skill to run the selftests and establish
a baseline. Record the results.

### 5. Execute feature plan

If a .md file was provided:
- Show the user a summary of what the plan contains.
- Ask the user whether they want to continue with executing the instructions
  from the provided .md file.
- If the user confirms, follow the instructions in the .md file.

If no .md file was provided:
- Inform the user that the worktree is ready for development.
- Ask the user to provide instructions for what they'd like to work on.
