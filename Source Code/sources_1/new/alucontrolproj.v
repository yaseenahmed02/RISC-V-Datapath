`timescale 1ns / 1ps
`include "definesms3.vh"
module alucontrolproj(
input [1:0] ALUOp, input [4:0]opcode, input [2:0] func3, input func7, output reg [3:0] ALUSelection);
always @(*) begin 
        if (ALUOp==3'b00)
             ALUSelection =`ALU_ADD;
                         
        else if (ALUOp == 3'b01)
             ALUSelection  = `ALU_SUB;
             
        else if (ALUOp == 3'b10) 
        begin      
            if (opcode == `OPCODE_Arith_R) begin //R-type
                case(func3)
                    `F3_ADD: begin
                    if (func7) ALUSelection = `ALU_SUB;
                    else ALUSelection = `ALU_ADD;
                    end
                    `F3_SLL: begin
                    if (!func7) ALUSelection = `ALU_SLL;
                         //else ALUSelection = `ALU_ADD;
                    end 
                    `F3_SLT: begin
                    if (!func7) ALUSelection = `ALU_SLT;
                    end
                    `F3_SLTU: begin
                    if (!func7)ALUSelection = `ALU_SLTU;
                    end
                    `F3_XOR: begin
                    if (!func7) ALUSelection = `ALU_XOR;
                    end
                    `F3_SRL: begin
                        if (func7) ALUSelection = `ALU_SRA;
                        else ALUSelection = `ALU_SRL;
                     end
                    `F3_OR: begin
                     if (!func7) ALUSelection = `ALU_OR;
                     end
                    `F3_AND: begin
                     if (!func7) ALUSelection = `ALU_AND;
                     end
                    default: ALUSelection = `ALU_PASS;
                endcase 
            end //end R-type
            else if (opcode == `OPCODE_Arith_I) begin //I-type
                case(func3)
                    `F3_ADD: ALUSelection = `ALU_ADD;
                    `F3_SLL: ALUSelection = `ALU_SLL;
                    `F3_SLT: ALUSelection = `ALU_SLT;
                    `F3_SLTU: ALUSelection = `ALU_SLTU;
                    `F3_XOR: ALUSelection = `ALU_XOR;
                    `F3_SRL: begin
                        if (func7) ALUSelection = `ALU_SRA;
                        else ALUSelection = `ALU_SRL;
                     end
                    `F3_OR: ALUSelection = `ALU_OR;
                    `F3_AND: ALUSelection = `ALU_AND;
                    default: ALUSelection = `ALU_PASS;
                endcase  
                             
            end //end I-type
        end //end Third ALU-op      
        else if (ALUOp == 3'b11) ALUSelection = `ALU_PASS;
        
      end //end always 
    endmodule
