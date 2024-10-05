module alu (

	input [31:0] A,B,
	input [2:0] F,
	output reg [31:0] Y,
	output zero

);

always @(*)
begin
	
	Y=0;
	case (F)
	3'b000: Y = A & B;
	3'b001: Y = A | B;
	3'b010: Y = A + B;
	3'b100: Y = A & ~B;
	3'b101: Y = A | ~B;
	3'b110: Y = A - B;
	3'b111: Y = A < B;
	default : begin
			Y=0;
	end
	
	endcase

end

assign zero = (Y==0);


endmodule