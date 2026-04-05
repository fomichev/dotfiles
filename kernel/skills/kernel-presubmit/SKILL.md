# Prepare Patches for Upstream

Make sure the patches are up to upstream standards.

## Instructions

Run the following commands to make sure the patches are passing upstream checks:

- krn-nipa to run networking tests (takes awhile)
- krn-kunit to run unit tests (find the relevant ones from the context)
- krn-nipa-ingest to run build and style checks (ignore YNL -lasan failures)
- krn-format-patch to generate patches and run checkpatch; fix all ERRORs and WARNINGs (alignment, spacing, line length where feasible)

Don't run these in parallel, they reuse the source tree!
