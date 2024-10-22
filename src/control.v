
// Control Unit

module control(input                clk, rst,
               input[6:0]           op,
               input[2:0]           funct3,
               input                funct7b5,
               input                Zero, ALUb31, Cout,
               output               PCWrite, AddrSrc, MemWrite, IRWrite,
               output[1:0]          ResultSrc,
               output[3:0]          ALUControl,
               output[1:0]          ALUSrcA, ALUSrcB, 
               output[2:0]          ImmSrc,
               output               RegWrite, JALR_LSB, Branch,
               output[2:0]          MemOp,
					output[3:0]				state, nextState);

wire        PCUpdate;
wire[1:0]   ALUop;

FSM             stateFSM(clk, rst, op, funct3, Zero, ALUb31, Cout, PCUpdate, Branch, AddrSrc, MemWrite, IRWrite, RegWrite, ALUop, ResultSrc, ALUSrcA, ALUSrcB, JALR_LSB, MemOp, state, nextState);
aludecoder      alu_dec(op[5], funct3, funct7b5, ALUop, ALUControl);
imm_dec         immediate(op, ImmSrc);

assign PCWrite = PCUpdate | Branch;

endmodule

