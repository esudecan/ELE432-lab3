module controller(
    input logic clk,
    input logic reset,
    input logic [6:0] op,
    input logic [2:0] funct3,
    input logic funct7b5,
    input logic Zero,

    output logic [1:0] ALUSrcA,
    output logic [1:0] ALUSrcB,
    output logic [1:0] ResultSrc,
    output logic AdrSrc,
    output logic [2:0] ALUControl,
    output logic IRWrite,
    output logic PCWrite,
    output logic RegWrite,
    output logic MemWrite,
    output logic [1:0] ImmSrc
);

logic [1:0] ALUOp;

mainfsm mfsm(
    .clk(clk),
    .reset(reset),
    .op(op),
    .Zero(Zero),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .ResultSrc(ResultSrc),
    .AdrSrc(AdrSrc),
    .ALUOp(ALUOp),
    .IRWrite(IRWrite),
    .PCWrite(PCWrite),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .ImmSrc(ImmSrc)
);

aludec ad(
    .opb5(op[5]),
    .funct3(funct3),
    .funct7b5(funct7b5),
    .ALUOp(ALUOp),
    .ALUControl(ALUControl)
);

endmodule