`timescale 1ns / 1ps

module SinglePortRAM_tb;

    // Parameters for the RAM module
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    // Testbench signals
    reg                 clk;
    reg                 reset;
    reg                 we;
    reg  [ADDR_WIDTH-1:0] addr;
    reg  [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;

    // Instantiate the Unit Under Test (UUT)
    SinglePortRAM #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .we(we),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Initial block for stimulus generation
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        we = 0;
        addr = 0;
        din = 0;

        // Apply reset for a few clock cycles
        $display("Applying reset...");
        repeat(3) @(posedge clk);
        reset = 0;
        @(posedge clk);
        $display("Reset released. Starting test...");

        // --- Write Operations ---
        $display("--- Writing to RAM ---");
        // Write '8' to address 0
        we = 1;
        addr = 4'd0;
        din = 8'd8;
        @(posedge clk);

        // Write '42' to address 5
        addr = 4'd5;
        din = 8'd42;
        @(posedge clk);

        // Write '255' to address 15
        addr = 4'd15;
        din = 8'd255;
        @(posedge clk);

        // Stop writing
        we = 0;
        @(posedge clk);

        // --- Read Operations ---
        $display("--- Reading from RAM ---");
        // Read from address 0 (expect '8')
        addr = 4'd0;
        @(posedge clk); // Wait for one cycle due to read latency
        $display("Reading from address 0. Expected: 8, Got: %d", dout);

        // Read from address 5 (expect '42')
        addr = 4'd5;
        @(posedge clk);
        $display("Reading from address 5. Expected: 42, Got: %d", dout);

        // Read from address 15 (expect '255')
        addr = 4'd15;
        @(posedge clk);
        $display("Reading from address 15. Expected: 255, Got: %d", dout);

        // Read from an unwritten address (expect unknown value)
        addr = 4'd8;
        @(posedge clk);
        $display("Reading from address 8. Expected: Unknown, Got: %d", dout);

        // End of simulation
        @(posedge clk);
        $display("Test finished.");
        $finish;
    end

    // Display all signals in the simulation console
    initial begin
        $monitor("Time=%0t: clk=%b, reset=%b, we=%b, addr=%d, din=%d, dout=%d",
            $time, clk, reset, we, addr, din, dout);
    end

endmodule

