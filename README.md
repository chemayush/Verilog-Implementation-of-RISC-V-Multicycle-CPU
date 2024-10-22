# Verilog-Implementation-of-RISC-V-Multicycle-CPU

I implemented a Multicycle RISC-V CPU supporting the entire RV32I instruction set. The design features a multicycle architecture, using a single RAM for both instruction and data segments with automatic memory management. Key components include a shared ALU, a 32x32-bit Register File, and an optimized FSM Controller for handling all the instructions. The unified memory module supports all access widths (byte, halfword, word). It also includes a testbench which is used to verify the implementation of all the instructions.

# Overview of entire architecture
![image](https://github.com/user-attachments/assets/dea81ee0-82be-48ec-af73-aa7df0110017)

# Datapath
The datapath implementation follows a Multicycle architecture, hence multiple intermediate registers and flipflops are used to store the data to be used in the subsequent clock cycles. It also has various multiplexers to choose between different signals appropriate for that particular state of instruction. A register file is incorporated which has 32 registers (x0 - x31) which can store 32 bits of data. A module for generation of 'immediate' value also exists in the datapth. The ALU is reused for all the instructions, even for the increment of the program counter, further reducing the amount of hardware required.

![Screenshot 2024-10-22 221145](https://github.com/user-attachments/assets/e97253ab-f863-4937-8ffd-0ca4da13b1d1)

# Control Unit
This module is responsible for generating various control signals that chooses required components to control the flow of data in the datapath according to the current instruction being processed. The FSM module present in the control path is responsible for the efficient control of the instruction states. This is the part that is mainly responible for making it into multicycle architecture. 

![Screenshot 2024-10-22 221218](https://github.com/user-attachments/assets/bc06f10e-c803-4eab-acdd-48013724bb80)

# Finite State Machine
Below is the flowchart of the FSM implemented inside the control unit along with the corresponding control signals.

![fsm](https://github.com/user-attachments/assets/ac6d5bd0-0679-4324-8351-a397db754b30)

# Memory
Below is the shared memory for the instructions as well as data storage for variables and constants. You can see a lot of extra wires, muxes and gates because of the implementation of halfword and byte store/load instructions and automatic segmentation of code and data segments in the shown memory space.

![Screenshot 2024-10-22 221413](https://github.com/user-attachments/assets/44bf7f1e-a99a-4bbd-b8aa-5d1ccdfb2eaf)

# Testbench
A testbench for the verification of implementation of the instructions is also included. A RISCV Assmebly program, test_assembly.s (included) is converted to machine codes (test_assembly.hex) and loaded into the RAM. These instructions are then run according to the program counter value.
Below are the screenshots of the simulations carried out in modelsim. Different values can be compared according to the current instruction and state using the waveforms. But the testbench also verifies these values, further letting you know if any of the instruction implemented is broken. 

![Screenshot 2024-10-22 020818](https://github.com/user-attachments/assets/84296325-492a-4fc0-a63a-cb25a9ac1f95)
![Screenshot 2024-10-22 021250](https://github.com/user-attachments/assets/e03f65f7-a24e-4027-aef1-1551eb629507)
![Screenshot 2024-10-22 021415](https://github.com/user-attachments/assets/ecb7066b-3989-4c21-bebf-2c5e63d8e915)
![Screenshot 2024-10-22 021712](https://github.com/user-attachments/assets/faf34808-8cf7-4366-8e18-a0156bef931f)
![Screenshot 2024-10-22 021826](https://github.com/user-attachments/assets/6e3483ea-d6f3-437f-b7a7-a074960bd7eb)
