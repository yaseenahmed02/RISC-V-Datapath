module mux21#(parameter n=32)(input [n-1:0]x,
    input [n-1:0]y,
    input sel,
    output [n-1:0]m);

    assign m = sel ? y : x;
endmodule