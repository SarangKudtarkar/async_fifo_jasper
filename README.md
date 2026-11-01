# Asynchronous FIFO - Cadence JasperGold FPV

Self-contained asynchronous FIFO RTL and SVA formal environment.

## Requirements

- Cadence JasperGold FPV
- SystemVerilog support
- Multi-clock formal verification support

## Parameters

DATA_WIDTH = 8
ADDR_WIDTH = 2
DEPTH      = 2**ADDR_WIDTH

ADDR_WIDTH must be >= 2 for the full-pointer equation.

## Run

make formal

or

jg -batch -tcl jasper/run_jasper.tcl

## Formal checks

- Write pointer increment
- Read pointer increment
- Write pointer stability
- Read pointer stability
- Gray pointer one-bit transition
- Full flag equation
- Empty flag equation
- No write acceptance when full
- No read acceptance when empty
- Full and empty cover properties
- Write and read activity cover properties

## Important

This is a starter JasperGold FPV environment.

The proof requires correct multi-clock modeling in the
installed JasperGold version.

The example uses a common asynchronous active-low reset.

It does not yet prove end-to-end data ordering, absence of
data loss, or physical metastability behavior.

CDC analysis and implementation-level synchronizer checks
are separate verification activities.
