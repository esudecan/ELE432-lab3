module datapath(
    input logic clk,
    input logic reset,
    input logic [1:0] ALUSrcA,
    input logic [1:0] ALUSrcB,
    input logic [1:0] ResultSrc,
    input logic AdrSrc,
    input logic [2:0] ALUControl,
    input logic IRWrite,
    input logic PCWrite,
    input logic RegWrite,
    input logic [1:0] ImmSrc,
    input logic [31:0] ReadData,
    output logic [31:0] Adr,
    output logic [31:0] WriteData,
    output logic [31:0] Instr,
    output logic Zero
);

logic [31:0] PC;
logic [31:0] OldPC;
logic [31:0] Data;
logic [31:0] A;
logic [31:0] RD2;
logic [31:0] ImmExt;
logic [31:0] SrcA;
logic [31:0] SrcB;
logic [31:0] ALUResult;
logic [31:0] ALUOut;
logic [31:0] Result;
logic [31:0] PCNext;
logic [31:0] RD1;
logic [4:0]  rs1, rs2, rd;

assign Adr       = AdrSrc ? Result : PC;  
assign WriteData = RD2;
assign PCNext = PCWrite ? Result : PC;

assign rs1 = Instr[19:15];
assign rs2 = Instr[24:20];
assign rd  = Instr[11:7];
assign A   = RD1;

flopenr #(32) instrreg(
    .clk(clk), .reset(reset),
    .en(IRWrite),
    .d(ReadData),
    .q(Instr)
);
    
flopr #(32) pcreg(
    .clk(clk), .reset(reset),
    .d(PCNext),
    .q(PC)
);

flopenr #(32) oldpcreg(
    .clk(clk), .reset(reset),
    .en(IRWrite),
    .d(PC),        
    .q(OldPC)
);

regfile rf(
    .clk(clk),
    .WE3(RegWrite),
    .A1(rs1), .A2(rs2), .A3(rd),
    .WD3(Result),
    .RD1(RD1), .RD2(RD2)
);

extend ext(
    .instr(Instr[31:7]),
    .immsrc(ImmSrc),
    .immext(ImmExt)
);

always_comb begin
    case (ALUSrcA)
        2'b00:   SrcA = PC;
        2'b01:   SrcA = OldPC;
        2'b10:   SrcA = A;
        default: SrcA = 32'b0;
    endcase
end

always_comb begin
    case (ALUSrcB)
        2'b00:   SrcB = WriteData;   // RD2
        2'b01:   SrcB = ImmExt;
        2'b10:   SrcB = 32'd4;
        default: SrcB = 32'b0;
    endcase
end

alu aluunit(
    .a(SrcA), .b(SrcB),
    .alucontrol(ALUControl),
    .result(ALUResult),
    .zero(Zero)
);

flopr #(32) aluoutreg(
    .clk(clk), .reset(reset),
    .d(ALUResult),
    .q(ALUOut)
);

always_comb begin
    case (ResultSrc)
        2'b00:   Result = ALUOut;
        2'b01:   Result = Data;
        2'b10:   Result = ALUResult;   
        default: Result = 32'b0;
    endcase
end

flopr #(32) datareg(
    .clk(clk), .reset(reset),
    .d(ReadData),
    .q(Data)
);

endmodule
