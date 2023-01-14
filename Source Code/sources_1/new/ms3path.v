`timescale 1ns / 1ps
`include "definesms3.vh"


/*
    RISC-V Pipelined Processor
    Computer Architecture
    Yaseen Ahmed
    Abdalla Saba
    Nov 23, 2022
*/


module ms3path(input clk, rst, SSDClock, [1:0] ledSel, [3:0] ssdSel, output reg [15:0] leds, output [3:0] Anode, output [6:0] LED_out);
    wire load = 1'b1;
    wire not_terminate=1'b1;
    wire branch, mem_read, mem_write, reg_write, memtoreg ,ALUsrc, EX_MEM_Zero; 
    wire [1:0]ALUOp;
    wire [31:0]immgen_out, read_data1, read_data2, instr_out, mux_out, mux_in, adder_out,pc_out, write_data, ALU_out,
    mem_out,IF_ID_PC, IF_ID_Inst,ID_EX_PC, ID_EX_regR1, ID_EX_regR2 , ID_EX_imm,  EX_MEM_BranchAddOut, EX_MEM_ALU_out,
    EX_MEM_RegR2;
    wire fence_flag,forward_A, forward_B, z_flag, c_flag, s_flag, v_flag, b_flag;
    wire not_terminate=1'b1;
    wire [1:0]branch_control_out;
    wire [3:0] ALUsel;
    wire [31:0] pc_in;
    reg  [12:0] SSD;
    wire [3:0] ID_EX_Func,EX_MEM_func;
    wire [4:0] ID_EX_Rd;
    wire [7:0]ID_EX_Ctrl;// 7branch , 6memread, 5memtoreg, 4memwruite, 3alusrc, 2regwrite, 1:0aluop
    wire [4:0] ID_EX_rs1, ID_EX_rs2;
    wire [7:0] EX_MEM_Ctrl, memory_input;
    wire [4:0] EX_MEM_Rd,MEM_WB_Rd;
    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out;
    wire [7:0] MEM_WB_Ctrl;
    wire [1:0] write_reg_mux_sel;
    wire [31:0] ID_EX_RS1_MUX_OUT, ID_EX_RS2_MUX_OUT,IF_ID_ADDER,ID_EX_ADDER, EX_MEM_ADDER, MEM_WB_ADDER, MEM_WB_BranchAddOut, regfileinput, IF_ID_mem_out, ID_EX_mem_out,EX_MEM_mem_out;
    wire [4:0] shamt, ID_EX_OPCODE,EX_MEM_OPCODE;
    wire [7:0] decoding_flush_mux_out;
    
    
    mux21#(8) mem_input_mux(EX_MEM_ALU_out[7:0],pc_out[7:0], clk, memory_input);
    memory mem(clk, EX_MEM_Ctrl[6], EX_MEM_Ctrl[4], EX_MEM_func[2:0],memory_input, EX_MEM_RegR2, mem_out); 
    /////////////////////////////////////stage 1////////////////////////////////////////////
    mux41 branch_mux(adder_out, EX_MEM_BranchAddOut, EX_MEM_ALU_out, 32'd0, branch_control_out, pc_in);
    register #(32) pc(.clk(clk), .load(load & not_terminate), .rst(rst | fence_flag), .in(pc_in), .out(pc_out));
    assign adder_out = pc_out + 4;
    assign instr_out = mem_out;
    register #(128) IF_ID(~clk,load,rst,{pc_out, instr_out,adder_out,mem_out}, {IF_ID_PC, IF_ID_Inst,IF_ID_ADDER,IF_ID_mem_out}); 
    
    //////////////////////////////////////stage 2///////////////////////////////////////////////
    controlunitproj contr_unit(IF_ID_Inst[6:2], branch, mem_read, memtoreg, mem_write, ALUsrc, reg_write,b_flag,fence_flag, ALUOp,write_reg_mux_sel); //control unit
    reg_file #(32) regfile(~clk, rst, MEM_WB_Ctrl[2] ,MEM_WB_Rd, {IF_ID_Inst[19:15]}, {IF_ID_Inst[24:20]},regfileinput, read_data1, read_data2); // output of mux instead of write_data for jalr jal auipc
    mux41 regfilereg(EX_MEM_BranchAddOut, MEM_WB_ADDER,write_data,32'd0, write_reg_mux_sel, regfileinput);
    immgen immd_gen(IF_ID_Inst, immgen_out);
    register #(224) ID_EX (clk, load, rst, 
    {
        decoding_flush_mux_out, IF_ID_PC, read_data1, read_data2, 
        immgen_out,{IF_ID_Inst[30],IF_ID_Inst[14:12]},IF_ID_Inst[19:15], IF_ID_Inst [24:20], IF_ID_Inst[11:7],IF_ID_ADDER,
        IF_ID_Inst[6:2],IF_ID_mem_out
    },
    {
        ID_EX_Ctrl,ID_EX_PC, ID_EX_regR1, ID_EX_regR2 , ID_EX_imm, ID_EX_Func, ID_EX_rs1, ID_EX_rs2, ID_EX_Rd, ID_EX_ADDER,
        ID_EX_OPCODE,ID_EX_mem_out
    });
    mux21 #(8) flushing_mux({branch, mem_read, memtoreg, mem_write, ALUsrc, reg_write, ALUOp}, 8'b0, (branch_control_out != 2'b00), decoding_flush_mux_out);
    mux21#(32) ID_EX_RS1_MUX(ID_EX_regR1, write_data, forward_A, ID_EX_RS1_MUX_OUT );
    mux21#(32) ID_EX_RS2_MUX(ID_EX_regR2, write_data, forward_B, ID_EX_RS2_MUX_OUT);
    mux21#(32) ALU_in (ID_EX_RS2_MUX_OUT, ID_EX_imm, ID_EX_Ctrl[3], mux_out);
    /////////////////////////////////////stage 3//////////////////////////////////////////////////
    alucontrolproj alu_contr_unit(ID_EX_Ctrl[1:0],ID_EX_OPCODE,ID_EX_Func[2:0], ID_EX_Func[3], ALUsel); 
    adder branch_adder  (ID_EX_PC, ID_EX_imm, mux_in);// ID_EX_imm instead of shiftout
    prv32_ALU ALU(ID_EX_RS1_MUX_OUT, mux_out, ALU_out, c_flag, z_flag, v_flag, s_flag, ALUsel); // i have removed the shamt
    register #(183) EX_MEM (~clk,load,rst,{ID_EX_Func,ID_EX_Ctrl,mux_in,z_flag,ALU_out, ID_EX_RS2_MUX_OUT, ID_EX_Rd,ID_EX_ADDER, ID_EX_OPCODE, ID_EX_mem_out},
    {EX_MEM_func,EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_Zero, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd, EX_MEM_ADDER, EX_MEM_OPCODE,EX_MEM_mem_out});
    branch_control branchingunit(EX_MEM_OPCODE, EX_MEM_Ctrl[7], z_flag, c_flag, s_flag, v_flag, branch_control_out);
    forwarding_unit FW(ID_EX_rs1,ID_EX_rs2,EX_MEM_Rd,MEM_WB_Rd, EX_MEM_Ctrl[2], MEM_WB_Ctrl[2], forward_A, forward_B);
        
   //////////////////////////////////////stage 4///////////////////////////////////////////////////////// 
    register #(141) MEM_WB (clk,load,rst,{EX_MEM_Ctrl, mem_out,EX_MEM_ALU_out, EX_MEM_Rd,EX_MEM_ADDER,EX_MEM_BranchAddOut},
    {MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd,MEM_WB_ADDER, MEM_WB_BranchAddOut});
   
    ////////////////////////////////////stage 5//////////////////////////////////////////////////
    mux21#(32) data_mem_mux(MEM_WB_ALU_out, MEM_WB_Mem_out, MEM_WB_Ctrl[5], write_data);
    Four_Digit_Seven_Segment_Driver_Optimized displayer(SSDClock,SSD,Anode, LED_out);
    /*always @(*) begin
    case (ledSel)
    2'b00:leds=mem_out[15:0];
    2'b01:leds=mem_out[31:16];
    2'b10:leds={8'b00000000,ALUOp, ALUsel,z_flag,{z_flag&branch}};
    endcase
    end */ 
    
    always @(*) begin
        case(ledSel) 
            2'b00: leds = mem_out[15:0];
            2'b01: leds = mem_out[31:16];
            2'b10: leds = {2'b00, branch, mem_read, memtoreg, mem_write, ALUsrc, reg_write, ALUOp, ALUsel, z_flag, branch_control_out};
            default: leds = mem_out[15:0];
        endcase
    end
    
    
    always @(*) begin
        case(ssdSel) 
            4'b000: SSD = pc_out[12:0]; 
            4'b001: SSD = adder_out[12:0]; 
            4'b010: SSD = EX_MEM_BranchAddOut[12:0]; 
            4'b011: SSD = ID_EX_imm[12:0]; 
            4'b100: SSD = write_data[12:0]; 
            4'b101: SSD = MEM_WB_ALU_out[12:0]; 
    
        default: SSD = pc_out[12:0];

        endcase
    end
    /*always @(*) begin
    case (ssdSel)
    4'b0000: SSD=pc_out[12:0];
    4'b0001: SSD=adder_out[12:0];
    4'b0010: SSD=mux_in[12:0];
    4'b0011: SSD=pc_in[12:0];
    4'b0100: SSD=read_data1[12:0];
    4'b0101: SSD=read_data2[12:0];
    4'b0110: SSD=write_data[12:0];
    4'b0111: SSD=immgen_out[12:0];
    4'b1000: SSD=immgen_out[12:0];// changed shift_out to immgen
    4'b1001: SSD=mux_out[12:0];
    4'b1010: SSD=ALU_out[12:0];
    4'b1011: SSD=mem_out[12:0];
    4'b1100: SSD=IF_ID_Inst[11:7];
    endcase
    end */
endmodule