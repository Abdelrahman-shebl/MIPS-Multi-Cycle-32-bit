module tb_MultiCycle_Top();
  reg clk;
    reg reset_n;
    wire [31:0] writedata, dataadr;
    wire memwrite;

    MultiCycle_Top uut(clk, reset_n,writedata,dataadr, memwrite);

initial
begin
    reset_n = 0; #5 reset_n =1;
	
end

always
begin
	clk = 1; #5; clk =0; #5;
end

always @ (negedge clk)
begin
	if(dataadr==0  )
	begin
		if(writedata ==7 & memwrite )begin
			$display("simulation Succeeded");
			$stop;
			end
		
	end
		
end
endmodule
