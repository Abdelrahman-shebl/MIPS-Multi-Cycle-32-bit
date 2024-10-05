module PCMux (
	
	input [31:0] w0,w1,w2,
	input [1:0] sel,
	output reg [31:0] f

);

always @ (*)
begin

	case (sel)
	
		2'b00:f=w0;
		2'b01:f=w1;
		2'b10:f=w2;
		default:f=32'bx;
	
	endcase

end

endmodule