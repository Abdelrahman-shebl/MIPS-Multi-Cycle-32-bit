module D_reg (
	
	input clk,reset_n,
	input [31:0] D,
	output reg [31:0] Q

);

always @ (posedge clk,negedge reset_n)
	
	if (~reset_n)
		Q <= 32'b0;
	else
		Q <= D;

endmodule