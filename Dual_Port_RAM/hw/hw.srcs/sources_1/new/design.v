`timescale 1ns / 1ps

module DualPortRAM #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input                 clk,
    input                 reset, // Added reset signal
    
    // Port A
    input                 we_a,
    input  [ADDR_WIDTH-1:0] addr_a,
    input  [DATA_WIDTH-1:0] din_a,
    output reg [DATA_WIDTH-1:0] dout_a,

    // Port B
    input                 we_b,
    input  [ADDR_WIDTH-1:0] addr_b,
    input  [DATA_WIDTH-1:0] din_b,
    output reg [DATA_WIDTH-1:0] dout_b
);

    // Shared memory
    reg [DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0];

    // Read address registers for a more realistic synchronous read
    reg [ADDR_WIDTH-1:0] read_addr_a_reg;
    reg [ADDR_WIDTH-1:0] read_addr_b_reg;

    always @(posedge clk) begin
        if (reset) begin
            // Reset both output ports and read address registers
            dout_a <= 0;
            dout_b <= 0;
            read_addr_a_reg <= 0;
            read_addr_b_reg <= 0;
        end else begin
            // Port A operations
            if (we_a) begin
                mem[addr_a] <= din_a;
            end
            read_addr_a_reg <= addr_a;

            // Port B operations
            if (we_b) begin
                mem[addr_b] <= din_b;
            end
            read_addr_b_reg <= addr_b;
        end
    end

    // Separate always blocks for read operations to implement one-cycle latency
    always @(posedge clk) begin
        if (!reset) begin
            dout_a <= mem[read_addr_a_reg];
        end
    end
    
    always @(posedge clk) begin
        if (!reset) begin
            dout_b <= mem[read_addr_b_reg];
        end
    end

endmodule

