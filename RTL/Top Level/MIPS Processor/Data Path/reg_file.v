module reg_file (
	
	input clk,WE3,
	input [4:0] A1,A2,A3,
	input [31:0] WD3,
	output [31:0] RD1,RD2
	

);
reg [31:0] mem [31:0];

integer i;
initial
begin
	
	for (i=0;i<32;i=i+1)
		mem [i]=i;

end

always @ (posedge clk)

		if (WE3)
		mem [A3] <= WD3;


assign RD1 = (A1 !=0 ) ?mem[A1] :0;
assign RD2 = (A2 !=0 ) ?mem[A2] :0;

endmodule