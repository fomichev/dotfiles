# Prepare Patches for Upstream

Make sure the patches are up to upstream standards.

## Instructions

First, create a log directory under `~/tmp` named after the current branch to store all logs.
Tell the user the full path of the log directory.

    mkdir -p ~/tmp/<branch-name>

Run the following commands to make sure the patches are passing upstream checks.
Save the output of each command into the log directory using `2>&1 | tee ~/tmp/<branch-name>/<name>.log`.

- `krn-nipa 2>&1 | tee ~/tmp/<branch-name>/nipa.log` to run networking tests (takes awhile)
- `krn-kunit <args> 2>&1 | tee ~/tmp/<branch-name>/kunit.log` to run unit tests (find the relevant ones from the context)
- `krn-nipa-ingest 2>&1 | tee ~/tmp/<branch-name>/nipa-ingest.log` to run build and style checks (ignore YNL -lasan failures)
- `krn-format-patch 2>&1 | tee ~/tmp/<branch-name>/format-patch.log` to generate patches and run checkpatch; fix all ERRORs and WARNINGs (alignment, spacing, line length where feasible)

Don't run these in parallel, they reuse the source tree!
