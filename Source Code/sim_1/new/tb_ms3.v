`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2022 10:31:16 AM
// Design Name: 
// Module Name: ms2sim
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


module tb_ms3();
    reg clk,rst;
    reg SSDclk;
    reg [1:0]ledsel;
    reg [3:0]SSDsel;
    wire [15:0]LED;
    wire [3:0] ANODES;
    wire [6:0]LED_OUT;

    ms3path ms3(clk, rst, SSDclk, ledsel, SSDsel,  LED, ANODES, LED_OUT);
    initial begin
        clk =1'b0;
        forever begin
            #4 clk=~clk;
        end
    end

    initial begin
        rst =1'b1;
        #4
        rst=1'b0;
    end




endmodule
