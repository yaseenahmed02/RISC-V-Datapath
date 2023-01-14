`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2022 06:53:59 PM
// Design Name: 
// Module Name: forwarding_unit
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



module forwarding_unit(input [4:0]ID_EX_regR1,ID_EX_regR2,EX_MEM_Rd,MEM_WB_Rd,input EX_MEM_RegWrite, MEM_WB_RegWrite, 
output reg forwardA, forwardB );
//the second bit of ctrl
    always @(*) begin
        
        if (MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_regR1)) forwardA = 1'b1;
        else forwardA = 1'b0;
        
        if (MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_regR2)) forwardB = 1'b1;
        else forwardB = 1'b0;
        
    end

    
endmodule

