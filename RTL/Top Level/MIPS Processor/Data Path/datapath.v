module datapath(
    input clk, reset_n,
    input PCEn, IRWrite, RegWrite,
    input ALUSrcA, IorD, MemtoReg, RegDst,
    input [1:0] ALUSrcB, PCSrc,
    input [2:0] ALUControl,
    output [5:0] OP, Funct,
    output Zero,
    output [31:0] Adr, WriteData,
    input [31:0] ReadData
);

wire [31:0] PC,pcin,Instr,PCJump;
wire [31:0] PCIn,SignImm,SignImm_s2,ALUResult,ALUOut;
wire [31:0] RD1,RD2;
wire [31:0] A,B,Data,c0,WD3;
wire [31:0] in [31:0];

assign PCJump = {PC[31:28],Instr[25:0],2'b00};


D_reg_en int1 (

	.clk(clk),.reset_n(reset_n),.en(PCEn),
	.D(pcin),
	.Q(PC)
);

PCMux pc_inst(
	
	.w0(ALUResult),.w1(ALUOut),.w2(PCJump),
	.sel(PCSrc),
	.f(pcin)
	
);


D_reg_en instr_ff(
	
	.clk(clk),.reset_n(reset_n),.en(IRWrite),
	.D(ReadData),
	.Q(Instr)

);

D_reg A_ff(
	
	.clk(clk),.reset_n(reset_n),
	.D(RD1),
	.Q(A)

);

D_reg B_ff(
	
	.clk(clk),.reset_n(reset_n),
	.D(RD2),
	.Q(B)

);

D_reg ALU_ff(
	
	.clk(clk),.reset_n(reset_n),
	.D(ALUResult),
	.Q(ALUOut)

);
D_reg Data_ff(
	
	.clk(clk),.reset_n(reset_n),
	.D(ReadData),
	.Q(Data)

);

reg_file inst2 (
	
	.clk(clk),
	.A1(Instr[25:21]),.A2(Instr[20:16]),.A3(RegDst?Instr[15:11]:Instr[20:16]),
	.WE3(RegWrite),
	.WD3(MemtoReg ?Data : ALUOut),
	.RD1(RD1),.RD2(RD2)

);

sign_extend inst3 (

	.imm(Instr[15:0]),
	.imm_ext(SignImm)
);

shifter s2(
   .a(SignImm),
   .y(SignImm_s2)
);

alu data_adder (

	.A(ALUSrcA ?A:PC),.B(ALUSrcB[1]? (ALUSrcB[0] ?SignImm_s2 : SignImm):(ALUSrcB[0] ? 32'b100:B)),
	.F(ALUControl),
	.zero(Zero),
	.Y(ALUResult)

);

assign Funct = Instr[5:0];
assign OP = Instr[31:26];
assign Adr = IorD ? ALUOut:PC;
assign WriteData = B;

endmodule