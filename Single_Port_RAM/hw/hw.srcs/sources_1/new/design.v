`timescale 1ns / 1ps

module SinglePortRAM #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input                 clk,
    input                 reset,   // Added synchronous reset signal
    input                 we,      // Write Enable
    input  [ADDR_WIDTH-1:0] addr,    // Address input
    input  [DATA_WIDTH-1:0] din,     // Data input
    output reg [DATA_WIDTH-1:0] dout   // Data output
);

    // RAM storage
    reg [DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0];

    // Use a separate register to hold the address for the read operation
    reg [ADDR_WIDTH-1:0] read_addr_reg;

    // This always block handles both the write and the registration of the read address
    always @(posedge clk) begin
        if (reset) begin
            // Reset the read address register to a known state
            read_addr_reg <= 0;
        end else begin
            // Synchronous Write operation
            if (we) begin
                mem[addr] <= din;
            end

            // Register the address for the read operation
            // The read will happen on the next clock cycle using this registered address
            read_addr_reg <= addr;
        end
    end

    // This always block handles the synchronous read operation
    // The output reflects the data from the previous clock cycle
    always @(posedge clk) begin
        if (reset) begin
            // On reset, clear the output to a known value
            dout <= 0;
        end else begin
            dout <= mem[read_addr_reg];
        end
    end

endmodule

