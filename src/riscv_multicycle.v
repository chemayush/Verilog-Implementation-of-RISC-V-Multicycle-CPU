
// RISC-V Multicycle CPU Implementation

module riscv_multicycle(input           clk, rst,
                        output[31:0]    WriteData, ReadData, PC, Result, Instr,
								output[3:0]		 state,
								output 			 RegWrite, PCWrite, Branch, MemWrite);
								
wire [2:0] MemOp, ImmSrc;
wire AddrSrc;
wire [31:0] Addr;

processor MultiCycleProcessor(
    .clk(clk),
    .rst(rst),
    .ReadData(ReadData),
    .MemWrite(MemWrite),
    .Addr(Addr),
    .WriteData(WriteData),
    .MemOp(MemOp), .AddrSrc(AddrSrc),
	 .PC(PC),
	 .Instr(Instr),
	 .Result(Result),
	 .ALUResult(ALUResult),
    .ALUOut(ALUOut),
	 .rd1(rd1), .rd2(rd2), .rs1(rs1), .rs2(rs2), .rd(rd),
	 .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ALUControl(ALUControl), .ResultSrc(ResultSrc),
	 .RegWrite(RegWrite),
	 .ImmSrc(ImmSrc),
	 .ImmExt(ImmExt), .srcA(srcA), .srcB(srcB), .PCWrite(PCWrite), .Branch(Branch), .state(state)
);

memory Memory(
    .clk(clk),
    .we(MemWrite), .AddrSrc(AddrSrc),
    .MemOp(MemOp),
    .addr(Addr),
    .wd(WriteData),
    .rd(ReadData)
);

endmodule

module processor(input              clk, rst,
                 input[31:0]        ReadData,
                 output             MemWrite,
                 output[2:0]        MemOp, ImmSrc,
                 output[31:0]       Addr, WriteData, PC, Result, ALUOut, ALUResult, Instr, rd1, rd2, ImmExt, srcA, srcB,
					  output[4:0]		   rs1, rs2, rd,
					  output[1:0]			ALUSrcA, ALUSrcB, ResultSrc, 
					  output[3:0]			ALUControl, state,
					  output 				RegWrite, PCWrite, Branch, AddrSrc);

wire            Zero, Cout, ALUb31, IRWrite, JALR_LSB;

control Controller(
    .clk(clk), .rst(rst), .op(Instr[6:0]), .funct3(Instr[14:12]), .funct7b5(Instr[30]), 
    .Zero(Zero), .Cout(Cout), .ALUb31(ALUb31), .PCWrite(PCWrite), .AddrSrc(AddrSrc), .MemWrite(MemWrite), .IRWrite(IRWrite), 
    .ResultSrc(ResultSrc), .ALUControl(ALUControl), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), 
    .ImmSrc(ImmSrc), .RegWrite(RegWrite), .JALR_LSB(JALR_LSB), .MemOp(MemOp), .Branch(Branch), .state(state)
);

datapath Datapath(
    .clk(clk), .rst(rst), .ImmSrc(ImmSrc), .ALUControl(ALUControl), .ResultSrc(ResultSrc),
    .IRWrite(IRWrite), .RegWrite(RegWrite), .JALR_LSB(JALR_LSB), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
    .AddrSrc(AddrSrc), .PCWrite(PCWrite), .ReadData(ReadData), .Zero(Zero), .Cout(Cout), .ALUb31(ALUb31),
    .Addr(Addr), .WriteData(WriteData), .Instr(Instr), .PC(PC), .Result(Result), .ALUOut(ALUOut), .ALUResult(ALUResult), .rd1(rd1), .rd2(rd2), .rs1(rs1), .rs2(rs2), .rd(rd),
	 .ImmExt(ImmExt), .srcA(srcA), .srcB(srcB)
);

endmodule



