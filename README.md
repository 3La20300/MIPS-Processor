# MIPS-Processor
The MIPS (Microprocessor without Interlocked Pipeline Stages) processor is a widely used RISC architecture known for its simplicity and efficiency. Featuring a fixed instruction length and a large number of general-purpose registers, MIPS processors excel in high-performance computing tasks like digital signal processing and networking.

Control_Unit: 

The Control_Unit entity defines a MIPS-like processor with components for ROM, RAM, ALU and ALU_Control. It handles instruction fetching, execution, and control flow based on opcode. The processor includes a register file, ALU, and a flag register for status. The process block handles instruction decoding and execution, updating the program counter and flags accordingly.

RAM: 

The RAM entity represents a simple RAM module with 16 addressable locations. It supports read and write operations based on control signals (ce, re, we). The process block updates the RAM data array based on write operations and outputs data for read operations.

ROM: 

The ROM entity represents a ROM module with a predefined data array. It outputs data based on the input address when both CE and RE are asserted. The process block handles data output based on control signals.

ALU_Control:

The ALU_Control entity provides control logic for an Arithmetic Logic Unit (ALU). It interfaces with the ALU component, determining the ALU operation based on the initial input and selector signals. The ALU_Control entity outputs control signals for zero, carry, overflow, and sign flags.


ALU:

The ALU entity represents an Arithmetic Logic Unit with various operations based on selector signals. It supports addition, subtraction, multiplication, division, bitwise AND, OR, XOR, and NOT operations. The process block evaluates the selected operation and updates the output (q) accordingly. Additional signals track carry-out, overflow, sign, and zero conditions. The ALU provides essential arithmetic and logic operations for the MIPS-like processor in Code 1.



