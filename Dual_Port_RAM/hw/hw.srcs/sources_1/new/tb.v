`timescale 1ns / 1ps


module tb_DualPortRAM;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    // Testbench signals
    reg clk;
    reg reset;
    reg we_a, we_b;
    reg [ADDR_WIDTH-1:0] addr_a, addr_b;
    reg [DATA_WIDTH-1:0] din_a, din_b;
    wire [DATA_WIDTH-1:0] dout_a, dout_b;

    // Instantiate the DualPortRAM Unit Under Test (UUT)
    DualPortRAM #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .we_a(we_a), .addr_a(addr_a), .din_a(din_a), .dout_a(dout_a),
        .we_b(we_b), .addr_b(addr_b), .din_b(din_b), .dout_b(dout_b)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;  // 10ns period

    initial begin
        $display("Starting Dual-Port RAM Test...");

        // --- Test Sequence ---

        // 1. Reset Phase
        $display("--- Applying Reset ---");
        reset = 1;
        we_a = 0; we_b = 0;
        addr_a = 0; addr_b = 0;
        din_a = 0; din_b = 0;
        repeat(2) @(posedge clk);
        reset = 0;
        @(posedge clk);
        $display("Reset released. All outputs should be 0.");

        // 2. Write Operations - Independent
        $display("--- Writing to separate addresses ---");
        // Write to Port A and Port B in parallel
        we_a = 1; addr_a = 4'h1; din_a = 8'hAA;
        we_b = 1; addr_b = 4'h3; din_b = 8'hBB;
        @(posedge clk);
        
        // Write to different addresses
        addr_a = 4'h2; din_a = 8'hCC;
        addr_b = 4'h4; din_b = 8'hDD;
        @(posedge clk);

        // Stop writing
        we_a = 0;
        we_b = 0;
        @(posedge clk);
        $display("Writes complete. Reading back data now.");

        // 3. Read Operations
        $display("--- Reading from written addresses ---");
        // Read from Port A address 1 and Port B address 3
        addr_a = 4'h1;
        addr_b = 4'h3;
        @(posedge clk); // Wait for one cycle due to read latency
        $display("Read A Addr 1: %h (Expected: AA)", dout_a);
        $display("Read B Addr 3: %h (Expected: BB)", dout_b);

        // Read from Port A address 2 and Port B address 4
        addr_a = 4'h2;
        addr_b = 4'h4;
        @(posedge clk);
        $display("Read A Addr 2: %h (Expected: CC)", dout_a);
        $display("Read B Addr 4: %h (Expected: DD)", dout_b);

        // 4. Test Simultaneous Write to Same Address
        $display("--- Testing simultaneous write to same address (race condition) ---");
        we_a = 1; din_a = 8'h55; addr_a = 4'hF;
        we_b = 1; din_b = 8'hEE; addr_b = 4'hF;
        @(posedge clk);
        we_a = 0; we_b = 0;
        $display("Simultaneous write to address F complete. Value is non-deterministic.");
        
        // 5. Read back the race condition address
        addr_a = 4'hF;
        addr_b = 4'hF;
        @(posedge clk);
        $display("Read A from Addr F: %h (Expected: 55 or EE)", dout_a);
        $display("Read B from Addr F: %h (Expected: 55 or EE)", dout_b);
        
        // 6. Test Read from unwritten addresses
        $display("--- Reading from unwritten addresses ---");
        addr_a = 4'h7;
        addr_b = 4'h8;
        @(posedge clk);
        $display("Read A Addr 7: %h (Expected: 'x' or 0 after reset)", dout_a);
        $display("Read B Addr 8: %h (Expected: 'x' or 0 after reset)", dout_b);

        @(posedge clk);
        $display("Test complete.");
        $finish;
    end

    // Monitor signals for detailed log
    initial begin
        $monitor("Time=%0t: reset=%b, we_a=%b, addr_a=%d, din_a=%d, dout_a=%d | we_b=%b, addr_b=%d, din_b=%d, dout_b=%d",
            $time, reset, we_a, addr_a, din_a, dout_a, we_b, addr_b, din_b, dout_b);
    end

endmodule
