module testbench();

logic clk = 0;
logic reset = 1;
logic [31:0] WriteData, DataAdr;
logic MemWrite;

top dut(clk, reset, WriteData, DataAdr, MemWrite);

initial begin
    #22;
    reset = 0;
end

always #5 clk = ~clk;

always @(negedge clk) begin
    if (MemWrite) begin
        if (DataAdr === 100 && WriteData === 25) begin
            $display("Simulation succeeded");
            $stop;
        end
        else if (DataAdr !== 96) begin
            $display("Simulation failed");
            $stop;
        end
    end
end

endmodule