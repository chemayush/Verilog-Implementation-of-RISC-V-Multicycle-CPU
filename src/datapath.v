
// Datapath

module datapath(input           clk, rst,
                input[2:0]      ImmSrc,
                input[3:0]      ALUControl,
                input[1:0]      ResultSrc,
                input           IRWrite, RegWrite, JALR_LSB,
                input[1:0]      ALUSrcA, ALUSrcB,
                input           AddrSrc, 
                input           PCWrite,
                input[31:0]     ReadData,
                output          Zero, Cout, ALUb31,
                output[31:0]    Addr, 
					 output[31:0]	  WriteData, 
					 output[31:0]    Instr, PC, Result, ALUOut, ALUResult, rd1, rd2, ImmExt, srcA, srcB,
					 output[4:0]	  rs1, rs2, rd);

wire [31:0] A, Data, OldPC;

assign rs1 = Instr[19:15];
assign rs2 = Instr[24:20];
assign rd =  Instr[11: 7];
				
flipflopen          PCflop(clk, rst, PCWrite, Result, PC);
mux2                addrmux(PC, Result, AddrSrc, Addr);

flipflopen          OldPCflop(clk, rst, IRWrite, PC, OldPC);
flipflopen          instflop(clk, rst, IRWrite, ReadData, Instr);
flipflop            dataflop(clk, rst, ReadData, Data);

register_file       regfile(clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, rd1, rd2);
flipflop            regfileflop1(clk, rst, rd1, A);
flipflop            regfileflop2(clk, rst, rd2, WriteData);

immgen              extend(Instr[31:7], ImmSrc, ImmExt);

mux3                srcAmux(PC, OldPC, A, ALUSrcA, srcA);
mux3                srcBmux(WriteData, ImmExt, 32'd4, ALUSrcB, srcB);
ALU                 alu(srcA, srcB, ALUControl, JALR_LSB, ALUResult, Zero, ALUb31, Cout);

flipflop            ALUflop(clk, rst, ALUResult, ALUOut);
mux3                resultmux(ALUOut, Data, ALUResult, ResultSrc, Result);

endmodule