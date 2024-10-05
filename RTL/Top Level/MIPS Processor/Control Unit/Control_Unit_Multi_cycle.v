module Control_Unit_Multi_cycle (

input clk, reset_n, Zero,
    input [5:0] Op, Funct,
    output IRWrite, MemWrite, ALUSrcA, RegDst, RegWrite, IorD, PCEn, MemtoReg,
    output [1:0] ALUSrcB, PCSrc,
    output [2:0] ALUControl
);

    wire [1:0] aluop;
    wire branch, pcwrite;

    // Main Decoder and ALU Decoder subunits.
    maindec2 md(
        .clk(clk), .reset(reset_n), 
        .op(Op),
        .pcwrite(pcwrite), .memwrite(MemWrite), 
        .irwrite(IRWrite), .regwrite(RegWrite),
        .alusrca(ALUSrcA), .branch(branch), 
        .iord(IorD), .memtoreg(MemtoReg), 
        .regdst(RegDst), .alusrcb(ALUSrcB), 
        .pcsrc(PCSrc), .aluop(aluop)
    );

    aludec ad(
        .funct(Funct), 
        .aluop(aluop), 
        .alucontrol(ALUControl)
    );

    assign PCEn = pcwrite | (branch & Zero);

endmodule
