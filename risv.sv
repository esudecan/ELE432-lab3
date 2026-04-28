module riscv(
    input logic clk,
    input logic reset,
    output logic [31:0] Adr,
    output logic [31:0] WriteData,
    input logic [31:0] ReadData,
    output logic MemWrite
);

logic [31:0] Instr;
logic [31:0] Data;
logic Zero;

logic [1:0] ALUSrcA;
logic [1:0] ALUSrcB;
logic [1:0] ResultSrc;
logic       AdrSrc;
logic [2:0] ALUControl;
logic       IRWrite;
logic       PCWrite;
logic       RegWrite;
logic       ALUOutWrite;
logic       OldPCWrite;
logic       MemDataWrite;
logic [1:0] ImmSrc;

controller c(
    .clk(clk),
    .reset(reset),
    .op(Instr[6:0]),
    .funct3(Instr[14:12]),
    .funct7b5(Instr[30]),
    .Zero(Zero),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .ResultSrc(ResultSrc),
    .AdrSrc(AdrSrc),
    .ALUControl(ALUControl),
    .IRWrite(IRWrite),
    .PCWrite(PCWrite),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .ImmSrc(ImmSrc)
);

datapath dp(
    .clk(clk),
    .reset(reset),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .ResultSrc(ResultSrc),
    .AdrSrc(AdrSrc),
    .ALUControl(ALUControl),
    .IRWrite(IRWrite),
    .PCWrite(PCWrite),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ReadData(ReadData),
    .Adr(Adr),
    .WriteData(WriteData),
    .Instr(Instr),
    .Zero(Zero)
);

endmodule