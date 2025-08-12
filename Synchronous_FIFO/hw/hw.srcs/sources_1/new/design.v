`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Aditya Burugu (assumed from context)
// Module Name: sync_fifo
// Description: Synchronous FIFO with parameterizable depth and width.
// Revision: 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module sync_fifo #(
    parameter DEPTH = 8,
    parameter DWIDTH = 16
)(
    input                  clk,        // Clock
    input                  rstn,       // Active-low reset
    input                  wr_en,      // Write enable
    input                  rd_en,      // Read enable
    input  [DWIDTH-1:0]    din,        // Data in
    output reg [DWIDTH-1:0] dout,      // Data out
    output                 empty,      // FIFO empty flag
    output                 full        // FIFO full flag
);

  // Address width calculated from depth
  localparam ADDR_WIDTH = $clog2(DEPTH);

  reg [DWIDTH-1:0] fifo [0:DEPTH-1];
  reg [ADDR_WIDTH:0] wptr;  // Extra bit to help in full/empty detection
  reg [ADDR_WIDTH:0] rptr;

  wire [ADDR_WIDTH-1:0] waddr = wptr[ADDR_WIDTH-1:0];
  wire [ADDR_WIDTH-1:0] raddr = rptr[ADDR_WIDTH-1:0];

  // Write Logic
  always @(posedge clk) begin
    if (!rstn) begin
      wptr <= 0;
    end else if (wr_en && !full) begin
      fifo[waddr] <= din;
      wptr <= wptr + 1;
    end
  end

  // Read Logic
  always @(posedge clk) begin
    if (!rstn) begin
      rptr <= 0;
      dout <= 0;
    end else if (rd_en && !empty) begin
      dout <= fifo[raddr];
      rptr <= rptr + 1;
    end
  end

  // Status flags
  assign empty = (wptr == rptr);
  assign full  = ((wptr[ADDR_WIDTH] != rptr[ADDR_WIDTH]) &&
                  (wptr[ADDR_WIDTH-1:0] == rptr[ADDR_WIDTH-1:0]));

endmodule