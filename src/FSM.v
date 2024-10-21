
// Clock States FSM 

module FSM(input                clk, rst,
           input[6:0]           op,
           input[2:0]           funct3,
           input                Zero, ALUb31, Cout,
           output               PCUpdate, Branch, AddrSrc, MemWrite, IRWrite, RegWrite,
           output[1:0]  	    ALUop,
           output[1:0]  	    ResultSrc, ALUSrcA, ALUSrcB,
           output               JALR_LSB,
           output[2:0]          MemOp,
			  output reg [3:0]			  state, nextState);

localparam [3:0] FETCH      = 4'b0000,
                 DECODE     = 4'b0001,
                 MEMADR     = 4'b0010,
                 MEMREAD    = 4'b0011,
                 MEMWB      = 4'b0100,
                 MEMWRITE   = 4'b0101,
                 EXECUTE_R  = 4'b0110,
                 ALUWB      = 4'b0111,
                 EXECUTE_I  = 4'b1000,
                 JAL        = 4'b1001,
                 BRANCH     = 4'b1010,
                 JALR 		 = 4'b1011,
                 LUI	       = 4'b1100,
					  AUIPC		 = 4'b1101,
					  JALR_UPDATE = 4'b1110;

reg [16:0]     controls;
reg				BranchInst;
reg				fromJALR;


initial
	state = FETCH;


always @(posedge clk) begin
			state = nextState;
end

always @(*) begin

    BranchInst = 0;
	 
	 
    // PCUpdate_AddrSrc_MemWrite_IRWrite_RegWrite_ALUop_ResultSrc_ALUSrcA_ALUSrcB_jalrlsb_MemOp
    case (state)
        FETCH: begin 
            nextState = DECODE;
				controls = 17'b1_0_0_1_0_00_10_00_10_0_000;  // Normal FETCH
        end

        DECODE: begin
            casez (op)
                7'b0000011: nextState = MEMADR;    // Load
                7'b0100011: nextState = MEMADR;    // Store
                7'b0110011: nextState = EXECUTE_R; // R-type
                7'b0010011: nextState = EXECUTE_I; // I-type
                7'b1101111: nextState = JAL;       // JAL
                7'b1100111: nextState = JALR;      // JALR
                7'b1100011: nextState = BRANCH;    // BRANCH
					 7'b0110111: nextState = LUI;			// LUI
					 7'b0010111: nextState = ALUWB;     // AUIPC WRITEBACK
                default:    nextState = FETCH; 
            endcase
				

			  if (op == 7'b0010111) 
					controls = 17'b0_0_0_0_0_00_00_00_01_0_000;  // auipc upimm + pc
			  else 
					controls = 17'b0_0_0_0_0_00_00_01_01_0_000;  // Default
			  
		  end

        MEMADR: begin
            nextState = op[5] ? MEMWRITE : MEMREAD;
            controls = 17'b0_0_0_0_0_00_00_10_01_0_000;
        end

        EXECUTE_R: begin
            nextState = ALUWB;
            controls = 17'b0_0_0_0_0_10_00_10_00_0_000;
        end

        EXECUTE_I: begin
            nextState = ALUWB;
            controls = 17'b0_0_0_0_0_10_00_10_01_0_000;
        end

        JAL: begin
            nextState = ALUWB;
            controls = 17'b1_0_0_0_0_00_00_01_10_0_000;
        end
		  
		  JALR: begin
				nextState = JALR_UPDATE;
				controls = 17'b0_0_0_0_1_00_10_01_10_0_000;
		  end
		  
		  JALR_UPDATE: begin
				nextState = FETCH;
				controls = 17'b1_0_0_0_0_00_10_10_01_1_000;
		  end
		  
        BRANCH: begin
            nextState = FETCH;
            controls = 17'b0_0_0_0_0_01_00_10_00_0_000;
				BranchInst = 0;
//				if (op == 7'b) // beq
//				
//				else (op ==	)		// other branches

            case (funct3)
                3'b000: BranchInst = Zero;     // beq
                3'b001: BranchInst = !Zero;    // bne
                3'b100: BranchInst = ALUb31;   // blt
                3'b101: BranchInst = !ALUb31;  // bge
                3'b110: BranchInst = Cout;     // bltu
                3'b111: BranchInst = !Cout;    // bgeu
                default: BranchInst = 0;
            endcase
        end
		  
		  LUI: begin
				nextState = ALUWB;
				controls = 17'b0_0_0_0_0_11_00_01_01_0_000 ;	// lui
		  end

        MEMREAD: begin
            nextState = MEMWB;
            controls = 17'b0_1_0_0_0_00_00_00_00_0_000;
				case (funct3)
                3'b000: controls[2:0] = 3'b001;  // lb
                3'b001: controls[2:0] = 3'b010;  // lh
                3'b010: controls[2:0] = 3'b011;  // lw
                3'b100: controls[2:0] = 3'b100;  // lbu
                3'b101: controls[2:0] = 3'b101;  // lhu
                default: controls[2:0] = 3'b011; // default -> lw
            endcase
        end

        MEMWRITE: begin
            nextState = FETCH;
            controls = 17'b0_1_1_0_0_00_00_00_00_0_000;
            case (funct3)
                3'b000: controls[2:0] = 3'b001; // sb
                3'b001: controls[2:0] = 3'b010; // sh
                3'b010: controls[2:0] = 3'b011; // sw
                default: controls[2:0] = 3'b011; // default -> sw
            endcase
        end

        ALUWB: begin
            nextState = FETCH;
            controls = 17'b0_0_0_0_1_00_00_00_00_0_000;
        end

        MEMWB: begin
            nextState = FETCH;
				controls = 17'b0_0_0_0_1_00_01_00_00_0_000;
        end
		  
//		  default: controls = 17'b0_0_0_0_0_00_10_00_10_0_000;

    endcase
end

// PCUpdate_AddrSrc_MemWrite_IRWrite_RegWrite_ALUop_ResultSrc_ALUSrcA_ALUSrcB_jalrlsb_MemOp

assign Branch 		= BranchInst;
assign PCUpdate 	= controls[16]; 
assign AddrSrc 	= controls[15];
assign MemWrite 	= controls[14];
assign IRWrite 	= controls[13];
assign RegWrite 	= controls[12];
assign ALUop		= controls[11:10];
assign ResultSrc	= controls[9:8];
assign ALUSrcA    = controls[7:6];
assign ALUSrcB    = controls[5:4];
assign JALR_LSB   = controls[3];
assign MemOp		= controls[2:0];

endmodule
