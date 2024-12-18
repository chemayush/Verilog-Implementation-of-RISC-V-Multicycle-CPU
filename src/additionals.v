
// Multiplexers

module mux2(input[31:0]   a,
            input[31:0]   b,
            input         sel,
            output[31:0]  y);

assign y = sel ? b : a;

endmodule

module mux3(input[31:0]   a,
            input[31:0]   b,
            input[31:0]   c,
            input[ 1:0]   sel,
            output[31:0]  y);

assign y = sel[1] ? c : (sel[0] ? b : a);

endmodule

module mux4(input[31:0]   a,
            input[31:0]   b,
            input[31:0]   c,
            input[31:0]   d,
            input[ 1:0]   sel,
            output[31:0]  y);

assign y = sel[1] ? (sel[0] ? d : c) : (sel[0] ? b : a);

endmodule

// Flip Flops

module flipflop(input            clk, rst,
                input[31:0]      d,
                output reg[31:0] q);

always @(posedge clk or posedge rst) begin
    if (rst) q <= 0;
    else     q <= d;
end

endmodule

module flipflopen(input            clk, rst, en,
                 input[31:0]      d,
                 output reg[31:0] q);

always @(posedge clk or posedge rst) begin
    if (rst)        q <= 0;
    else if (en)    q <= d;
end

endmodule
