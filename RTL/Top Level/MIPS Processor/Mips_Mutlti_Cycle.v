module Mips_Mutlti_Cycle (
	
	input clk,reset_n,
	output  [31:0] adr,writedata,
	input [31:0] readdata,
	output  memwrite
	
);


wire [2:0] ALUControl ;
wire Zero,ALUSrcA,RegDst,RegWrite,PCEn,MemtoReg;
wire [1:0] PCSrc,ALUSrcB;
wire [5:0] OP,Funct;
wire IRWrite,IorD;

Control_Unit_Multi_cycle u2 (
	.clk(clk),
	.reset_n(reset_n),
	.Funct(Funct),
	.Op(OP),
	.Zero(Zero),
	.IRWrite(IRWrite),
	.MemWrite(memwrite),
	.ALUSrcA(ALUSrcA),
	.RegDst(RegDst),
	.RegWrite(RegWrite),
	.IorD(IorD),
	.ALUSrcB(ALUSrcB),
	.PCSrc(PCSrc),
	
	.ALUControl(ALUControl),
	.MemtoReg(MemtoReg),
	.PCEn(PCEn)
);

datapath u1 (
	.clk(clk),.reset_n(reset_n),
	.ReadData(readdata),
	.Adr(adr),
	.WriteData(writedata),
	.IorD(IorD),
	.IRWrite(IRWrite),
	.RegDst(RegDst),
	.RegWrite(RegWrite),
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.PCSrc(PCSrc),
	.MemtoReg(MemtoReg),
	.ALUControl(ALUControl),
	.PCEn(PCEn),
	.Zero(Zero),
	.OP(OP),
	.Funct(Funct)
);

endmodule