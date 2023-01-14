`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2022 06:52:02 PM
// Design Name: 
// Module Name: controlunit
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
`include "definesms3.vh"
module controlunitproj(input [4:0] opcode,
    output reg Branch, 
    MemRead,
    MemtoReg,
    MemWrite,
    ALUsrc,
    RegWrite,
    b_flag,fence_flag,
    output reg [1:0] ALUOp, write_reg_mux_sel //for JAL/JALR(00), for AUIPC (01), for data_mem_out (10)
    );
    always @(*) begin
        case(opcode)
            `OPCODE_Arith_R: begin
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg  = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                ALUOp = 3'b10;
                ALUsrc = 1'b0;
                write_reg_mux_sel = 2'b10;
            end
        
             `OPCODE_Load: begin
                Branch = 1'b0;
                MemRead = 1'b1;
                MemtoReg  = 1'b1;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                ALUOp = 3'b00;
                ALUsrc = 1'b1;
                write_reg_mux_sel = 2'b10;
            end
            
            `OPCODE_Store: begin
                Branch = 1'b0;
                MemRead = 1'b0;
                //MemtoReg  = 1'b1;
                MemWrite = 1'b1;
                RegWrite = 1'b0;
                ALUOp = 3'b00;
                ALUsrc = 1'b1;
                write_reg_mux_sel = 2'b10; //X
            end
            
            `OPCODE_Branch: begin
                Branch = 1'b1;
                MemRead = 1'b0;
                //MemtoReg  = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b0;
                ALUOp = 3'b01;
                ALUsrc = 1'b0;
                write_reg_mux_sel = 2'b10; //X
            end
            
            `OPCODE_Arith_I: begin 
                 Branch = 1'b0;
                 MemRead = 1'b0;
                 MemtoReg  = 1'b0;
                 MemWrite = 1'b0;
                 RegWrite = 1'b1;
                 ALUOp = 3'b10;
                 ALUsrc = 1'b1;// i edited this
                 write_reg_mux_sel=2'b10;
             end 
             
             `OPCODE_JAL: begin 
                  Branch = 1'b0;
                  MemRead = 1'b0;
                  //MemtoReg  = 1'b0;
                  MemWrite = 1'b0;
                  RegWrite = 1'b1;
                  ALUOp = 3'b00;
                  ALUsrc = 1'b1;
                  write_reg_mux_sel = 2'b00;
              end   
              
              `OPCODE_JALR: begin 
                    Branch = 1'b0;
                    MemRead = 1'b0;
                   // MemtoReg  = 1'b0;
                    MemWrite = 1'b0;
                    RegWrite = 1'b1;
                    ALUOp = 3'b00;
                    ALUsrc = 1'b1;
                    write_reg_mux_sel = 2'b00;
               end   
               
             `OPCODE_AUIPC: begin 
                   Branch = 1'b1;
                   MemRead = 1'b0;
                   MemtoReg  = 1'b0;
                   MemWrite = 1'b0;
                   RegWrite = 1'b1;
                   ALUOp = 3'b00;
                   ALUsrc = 1'b1;
                   write_reg_mux_sel = 2'b01;
              end 
              
                    
            `OPCODE_LUI: begin 
                 Branch = 1'b0; //don't care
                 MemRead = 1'b0;
                 MemtoReg  = 1'b0;
                 MemWrite = 1'b0;
                 RegWrite = 1'b1;
                 ALUOp = 3'b11;
                 ALUsrc = 1'b1;
                 write_reg_mux_sel = 2'b11;
             end
            `OPCODE_SYSTEM: begin
                Branch = 1'b0; //don't care
                MemRead = 1'b0;
                MemtoReg  = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                ALUOp = 3'b00;
                ALUsrc = 1'b1;
                write_reg_mux_sel = 2'b00;
                b_flag=1'b1;
             end   
             5'b00011: begin
                Branch = 1'b0; //don't care
                MemRead = 1'b0;
                MemtoReg  = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b1;
                ALUOp = 3'b00;
                ALUsrc = 1'b1;
                write_reg_mux_sel = 2'b00;
                fence_flag=1'b1;
             end  
            default: begin
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg  = 1'b0;
                MemWrite = 1'b0;
                RegWrite = 1'b0;
                ALUOp = 3'b00;
                ALUsrc = 1'b0; 
                write_reg_mux_sel = 2'b10;
                b_flag=1'b0;
                fence_flag=1'b0;
            end
            
            
        endcase
    
    
    end
endmodule