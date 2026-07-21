# FPGA Stopwatch (DE10-Lite, VHDL)

A stopwatch built in VHDL for the Terasic DE10-Lite board (Altera/Intel MAX 10 FPGA), displaying elapsed time as `MM.SS.CC` across the six onboard 7-segment displays.

I built this as part of a Digital Electronics lab module at university, and decided to tidy it up and share it here.

## Demo

https://github.com/user-attachments/assets/2e6d0643-de94-4c0f-bae3-1cce110be00e

## What it does

- **KEY0** — Start
- **KEY1** — Stop
- **SW0** — Reset
- Six 7-segment displays show minutes, seconds, and centiseconds, separated by decimal points
- A hex encoder module also supports displaying digits A–F, not just 0–9

## How it's built

- `clock_divider.vhd` — divides the 50 MHz board clock down to a 100 Hz tick
- `bcd_counter.vhd` — six-digit BCD counter (with synchronous clear) driven by the 100 Hz tick
- `encoder.vhd` — converts a 4-bit BCD/hex digit into a 7-segment display pattern
- `fsm_control.vhd` — a small Moore state machine (IDLE/RUNNING/STOPPED) that turns button presses into clean run/clear signals for the counter
- `stopwatch.vhd` — top-level module connecting everything together and driving the FPGA pins

## Building it

Built and tested in Quartus Prime, targeting the DE10-Lite's MAX 10 device (10M50DAF484C6GES). To rebuild:
1. Create a new Quartus project targeting the DE10-Lite board
2. Add all files from `src/`
3. Set `stopwatch` as the top-level entity
4. Import `constraints/stopwatch_pins.csv` via **Assignments → Import Assignments**
5. Compile and program the board
