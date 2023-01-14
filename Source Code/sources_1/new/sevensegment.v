`timescale 1ns / 1ps
module Four_Digit_Seven_Segment_Driver_Optimized(
    input clk,
    input [12:0] SW, //switches
    output reg [3:0] AN, //anodes (which of the four (eight) are on)
    output reg [6:0] SEG //the actual 7 seg (a, b, c, d, e, f, g)
    );
    
     reg [3:0] LED_BCD;
 reg [19:0] refresh_counter = 0; // 20-bit counter
 wire [1:0] LED_activating_counter;
 always @(posedge clk)
     begin
         refresh_counter <= refresh_counter + 1;
     end
        
     assign LED_activating_counter = refresh_counter[19:18];
    
    wire[3:0] th, hu, te, on;
    
    BCD bcd(SW, th, hu, te, on);
    
always @(*)
    begin
        case(LED_activating_counter)
            2'b00: begin
                AN = 4'b0111;
                LED_BCD = th;  //
            end
            2'b01: begin
                AN = 4'b1011;
                LED_BCD = hu;//
            end
            2'b10: begin
                AN = 4'b1101;
                LED_BCD = te;//
            end
            2'b11: begin
                AN = 4'b1110;
                LED_BCD = on;//
            end
        endcase
    end
    
    
 always @(*)
     begin
         case(LED_BCD)
             4'b0000: SEG = 7'b0000001; // "0"
             4'b0001: SEG = 7'b1001111; // "1"
             4'b0010: SEG = 7'b0010010; // "2"
             4'b0011: SEG = 7'b0000110; // "3"
             4'b0100: SEG = 7'b1001100; // "4"
             4'b0101: SEG = 7'b0100100; // "5"
             4'b0110: SEG = 7'b0100000; // "6"
             4'b0111: SEG = 7'b0001111; // "7"
             4'b1000: SEG = 7'b0000000; // "8"
             4'b1001: SEG = 7'b0000100; // "9"
             default: SEG = 7'b0000001; // "0"
         endcase
    end
endmodule