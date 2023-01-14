module memory(input clk, MemRead, MemWrite, input [2:0] funct3, input [7:0] addr, input [31:0] data_in, output reg [31:0]data_out);

    reg [7:0] mem [0:511];
    wire [9:0] offset;
    wire [9:0] addr_plus_offset;
    
    
    assign addr_plus_offset = addr + offset;
    assign offset = 9'd256;
    
    always @ (*)
    begin
     if (clk)  
        data_out <= {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
     else if(MemRead) begin
                case(funct3)
                3'b000:  data_out <=  {{24{mem[addr_plus_offset][7]}},mem[addr_plus_offset]}; //LB
                3'b001:  data_out <=  {{16{mem[addr_plus_offset+1][7]}},mem[addr_plus_offset+1],mem[addr_plus_offset]};  //LH
                3'b010:  data_out <=  {mem[addr_plus_offset+3],mem[addr_plus_offset+2],mem[addr_plus_offset+1],mem[addr_plus_offset]};   //lw
                3'b100:  data_out <= {{24{1'b0}},mem[addr_plus_offset]};  //LBU
                3'b101:  data_out <= {{16{1'b0}},mem[addr_plus_offset+1],mem[addr_plus_offset]};  //LHU
                default: data_out <= 0;
            endcase
        end
        else data_out = 32'b0;
end
    always@(posedge clk) begin
        if(MemWrite) begin
            case(funct3)
            3'b000: mem[addr_plus_offset] = data_in[7:0]; //sb
            3'b001: {mem[addr_plus_offset+1],mem[addr_plus_offset]} = data_in[15:0];//sh
            3'b010: {mem[addr_plus_offset+3],mem[addr_plus_offset+2],mem[addr_plus_offset+1],mem[addr_plus_offset]} = data_in;//sw
            endcase
        end
    end
                
/*
always@(*) begin

    if (clk==0)
        //read data
        if(memRead) begin
            case(funct3)
            3'b000:  data_out =  {{24{mem[addr_offset][7]}},mem[addr_offset]}; //LB
            3'b001:  data_out =  {{16{mem[addr_offset+1][7]}},mem[addr_offset+1],mem[addr_offset]};  //LH
            3'b010:  data_out =  {mem[addr_offset+3],mem[addr_offset+2],mem[addr_offset+1],mem[addr_offset]};   //lw
            3'b100:  data_out = {{24{1'b0}},mem[addr_offset]};  //LBU
            3'b101:  data_out = {{16{1'b0}},mem[addr_offset+1],mem[addr_offset]};  //LHU
            endcase
        end
       
        else data_out = 0;
    else
        data_out <= {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
end
*/

initial begin
    {mem[3],mem[2],mem[1],mem[0]}            =   32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0    
    {mem[7],mem[6],mem[5],mem[4]}            =   32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)                                                                                                                          
    {mem[11],mem[10],mem[9],mem[8]}          =   32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)        
    {mem[15],mem[14],mem[13],mem[12]}        =   32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)        
    {mem[19],mem[18],mem[17],mem[16]}        =   32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2      
    {mem[23],mem[22],mem[21],mem[20]}        =   32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 4        
    {mem[27],mem[26],mem[25],mem[24]}        =   32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2    
    {mem[31],mem[30],mem[29],mem[28]}        =   32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2    
    {mem[35],mem[34],mem[33],mem[32]}        =   32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)      
    {mem[39],mem[38],mem[37],mem[36]}        =   32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)      
    {mem[43],mem[42],mem[41],mem[40]}        =   32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0    
    {mem[47],mem[46],mem[45],mem[44]}        =   32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1    
    {mem[51],mem[50],mem[49],mem[48]}        =   32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2    
    {mem[55],mem[54],mem[53],mem[52]}        =   32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2    
    {mem[59],mem[58],mem[57],mem[56]}        =   32'h00718113 ; //add x9, x0, x1
    {mem[63],mem[62],mem[61],mem[60]}        =   32'h0040006F; //jal x0, 4
    {mem[64],mem[63],mem[62],mem[61]}        =   32'h0011e113 ;//ori x2, x3, 1 
    {mem[68],mem[67],mem[66],mem[65]}        =   32'h00100073 ; //ebreak
//    {mem[67],mem[66],mem[65],mem[64]}        =            
//    {mem[71],mem[70],mem[69],mem[68]}        =      
//    {mem[75],mem[74],mem[73],mem[72]}        =      
//    {mem[79],mem[78],mem[77],mem[76]}        =      
//    {mem[83],mem[82],mem[81],mem[80]}        =      
//    {mem[87],mem[86],mem[85],mem[84]}        =      
//    {mem[91],mem[90],mem[89],mem[88]}        =      
//    {mem[95],mem[94],mem[93],mem[92]}        =      
//    {mem[99],mem[98],mem[97],mem[96]}        =      
//    {mem[103],mem[102],mem[101],mem[100]}    =      
//    {mem[107],mem[106],mem[105],mem[104]}    =      
//    {mem[111],mem[110],mem[109],mem[108]}    =      
//    {mem[115],mem[114],mem[113],mem[112]}    =      
//    {mem[119],mem[118],mem[117],mem[116]}    =      
//    {mem[123],mem[122],mem[121],mem[120]}    =      
//    {mem[127],mem[126],mem[125],mem[124]}    =      
//    {mem[131],mem[130],mem[129],mem[128]}    =      
//    {mem[135],mem[134],mem[133],mem[132]}    =      
//    {mem[139],mem[138],mem[137],mem[136]}    =      
//    {mem[143],mem[142],mem[141],mem[140]}    =      
//    {mem[147],mem[146],mem[145],mem[144]}    =      
//    {mem[151],mem[150],mem[149],mem[148]}    =      
//    {mem[155],mem[154],mem[153],mem[152]}    =      
//    {mem[159],mem[158],mem[157],mem[156]}    =      
//    {mem[163],mem[162],mem[161],mem[160]}    =      
//    {mem[167],mem[166],mem[165],mem[164]}    =      
//    {mem[171],mem[170],mem[169],mem[168]}    =      
//    {mem[175],mem[174],mem[173],mem[172]}    =      
//    {mem[179],mem[178],mem[177],mem[176]}    =      
//    {mem[183],mem[182],mem[181],mem[180]}    =      
//    {mem[187],mem[186],mem[185],mem[184]}    =      
//    {mem[191],mem[190],mem[189],mem[188]}    =      
//    {mem[195],mem[194],mem[193],mem[192]}    =      
//    {mem[199],mem[198],mem[197],mem[196]}    =      
//    {mem[203],mem[202],mem[201],mem[200]}  


 end
initial begin
    {mem[259],mem[258],mem[257],mem[256]} = 32'd17;
    {mem[263],mem[262],mem[261],mem[260]} = 32'd9;
    {mem[267],mem[266],mem[265],mem[264]} = 32'd25;
 end

endmodule