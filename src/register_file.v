
// Register File

module register_file(input          clk, we,
                     input[4:0]     rs1_add, rs2_add, rd_add,
                     input[31:0]    wr_data,
                     output[31:0]   rd1, rd2);

reg [31:0] registers[0:31];

integer i;
initial begin
    for (i = 0; i < 32; i = i + 1) begin
        registers[i] = 0;
    end
end

always @(posedge clk) begin
    if (we) registers[rd_add] <= wr_data;
end

assign rd1 = (rs1_add == 0) ? 0 : registers[rs1_add];
assign rd2 = (rs2_add == 0) ? 0 : registers[rs2_add];

endmodule

