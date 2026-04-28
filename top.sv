module top(
    input logic clk,
    input logic reset,
    output logic [31:0] WriteData,
    output logic [31:0] DataAdr,
    output logic MemWrite
);

logic [31:0] ReadData;
logic [31:0] Adr;

riscv r(
    .clk(clk),
    .reset(reset),
    .Adr(Adr),
    .WriteData(WriteData),
    .ReadData(ReadData),
    .MemWrite(MemWrite)
);

memory mem(
    .clk(clk),
    .we(MemWrite),
    .a(Adr),
    .wd(WriteData),
    .rd(ReadData)
);

assign DataAdr = Adr;

endmodule