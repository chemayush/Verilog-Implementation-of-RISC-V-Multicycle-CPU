
// Verifying all the RV32I Instructions

module riscv_multicycle_tb;
    reg clk, rst;
    wire [31:0] WriteData, ReadData, PC, Result, Instr;
    wire [3:0] state;
    wire RegWrite, PCWrite, Branch, MemWrite;
    
    reg [5:0] instr_count;
    reg [31:0] expected_result, expected_writedata, expected_readdata;
    reg check_writedata, check_readdata;
    reg [39:0] instr_name; 
    reg [5:0] correct_count;
	 reg instruction_passed;
    
    riscv_multicycle cpu(
        .clk(clk),
        .rst(rst),
        .WriteData(WriteData),
        .ReadData(ReadData),
        .PC(PC),
        .Result(Result),
		  .Instr(Instr),
        .state(state),
        .RegWrite(RegWrite),
        .PCWrite(PCWrite),
        .Branch(Branch),
        .MemWrite(MemWrite)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    wire [3:0] nextState;
    assign nextState = cpu.MultiCycleProcessor.Controller.nextState;

    initial begin
        instr_count = 0;
        check_writedata = 0;
        check_readdata = 0;
		  correct_count = 0;
    end
    
    // instruction counts
    always @* begin
        check_writedata = 0;
        check_readdata = 0;
        
        case(instr_count)
            0: expected_result = 0;
				1: expected_result = 32'h70602000;
				2: expected_result = 32'h70602081;
            3: expected_result = -3;
            4: expected_result = 8;
            5: expected_result = 2;
            6: begin 
                expected_result = 0; 
                expected_writedata = 32'h70602081;
                check_writedata = 1;
            end
            7: begin 
                expected_result = 4; 
                expected_writedata = -3;
                check_writedata = 1;
            end
            8: begin 
                expected_result = 8; 
                expected_writedata = 8;
                check_writedata = 1;
            end
            9: begin 
                expected_readdata = 32'h70602081; 
                expected_result = 0;
                check_readdata = 1;
            end
            10: begin 
                expected_readdata = 32'h00007060; 
                expected_result = 2;
                check_readdata = 1;
            end
            11: begin 
                expected_readdata = 32'h00000020; 
                expected_result = 1;
                check_readdata = 1;
            end
            12: begin 
                expected_readdata = 32'hfffffffd;
                expected_result = 4; 
                check_readdata = 1;
            end
            13: begin 
                expected_readdata = 32'h0000xxxx;
                expected_result = 7; 
                check_readdata = 1;
            end
            14: begin 
                expected_readdata = 32'h000000xx;
                expected_result = 9; // lbu
                check_readdata = 1;
            end
            15: expected_result = 32'h7060207e;
            16: expected_result = 6;
            17: expected_result = 0;
            18: expected_result = -1;
            19: expected_result = 32'h70602089;
            20: expected_result = 32'hc1808204;
            21: expected_result = 4;
            22: expected_result = -2;
            23: expected_result = 32'hc1808204;
            24: expected_result = 2;
            25: expected_result = -1;
            26: expected_result = 32'h12345000;
            27: expected_result = 32'h0100006c;
            28: expected_result = 1;
            29: expected_result = 0;
            30: expected_result = 0;
            31: expected_result = 0;
            32: expected_result = 132;
            33: expected_result = 140;
            34: expected_result = 148;
            35: expected_result = 156;
            36: expected_result = 164;
            37: expected_result = 5;
            38: expected_result = 172;
            39: expected_result = 6;
            40: expected_result = 176;
				41: expected_result = 184;
				42: expected_result = 67;
            43: expected_result = 68;
				44: expected_result = 69;
				45: expected_result = 90;
				46: expected_result = 24;
				47: expected_result = 208;
            default: expected_result = 32'hxxxxxxxx;
        endcase
    end
	 
// Function to decode instruction type and set name
    always @* begin
        case(Instr[6:0])
            7'b0110011: begin // R-type
                case(Instr[14:12]) // funct3
                    3'b000: begin // ADD/SUB
                        case(Instr[31:25]) // funct7
                            7'b0000000: instr_name = "ADD";
                            7'b0100000: instr_name = "SUB";
                            default: instr_name = "UNKNOWN";
                        endcase
                    end
                    3'b001: begin // SLL
                        case(Instr[31:25])
                            7'b0000000: instr_name = "SLL";
                            default: instr_name = "UNKNOWN";
                        endcase
                    end
                    3'b010: begin // SLT
                        case(Instr[31:25])
                            7'b0000000: instr_name = "SLT";
                            default: instr_name = "UNKNOWN";
                        endcase
                    end
                    3'b011: begin // SLTU
                        case(Instr[31:25])
                            7'b0000000: instr_name = "SLTU";
                            default: instr_name = "UNKNOWN";
                        endcase
                    end
                    3'b100: begin // XOR
                        case(Instr[31:25])
                            7'b0000000: instr_name = "XOR";
                            default: instr_name = "UNKNOWN";
                        endcase
                    end
                    3'b101: begin // SRL/SRA
                        case(Instr[31:25])
                            7'b0000000: instr_name = "SRL";
                            7'b0100000: instr_name = "SRA";
                            default: instr_name = "UNKNOWN";
                        endcase
                    end
                    3'b110: begin // OR
                        case(Instr[31:25])
                            7'b0000000: instr_name = "OR";
                            default: instr_name = "UNKNOWN";
                        endcase
                    end
                    3'b111: begin // AND
                        case(Instr[31:25])
                            7'b0000000: instr_name = "AND";
                            default: instr_name = "UNKNOWN";
                        endcase
                    end
                endcase
            end
            
            7'b0010011: begin // I-type ALU
                case(Instr[14:12])
                    3'b000: instr_name = "ADDI";
                    3'b001: begin // SLLI
                        case(Instr[31:25])
                            7'b0000000: instr_name = "SLLI";
                            default: instr_name = "UNKNOWN";
                        endcase
                    end
                    3'b010: instr_name = "SLTI";
                    3'b011: instr_name = "SLTIU";
                    3'b100: instr_name = "XORI";
                    3'b101: begin // SRLI/SRAI
                        case(Instr[31:25])
                            7'b0000000: instr_name = "SRLI";
                            7'b0100000: instr_name = "SRAI";
                            default: instr_name = "UNKNOWN";
                        endcase
                    end
                    3'b110: instr_name = "ORI";
                    3'b111: instr_name = "ANDI";
                endcase
            end
            
            7'b0000011: begin // Load
                case(Instr[14:12])
                    3'b000: instr_name = "LB";
                    3'b001: instr_name = "LH";
                    3'b010: instr_name = "LW";
                    3'b100: instr_name = "LBU";
                    3'b101: instr_name = "LHU";
                    default: instr_name = "UNKNOWN";
                endcase
            end
            
            7'b0100011: begin // Store
                case(Instr[14:12])
                    3'b000: instr_name = "SB";
                    3'b001: instr_name = "SH";
                    3'b010: instr_name = "SW";
                    default: instr_name = "UNKNOWN";
                endcase
            end
            
            7'b1100011: begin // Branch
                case(Instr[14:12])
                    3'b000: instr_name = "BEQ";
                    3'b001: instr_name = "BNE";
                    3'b100: instr_name = "BLT";
                    3'b101: instr_name = "BGE";
                    3'b110: instr_name = "BLTU";
                    3'b111: instr_name = "BGEU";
                    default: instr_name = "UNKNOWN";
                endcase
            end
            
            // J-type
            7'b1101111: instr_name = "JAL";
            
            // I-type Jump
            7'b1100111: begin
                case(Instr[14:12])
                    3'b000: instr_name = "JALR";
                    default: instr_name = "UNKNOWN";
                endcase
            end
            
            // U-type
            7'b0110111: instr_name = "LUI";
            7'b0010111: instr_name = "AUIPC";
            
            default: instr_name = "UNKNOWN";
        endcase
    end
    
    always @(negedge clk) begin
        if ((!rst && nextState == 4'b0000 && state != 4'b0000 && Instr[6:0] != 7'b0000011) || 
            (state == 4'b0011 && Instr[6:0] == 7'b0000011)) begin
            
            
            instruction_passed = 1;
            
            $display("\n***** Instruction %0d: %s *****", instr_count, instr_name);
            $display("Time: %0t, PC: %h", $time, PC);
            $display("Instruction: %h", Instr);
            
            if (Result !== expected_result) begin
                $display("ERROR: Result mismatch");
                $display("Expected: %h (%0d)", expected_result, $signed(expected_result));
                $display("Got     : %h (%0d)", Result, $signed(Result));
                instruction_passed = 0;
            end
            
            if (check_writedata) begin
                if (WriteData !== expected_writedata) begin
                    $display("ERROR: WriteData mismatch for store instruction");
                    $display("Expected: %h (%0d)", expected_writedata, $signed(expected_writedata));
                    $display("Got     : %h (%0d)", WriteData, $signed(WriteData));
                    instruction_passed = 0;
                end
            end
            
            if (check_readdata) begin
                if (ReadData !== expected_readdata) begin
                    $display("ERROR: ReadData mismatch for load instruction");
                    $display("Expected: %h (%0d)", expected_readdata, $signed(expected_readdata));
                    $display("Got     : %h (%0d)", ReadData, $signed(ReadData));
                    instruction_passed = 0;
                end
            end
            
            if (instruction_passed) begin
                $display("PASSED ✓");
                correct_count = correct_count + 1;
            end else begin
                $display("FAILED ✗");
            end
            
            $display("-----------------------------------------");
            instr_count = instr_count + 1;
        end
    end
    

    initial begin
        rst = 1;
        #10;
        rst = 0;
        
        // Wait for instructions to execute
        #1875;

        $display("\n=== Test Summary ===");
        $display("Total Instructions: %0d", instr_count-1);
        $display("Correct Instructions: %0d", correct_count-1);
        $display("Failed Instructions: %0d", instr_count - correct_count);
        $display("Success Rate: %0d%%", ((correct_count-1) * 100) / (instr_count-1));
        
        $finish;
    end
    
endmodule
