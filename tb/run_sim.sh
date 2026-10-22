#!/bin/bash
# Chay mo phong tu thu muc goc repo.  Cadence: dung xrun;  Icarus: iverilog
if command -v xrun >/dev/null; then
  xrun rtl/ALU.v tb/tb_ALU.v -access +rwc -64bit
else
  iverilog -g2005 -o sim.out rtl/ALU.v tb/tb_ALU.v && vvp sim.out
fi
