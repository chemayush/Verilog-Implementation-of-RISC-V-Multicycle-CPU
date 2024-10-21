module control_tb;

    reg clk, rst;
    reg [6:0] op;
    reg [2:0] funct3;
    reg Zero, ALUb31, Cout;

    wire PCUpdate, Branch, AddrSrc, MemWrite, IRWrite, RegWrite;
    wire [2:0] MemOp;
    wire [1:0] ResultSrc, ALUSrcA, ALUSrcB, ALUop;
    wire JALR_LSB;
    wire [3:0] ALUControl;

    // Instantiate the FSM and ALU decoder
    FSM uut_fsm (
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

    aludecoder uut_aludecoder (
        .opb5(op[5]),
        .funct3(funct3),
        .funct7b5(op[0]),
        .ALUop(ALUop),
        .ALUControl(ALUControl)
    );

    initial begin
        //$dumpfile("cpu_tb.vcd");
        //$dumpvars(0, cpu_tb);

        clk = 0;
        rst = 1;
        Zero = 0;
        ALUb31 = 0;
        Cout = 0;

        // Apply reset
        #20 rst = 0;

        // 1. Load Operation: op = 0000011 (Load), funct3 = 000
        op = 7'b0000011; funct3 = 3'b000; // Load opcode for 5 cycles
        #50;
		  
		  rst = 1;
		  #20
		  rst = 0;

        // 2. Store Operation: op = 0100011 (Store), funct3 = 010
        op = 7'b0100011; funct3 = 3'b010; // Store opcode for 4 cycles
        #40;
		  
		  rst = 1;
		  #20
		  rst = 0;

        // 3. R-Type ALU Operation: op = 0110011 (R-Type), funct3 = 000
        op = 7'b0110011; funct3 = 3'b000; // R-type for 4 cycles
        #40;
		  
		  rst = 1;
		  #20
		  rst = 0;

        // 4. I-Type ALU Operation: op = 0010011 (I-Type), funct3 = 000
        op = 7'b0010011; funct3 = 3'b000; // I-type ALU for 4 cycles
        #40;
		  
		  rst = 1;
		  #20
		  rst = 0;

        // 5. JAL Operation: op = 1101111 (JAL)
        op = 7'b1101111; funct3 = 3'b000; // JAL opcode for 4 cycles
        #40;
		  
		  rst = 1;
		  #20
		  rst = 0;

        // 6. JALR Operation: op = 1100111 (JALR)
        op = 7'b1100111; funct3 = 3'b000; // JALR opcode for 4 cycles
        #40;

		  rst = 1;
		  #20
		  rst = 0;
		  
        // 7. Branch Operation: op = 1100011 (Branch), funct3 = 000
        op = 7'b1100011; funct3 = 3'b000; Zero = 1; // BEQ branch (if Zero=1) for 3 cycles
        #30;
		  
		  rst = 1;
		  #20
		  rst = 0;

        $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

endmodule
