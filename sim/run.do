# ============================================================
#  run.do  -  DES project (QuestaSim)      Usage:  do run.do
# ============================================================

# Unload any previous simulation (keeps the project open, no dialogs)
catch {quit -sim}

# ---- Paths -------------------------------------------------
set REPO    "C:/Study Resources/Fall 2026 (Current)/CSE451s - Computer and Network Security/Project 1 DES/Repo"
set SIM_DIR "$REPO/sim"
set RTL_DIR "$REPO/RTL"
set TB_DIR  "$REPO/testbench"

cd $SIM_DIR

# ---- Library (absolute path, created only if missing) ------
if {![file exists "$SIM_DIR/work/_info"]} {
    vlib "$SIM_DIR/work"
}
vmap work "$SIM_DIR/work"

# ---- Compile -----------------------------------------------
vlog -quiet -work work {*}[glob "$RTL_DIR/*.v"]
vlog -quiet -work work {*}[glob "$TB_DIR/*.v"]

# ---- Simulate ----------------------------------------------
# -onfinish stop : $finish / $fatal just halt the sim instead of
#                  popping up "Are you sure you want to finish?"
vsim -quiet -onfinish stop -voptargs="+acc" -t 1ps work.des_testbench
# add +VERBOSE after work.des_testbench for the extra trace

# ---- Waves -------------------------------------------------
add wave -divider "Testbench"
add wave -position insertpoint sim:/des_testbench/*

add wave -divider "Encryption"
add wave -position insertpoint sim:/des_testbench/dut_encryption/*

add wave -divider "Decryption"
add wave -position insertpoint sim:/des_testbench/dut_decryption/*

run -all
wave zoom full
