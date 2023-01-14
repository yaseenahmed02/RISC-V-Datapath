`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2022 06:02:36 PM
// Design Name: 
// Module Name: register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register#(parameter N=8)(input clk, load, rst, input[N-1:0] in, output [N-1:0] out);
wire [N-1:0] wi;   
genvar i;
generate
    for (i=0; i<N; i=i+1)
        begin: loop
            dff d(clk, rst, wi[i], out[i]);
            mux21 #(1) m(out[i], in[i], load, wi[i]);
        end
endgenerate
endmodule
