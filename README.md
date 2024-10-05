# MIPS Multicycle 32-bit Processor

This project implements a 32-bit multicycle MIPS processor in Verilog. The design is based on a multicycle architecture that executes instructions in multiple stages, reducing the complexity of the control logic compared to a single-cycle processor.

## Overview
This project implements a multicycle 32-bit MIPS processor that executes the instructions defined in the MIPS instruction set. It uses a finite state machine (FSM) to control the flow of instruction execution over multiple clock cycles.

The multicycle MIPS architecture divides the execution of an instruction into several stages, allowing for a balance between performance and simplicity. Each instruction is divided into up to five steps: Instruction Fetch, Instruction Decode, Execute, Memory Access, and Write Back.

## Features
- **32-bit data path:** Handles 32-bit wide data operations.
- **Multicycle architecture:** The processor executes instructions over multiple cycles to reduce control complexity.
- **Supports basic MIPS instructions:** Including arithmetic, logical, memory, and control instructions (R-type, I-type, and J-type).
- **Control Unit with FSM:** The control unit generates signals for each cycle to control the flow of data between registers and memory.
- **Verilog implementation:** Written entirely in Verilog HDL.
  
### Processor Schematic
Here is the schematic for the MIPS multi-cycle processor:
![phpjvjUod](https://github.com/user-attachments/assets/6c753fd4-3916-4b8c-b4c9-acabb1b3eddc)


## Hierarchy Structure

- **MultiCycle_Top**
  - **Instr_Data_Mem**: Memory for instruction and data storage
  - **Mips_Mutlti_Cycle**: Top-level module for multi-cycle MIPS architecture
    - **Control_Unit_Multi_cycle**: Manages control signals for multi-cycle operations
      - **maindec2**: Decodes main control signals
      - **maindec2**: Decodes ALU operation signals
    - **datapath**: Implements the data path for multi-cycle operations
      - **ALU** : Performs arithmetic operations
      - **D_reg**: Register for temporary storage
      - **D_reg_en**: Register for temporary storage with enable
      - **reg_file**: Register file for storing general-purpose registers
      - **PCMux**: multiplexer to select PC input 
      - **sign_extend**: Extends immediate values to appropriate size
      - **shifter**: Performs bitwise shifts on data

## Instruction Set

The processor implements a subset of the MIPS instruction set. The supported instructions are:

| Instruction | Operation                  | Format      |
|-------------|----------------------------|-------------|
| `ADD`       | Add                        | `R`         |
| `SUB`       | Subtract                   | `R`         |
| `AND`       | Bitwise AND                | `R`         |
| `OR`        | Bitwise OR                 | `R`         |
| `SLT`       | Set less than              | `R`         |
| `ADDI`      | Add Immediate              | `I`         |
| `LW`        | Load Word                  | `I`         |
| `SW`        | Store Word                 | `I`         |
| `BEQ`       | Branch if Equal            | `I`         |
| `J`         | Jump                       | `J`         |


## Design Details

## 1. **Data Path**

The data path is the core of the processor and includes the following components:

- **Register File**: 
  - General-purpose registers used to hold operands and results of operations.

- **ALU**: 
  - Performs arithmetic and logical operations on the data fetched from the register file.

- **D_reg**: 
  -  Register for temporary storage.

- **D_reg_en**: 
  -  Register for temporary storage with enable.
    
- **PCMux**: 
  -  multiplexer to select PC input.

- **Sign Extend**: 
  - Extends immediate values to the appropriate size for operations.

- **Shifter**: 
  - Performs bitwise shifts on data.

## 2. Control Unit

In a multicycle processor, the **Control Unit** plays a critical role in coordinating the execution of instructions by generating control signals for each stage of the instruction execution process. Unlike a single-cycle processor, where instructions are completed in one clock cycle, a multicycle processor breaks down instruction execution into multiple stages (such as Fetch, Decode, Execute, Memory Access, and Write Back), with each stage taking one or more cycles. The Control Unit manages the transitions between these stages and ensures the correct operation of the processor.

### Key Features of the Control Unit in a Multicycle Processor:

1. **Finite State Machine (FSM):**  
   The Control Unit operates as a **Finite State Machine** (FSM), where each state represents a specific stage of instruction execution. For example, one state might fetch the instruction, while another decodes it, and so on. The FSM transitions from one state to another depending on the current instruction type and stage of execution.

2. **Micro-operations and Control Signals:**  
   For each state, the Control Unit generates the necessary control signals that drive the appropriate operations within the processor. These control signals enable the movement of data between the registers, memory, and the Arithmetic Logic Unit (ALU).

3. **Select Signals:**  
   These signals determine which data paths to use within the processor at different stages of execution:
   - **MemtoReg:** Selects whether data to be written back to the register file comes from memory or the ALU.
   - **RegDst:** Determines which register will be written to (either from the instruction’s rd or rt fields).
   - **IorD:** Selects whether the memory address comes from the Program Counter (PC) or the ALU (used for memory access).
   - **PCSrc:** Selects the next value for the Program Counter (either sequential, branch, or jump address).
   - **ALUSrcA:** Selects the input to the ALU’s first operand (either the Program Counter or a register value).
   - **ALUSrcB:** Selects the input to the ALU’s second operand (either an immediate value or a register value).

4. **Enable Signals:**  
   These signals activate specific components of the processor during certain stages:
   - **IRWrite:** Enables the writing of an instruction from memory into the Instruction Register.
   - **MemWrite:** Controls when data should be written to memory.
   - **PCWrite:** Enables updating of the Program Counter (used for jumps and branches).
   - **Branch:** Determines if the Program Counter should be updated based on the result of a conditional branch.
   - **RegWrite:** Enables writing data back to the register file.

5. **Instruction-specific Control:**  
   The Control Unit recognizes the different types of instructions (R-type, I-type, and J-type) and adapts the FSM accordingly. For example, R-type instructions require ALU operations, while load and store instructions interact with memory.

6. **Reuse of Hardware:**  
   The multicycle design allows the processor to reuse functional units like the ALU and memory across different cycles of the same instruction. For instance, the ALU may be used for both address calculation and arithmetic operations, which reduces hardware complexity compared to a single-cycle processor.

7. **Control of the Instruction Flow:**  
   The Control Unit ensures proper branching and jumping by generating the **PCSrc** signal, which selects the source for updating the Program Counter (PC). Additionally, the **Branch** signal works in conjunction with the result of the ALU to control conditional branching.
   
The following figure shows the complete multicycle control FSM  for different instructions:
![Screenshot 2024-10-05 212300](https://github.com/user-attachments/assets/abd1dac2-9474-4451-8ebf-e48e35a3ac1e)


### 3. **Instruction Formats**

The processor supports three types of instruction formats: R-type, I-type, and J-type.

- **R-type** (Register): Used for operations involving only registers (e.g., `ADD`, `SUB`, `AND`).
- **I-type** (Immediate): Used for instructions that include an immediate value or memory address (e.g., `ADDI`, `LW`, `SW`).
- **J-type** (Jump): Used for jump instructions that require a direct address (e.g., `J`).

### 4. **Memory Access**

 the processor uses a combined memory for instructions and data. The instruction is fetched from memory on the first step, and data may be read or written on later steps.

## Future Work

- **Support for More Instructions**: Expand the instruction set to include more complex MIPS instructions like `BNE` (Branch if Not Equal), `SLT` (Set Less Than), `LUI` (Load Upper Immediate), etc.


