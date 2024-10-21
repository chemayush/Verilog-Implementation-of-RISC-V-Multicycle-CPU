
// ALU Unit

module ALU(input[31:0]          a, b,
           input[3:0]           control, 
			  input					  JALR_LSB,
           output reg[31:0]     out,
           output               Zero, ALUb31, Cout);

reg [32:0] sum;

always @(a, b, control) begin
    case (control) 
        4'b0000: begin
            sum = a + b;
				if (JALR_LSB) out = {sum[31:1], 1'b0}; // LSB of JALR jump address -> 0
				else out = sum[31:0]; // add, addi
             
        end
        4'b0001: begin 
            sum = a + ~b + 1; // sub
            out = sum[31:0];
        end 
        4'b0010: out = a & b; // and, andi
        4'b0011: out = a | b; // or, ori
        4'b0100: out = a ^ b; // xor, xori
        4'b0101: out = ($signed(a) < $signed(b)); // slt, slti
        4'b0110: out = ($unsigned(a) < $unsigned(b)); // sltu, sltiu
        4'b0111: out = $signed(a) >>> $signed(b[4:0]); // sra
        4'b1000: out = a >> b[4:0];  //srl
        4'b1001: out = (a >> b[4:0]) | ({32{a[31]}} << (32 - b[4:0]));  // srai
        4'b1010: out = a >> b[4:0]; //srli
        4'b1011: out = a << b[4:0]; // sll, slli
        4'b1100: out = b; // lui
        default: out = 0;
    endcase
end

assign Zero     = (out == 0) ? 1'b1 : 1'b0;
assign Cout     = sum[32];
assign ALUb31   = out[31];

endmodule

// ALU Decoder

module aludecoder(input             opb5,
                  input[2:0]        funct3,
                  input             funct7b5,
                  input[1:0]        ALUop,
                  output reg[3:0]   ALUControl);
always @(*) begin

    case (ALUop)
        2'b00: ALUControl = 4'b0000;
        2'b01: ALUControl = 4'b0001;
        2'b11: ALUControl = 4'b1100;
        default: 
            case(funct3)

                3'b000: if (funct7b5 & opb5) ALUControl = 4'b0001;
                        else                 ALUControl = 4'b0000;
                3'b001: ALUControl = 4'b1011; //sll, slli
                3'b010: ALUControl = 4'b0101; //slt, slti
                3'b011: ALUControl = 4'b0110; //sltu, sltiu
                3'b100: ALUControl = 4'b0100; //xor, xori
                3'b101: 
                    case ({funct7b5, opb5})
                        2'b11: ALUControl = 4'b0111; //sra
                        2'b01: ALUControl = 4'b1000; //srl
                        2'b10: ALUControl = 4'b1001; //srai
                        2'b00: ALUControl = 4'b1010; //srli
                    endcase
                3'b110: ALUControl = 4'b0011; //or, ori
                3'b111: ALUControl = 4'b0010; //and andi
            endcase
    endcase
end

endmodule
