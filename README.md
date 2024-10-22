# Verilog-Implementation-of-RISC-V-Multicycle-CPU

I implemented a Multicycle RISC-V CPU supporting the entire RV32I instruction set. The design features a multicycle architecture, using a single RAM for both instruction and data segments with automatic memory management. Key components include a shared ALU, a 32x32-bit Register File, and an optimized FSM Controller for handling all the instructions. The unified memory module supports all access widths (byte, halfword, word). It also includes a testbench which is used to verify the implementation of all the instructions.

# Overview of entire architecture
![image](https://github.com/user-attachments/assets/dea81ee0-82be-48ec-af73-aa7df0110017)

# Datapath
![Screenshot 2024-10-22 221145](https://github.com/user-attachments/assets/e97253ab-f863-4937-8ffd-0ca4da13b1d1)

# Control Unit
![Screenshot 2024-10-22 221218](https://github.com/user-attachments/assets/bc06f10e-c803-4eab-acdd-48013724bb80)

# Memory
![Screenshot 2024-10-22 221413](https://github.com/user-attachments/assets/44bf7f1e-a99a-4bbd-b8aa-5d1ccdfb2eaf)

![Screenshot 2024-10-22 020818](https://github.com/user-attachments/assets/84296325-492a-4fc0-a63a-cb25a9ac1f95)
![Screenshot 2024-10-22 021250](https://github.com/user-attachments/assets/e03f65f7-a24e-4027-aef1-1551eb629507)
![Screenshot 2024-10-22 021415](https://github.com/user-attachments/assets/ecb7066b-3989-4c21-bebf-2c5e63d8e915)
![Screenshot 2024-10-22 021712](https://github.com/user-attachments/assets/faf34808-8cf7-4366-8e18-a0156bef931f)
![Screenshot 2024-10-22 021826](https://github.com/user-attachments/assets/6e3483ea-d6f3-437f-b7a7-a074960bd7eb)
