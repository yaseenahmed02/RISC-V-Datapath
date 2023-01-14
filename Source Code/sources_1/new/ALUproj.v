`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2022 02:56:13 PM
// Design Name: 
// Module Name: ALU_32bit
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


module ALUproj(input [31:0] in1, in2, input [3:0] aluSel, output reg [31:0] result, output reg zero );
wire cout,cout1;
wire [31:0] w;
wire [31:0] x;

RCA add (in1 , in2, w, cout);
RCA sub (in1 , ~in2+1,x, cout1);

always @(*)
begin
case(aluSel)

4'b0010: result = w;
4'b0110: result = x;
4'b0000: result= in1 & in2;
4'b0001: result= in1 | in2;
default: result=0;

endcase
if (result == 0)
zero=1;
else 
zero=0;
end
endmodule
