
// Immediate

module imm_dec(input[6:0]       op,
               output reg[2:0]  ImmSrc);

    always @(*) begin
        casez (op)
            7'b0110011: ImmSrc = 3'bxxx; // R Type
            7'b0010011: ImmSrc = 3'b000; // I Type 
            7'b0000011: ImmSrc = 3'b000; // I Load Type
            7'b0100011: ImmSrc = 3'b001; // S Type
            7'b1100011: ImmSrc = 3'b010; // B Type
            7'b1101111: ImmSrc = 3'b011; // JAL
            7'b1100111: ImmSrc = 3'b000; // JALR
            7'b0?10111: ImmSrc = 3'b100; // U Type
            default:    ImmSrc = 3'bxx; 
        endcase
    end
endmodule

module immgen(input[31:7]          instr,
              input[2:0]           immsrc,
              output reg[31:0]     immgen);

always @(*) begin
    case(immsrc)
        // I−type
        3'b000:   immgen = {{20{instr[31]}}, instr[31:20]};
        // S−type 
        3'b001:   immgen = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        // B−type 
        3'b010:   immgen = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
        // J−type
        3'b011:   immgen = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
        //U Type
        3'b100:   immgen = {instr[31:12], 12'b0};

        default: immgen = 32'bx;
    endcase
end

endmodule

