
// Memory Module

module memory(input                 clk, we, AddrSrc,
              input[2:0]            MemOp,
              input[31:0]           addr, wd, 
              output reg [31:0]     rd);

reg [31:0] RAM[0:127];
reg [31:0] last_instr_addr;
reg [31:0] DATA_SEG; 

integer i;
initial begin
    $readmemh("factorial.hex", RAM);
    
    // Find last non-zero instruction
    last_instr_addr = 0;
    for(i = 0; i < 128; i = i + 1) begin
        if(RAM[i] != 32'h0) begin
            last_instr_addr = i;
        end
    end

    last_instr_addr = last_instr_addr;
    DATA_SEG = last_instr_addr + 1;

    $display("Last instruction at address: %d", last_instr_addr - 1);
    $display("Data section starts at: %d", DATA_SEG);
end

// Word address calculation
wire [31:0] word_addr;
wire [31:0] data_offset;

// If data access -> add DATA_SEG to the address
assign data_offset = (AddrSrc == 1) ? DATA_SEG : 0;
assign word_addr = ((addr[31:2] + data_offset) % 128);

always @(posedge clk) begin
    if (we) begin
        case (MemOp)
            3'b001: RAM[word_addr][7:0] <= wd[7:0];     // sb
            3'b010: RAM[word_addr][15:0] <= wd[15:0];   // sh
            3'b011: RAM[word_addr] <= wd;               // sw
            default: RAM[word_addr] <= wd;
        endcase
    end 
end 

always @(*) begin
    case (MemOp)
        3'b001: begin // lb
            case (addr[1:0])
                2'b00: rd = {{24{RAM[word_addr][ 7]}}, RAM[word_addr][ 7: 0]};
                2'b01: rd = {{24{RAM[word_addr][15]}}, RAM[word_addr][15: 8]};
                2'b10: rd = {{24{RAM[word_addr][23]}}, RAM[word_addr][23:16]};
                2'b11: rd = {{24{RAM[word_addr][31]}}, RAM[word_addr][31:24]};
            endcase
        end
        
        3'b010: begin // lh
            case (addr[1])
                1'b0: rd = {{16{RAM[word_addr][15]}}, RAM[word_addr][15: 0]};
                1'b1: rd = {{16{RAM[word_addr][31]}}, RAM[word_addr][31:16]};
            endcase
        end 
        3'b011: rd = RAM[word_addr]; // lw
        3'b100: begin // lbu
            case (addr[1:0])
                2'b00: rd = {24'b0, RAM[word_addr][ 7: 0]};
                2'b01: rd = {24'b0, RAM[word_addr][15: 8]};
                2'b10: rd = {24'b0, RAM[word_addr][23:16]};
                2'b11: rd = {24'b0, RAM[word_addr][31:24]};
            endcase
        end
        3'b101: begin // lhu
            case (addr[1])
                1'b0: rd = {16'b0, RAM[word_addr][15: 0]};
                1'b1: rd = {16'b0, RAM[word_addr][31:16]};
            endcase
        end
        default: rd = RAM[word_addr]; // default -> lw
    endcase
end

endmodule


