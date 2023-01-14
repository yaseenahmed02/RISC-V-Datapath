`timescale 1ns / 1ps
module RCA(input [31:0]A,input  [31:0]B, output [31:0] sum,output C);
wire  [31:0]w;
assign w = A  +  B;
assign sum = w;
assign C = w[31];

endmodule
