`timescale 1ns / 1ps
`include "definesms3.vh"
module branch_control(input [4:0] opcode, input branch, z, c, s, v, output reg[1:0] bc_out);
   always @(*) begin  
       if (branch & z) bc_out = 2'b01; //beq
       else if (branch & ~z) bc_out = 2'b01; //bne
       else if (branch & (s!=v)) bc_out = 2'b01; //blt
       else if (branch & (s==v)) bc_out = 2'b01; //bge
       else if (branch & !c) bc_out = 2'b01; //bltu
       else if (branch & c) bc_out = 2'b01; //bgeu
       else if (opcode == `OPCODE_JALR) bc_out = 2'b10;
//       else if (opcode == `OPCODE_AUIPC) bc_out = 2'b00;
//       else if (opcode == `OPCODE_JAL) bc_
       else bc_out = 2'b00; //no branching
   end
endmodule

/*

module branch_control(input [4:0] opcode, input[2:0] func3, input z, c, s, v, output reg [1:0] bc_out);
   always @(*) begin
    case(opcode)
        `OPCODE_Branch: begin
            case(func3)
                `BR_BEQ: begin
                    if (z) bc_out = 2'b01;
                    else bc_out = 2'b00;
                end
                `BR_BNE: begin
                    if (~z) bc_out = 2'b01;
                    else bc_out = 2'b00;
                end      
                `BR_BLT: begin
                    if (s != v) bc_out = 2'b01;
                    else bc_out = 2'b00;
                end        
                `BR_BGE: begin
                    if (s == v) bc_out = 2'b01;
                    else bc_out = 2'b00;
                end
                
                `BR_BLTU: begin
                    if (!c) bc_out = 2'b01;
                    else bc_out = 2'b00;
                end
                
                `BR_BGEU: begin
                    if (c) bc_out = 2'b01;
                    else bc_out = 2'b00;
                end
                
                                
             endcase //end func3 case
            
             
          end //end opcode branch
          
          `OPCODE_JAL: bc_out = 2'b01; //branch mux_in
          
          `OPCODE_JALR: bc_out = 2'b10; //ALU out
          
          default: bc_out = 2'b00; //PC+4 = adder_out
            
          
    endcase
    

   end
endmodule
*/
