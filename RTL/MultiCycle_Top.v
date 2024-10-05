module MultiCycle_Top (
	input clk,reset_n,
	output [31:0] writedata,dataadr,
	output memwrite
);

wire [31:0] ReadData;

Instr_Data_Mem mem_inst (
	
	.clk(clk),
	.A(dataadr),
	.WE(memwrite),
	.WD(writedata),
	.RD(ReadData)
);

Mips_Mutlti_Cycle mips (

	.clk(clk),.reset_n(reset_n),
	.adr(dataadr),.writedata(writedata),
	.readdata(ReadData),
	.memwrite(memwrite)
);

endmodule