`timescale 1ns / 1ps
module reg_file #(parameter N=32)(input clk, rst, regwrite ,input [4:0]write_reg, read_reg1, read_reg2, input [31:0] write_data,
 output [31:0] read_data1, read_data2 );

wire [N-1:0]Q[0:31];
reg [31:0] load;
assign read_data1= Q[read_reg1];
assign read_data2= Q[read_reg2];
always@ (*)
 begin 
    if (regwrite )
     begin
         load=0;
         load[write_reg]=1'b1 ; 
      end
     else load =0;
 end 
 genvar i;
    generate
        for (i=0; i<N; i=i+1)
            begin: loop
                if (i==0) register #(N) r1(clk, load[i], rst, 32'b0, Q[i]);
                else register #(N) r( clk, load[i], rst, write_data, Q[i]);
            end
    endgenerate 
endmodule