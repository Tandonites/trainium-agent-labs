Design a synthesizable 8-bit accumulator CPU core in Verilog.

Module name: cpu8

Inputs:
- clk: clock
- reset_n: asynchronous active-low reset
- enable: execute one instruction when high
- instruction[7:0]: instruction supplied externally

Outputs:
- acc[7:0]: accumulator
- pc[7:0]: address of the instruction to execute next
- data_out[7:0]: output register
- carry: carry from the most recent ADD instruction
- halted: indicates that execution has stopped

The core executes exactly one instruction on each rising clock edge when
enable is high and halted is low. External logic supplies instruction for
the current pc; the CPU has no internal instruction memory.

Instruction encoding:
- instruction[7:4] is the opcode.
- instruction[3:0] is an unsigned immediate value, extended to eight bits.

Instructions:

| Opcode | Name | Behavior |
|--------|------|----------|
| 0 | NOP | Increment pc. |
| 1 | LDI | Load the immediate into acc; increment pc. |
| 2 | ADD | Add the immediate to the current acc; store the low eight bits in acc, set carry to the ninth bit, and increment pc. |
| 3 | XOR | Replace acc with acc XOR the immediate; increment pc. |
| 4 | AND | Replace acc with acc AND the immediate; increment pc. |
| 5 | JMP | Set pc to the immediate. |
| 6 | JZ | If the current acc is zero, set pc to the immediate; otherwise increment pc. |
| 7 | OUT | Copy the current acc into data_out; increment pc. |
| 8 | HLT | Set halted high and leave pc unchanged. |

Opcodes 9 through 15 behave as NOP.

Additional requirements:
1. Reset immediately clears acc, pc, data_out, carry, and halted.
2. Reset takes priority over enable and halted.
3. While enable is low, every output retains its value.
4. While halted is high, every output retains its value until reset.
5. Only ADD changes carry, except reset.
6. Only OUT changes data_out, except reset.
7. Every instruction preserves state not explicitly changed by its behavior.
8. pc increments wrap from 255 to 0.
9. NOP, OUT, and HLT ignore the immediate field.
10. The first enabled rising edge after reset executes the instruction
    supplied for pc = 0.
11. Outputs change only on rising clock edges or reset assertion.

Return the complete cpu8 module in one Verilog code block.
