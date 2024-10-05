module maindec2 (
    input clk,
    input reset,
    input [5:0] op,
    
    output pcwrite,
    output memwrite,
    output irwrite,
    output regwrite,
    output alusrca,
    output branch,
    output iord,
    output memtoreg,
    output regdst,
    output [1:0] alusrcb,
    output [1:0] pcsrc,
    output [1:0] aluop
);

reg [3:0] state_reg, state_next;
localparam Fetch = 4'd0, Decode = 4'd1, MemAdr = 4'd2, MemRead = 4'd3, 
           MemWriteback = 4'd4, Mem_Write = 4'd5, Execute = 4'd6, 
           ALUWriteback = 4'd7, BranchState = 4'd8, ADDIExecute = 4'd9, 
           ADDIWriteback = 4'd10, Jump = 4'd11;

always @ (posedge clk or negedge reset) begin
    if (~reset)
        state_reg <= Fetch;
    else
        state_reg <= state_next;
end

always @ (*) begin
    state_next = state_reg;
    case (state_reg)
        Fetch:
            state_next = Decode;
        
        Decode: begin
            case (op)
                6'b000000: // R-type
                    state_next = Execute;
                
                6'b100011: // lw
                    state_next = MemAdr;
                
                6'b101011: // sw
                    state_next = MemAdr;
                
                6'b000100: // beq
                    state_next = BranchState;
                
                6'b001000: // addi
                    state_next = ADDIExecute;
                
                6'b000010: // j
                    state_next = Jump;
                default: 
                    state_next = Fetch;
            endcase
        end
        
        MemAdr: begin
            case (op)
                6'b100011: // lw
                    state_next = MemRead;
                
                6'b101011: // sw
                    state_next = Mem_Write;
                default: 
                    state_next = Fetch;
            endcase
        end
        
        Mem_Write:
            state_next = Fetch;
        
        MemRead:
            state_next = MemWriteback;
        
        MemWriteback:
            state_next = Fetch;
        
        Execute:
            state_next = ALUWriteback;
        
        ALUWriteback:
            state_next = Fetch;
        
        BranchState:
            state_next = Fetch;
        
        ADDIExecute:
            state_next = ADDIWriteback;
        
        ADDIWriteback:
            state_next = Fetch;
        
        Jump:
            state_next = Fetch;
        
        default:
            state_next = Fetch;
    endcase
end

reg [14:0] controls;
// 19'b0______0________0________0/_\____0______0_____0_______0_____0__/-\_00_____00_/-\00
assign {pcwrite, memwrite, irwrite, regwrite, alusrca, branch, iord, memtoreg, regdst, alusrcb, pcsrc, aluop} = controls;

always @ (*) begin
    controls = 15'b0000_00000_0000_00;
    case (state_reg)
        Fetch: controls = 15'b1010_00000_0100_00;
        Decode: controls = 15'b0000_00000_1100_00;
        MemAdr: controls = 15'b0000_10000_1000_00;
        Mem_Write: controls = 15'b0100_00100_0000_00;
        MemRead: controls = 15'b0000_00100_0000_00;
        MemWriteback: controls = 15'b0001_00010_0000_00;
        Execute: controls = 15'b0000_10000_0000_10;
        ALUWriteback: controls = 15'b0001_00001_0000_00;
        BranchState: controls = 15'b0000_11000_0001_01;
        ADDIExecute: controls = 15'b0000_10000_1000_00;
        ADDIWriteback: controls = 15'b0001_00000_0000_00;
        Jump: controls = 15'b1000_00000_0010_00;
        default: controls = 15'b0000_00000_0000_00;
    endcase
end

endmodule
