`timescale 1ns / 1ps

module FSM_tb();

  // Inputs
  reg clk;
  reg rst;
  reg [6:0] op;
  reg [2:0] funct3;
  reg Zero, ALUb31, Cout;

  // Outputs
  wire PCUpdate, Branch, AddrSrc, MemWrite, IRWrite, RegWrite;
  wire [2:0] ALUop;
  wire [1:0] ResultSrc, ALUSrcA, ALUSrcB;
  wire JALR_LSB;
  wire [2:0] MemOp;

  // Instantiate the Unit Under Test (UUT)
  FSM uut (
    .clk(clk), 
    .rst(rst), 
    .op(op), 
    .funct3(funct3), 
    .Zero(Zero), 
    .ALUb31(ALUb31), 
    .Cout(Cout), 
    .PCUpdate(PCUpdate), 
    .Branch(Branch), 
    .AddrSrc(AddrSrc), 
    .MemWrite(MemWrite), 
    .IRWrite(IRWrite), 
    .RegWrite(RegWrite), 
    .ALUop(ALUop), 
    .ResultSrc(ResultSrc), 
    .ALUSrcA(ALUSrcA), 
    .ALUSrcB(ALUSrcB), 
    .JALR_LSB(JALR_LSB), 
    .MemOp(MemOp)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test procedure
  initial begin
    // Initialize Inputs
    rst = 1;
    op = 7'b0000000;
    funct3 = 3'bxxx;
    Zero = 0;
    ALUb31 = 0;
    Cout = 0;

    // Wait 100 ns for global reset to finish
    #100;
    rst = 0;

    // Test each opcode
    // Load instruction
    op = 7'b0000011;
    #50; 
    
	 rst = 1;
	 #100
	 rst = 0;
	 
    // Store instruction
    op = 7'b0100011;
    #40;
	 
	 rst = 1;
	 #100
	 rst = 0;
    
    // R-type instruction
    op = 7'b0110011;
    #40;
	 
	 rst = 1;
	 #100
	 rst = 0;
    
    // I-type instruction
    op = 7'b0010011;
    #40;
	 
	 rst = 1;
	 #100
	 rst = 0;
    
    // JAL instruction
    op = 7'b1101111;
    #40;
	 
	 rst = 1;
	 #100
	 rst = 0;
    
    // JALR instruction
    op = 7'b1100111;
    #40;
	 
	 rst = 1;
	 #100
	 rst = 0;
    
    // Branch instruction
    op = 7'b1100011; Zero = 1;
    #30;
	 Zero = 0;
	 rst = 1;
	 #100
	 rst = 0;
    
    // LUI instruction
    op = 7'b0110111;
    #40;
	 
	 rst = 1;
	 #100
	 rst = 0;
    
    // AUIPC instruction
    op = 7'b0010111;
    #40;
	 
	 rst = 1;
	 #100
	 rst = 0;

    // End simulation
    $finish;
  end

  // Monitor state changes
  always @(uut.state) begin
    $display("Time=%0t, Op=%b, State=%b", $time, op, uut.state);
  end

endmodule