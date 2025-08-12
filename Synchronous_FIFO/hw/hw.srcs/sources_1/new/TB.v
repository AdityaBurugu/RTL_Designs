`timescale 1ns / 1ps

module tb_sync_fifo_simple;

  // Parameters
  parameter DEPTH = 8;
  parameter DWIDTH = 16;

  // Signals
  reg clk;
  reg rstn;
  reg wr_en;
  reg rd_en;
  reg [DWIDTH-1:0] din;
  wire [DWIDTH-1:0] dout;
  wire empty, full;

  // Instantiate FIFO
  sync_fifo #(.DEPTH(DEPTH), .DWIDTH(DWIDTH)) uut (
    .clk(clk),
    .rstn(rstn),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .din(din),
    .dout(dout),
    .empty(empty),
    .full(full)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Main stimulus
  initial begin
    // Initial state
    rstn = 0;
    wr_en = 0;
    rd_en = 0;
    din = 0;

    // Apply reset
    #10; rstn = 1;

    // Write 3 values
    @(posedge clk); wr_en = 1; din = 16'hA1; // write 1
    @(posedge clk); din = 16'hB2;            // write 2
    @(posedge clk); din = 16'hC3;            // write 3
    @(posedge clk); din = 16'hD4;            // write 4
    @(posedge clk); din = 16'hD5;            // write 5
    @(posedge clk); din = 16'hE6;            // write 6
    @(posedge clk); din = 16'hF7;            // write 7
    @(posedge clk); din = 16'hA0;            // write 8
    @(posedge clk); wr_en = 0; din = 0;

    // Wait one cycle
    @(posedge clk);

    // Read 3 values
    @(posedge clk); rd_en = 1;
    @(posedge clk);
    $display("Read 1: %h", dout);
    @(posedge clk);
    $display("Read 2: %h", dout);
    @(posedge clk);
    $display("Read 3: %h", dout);
     @(posedge clk);
    $display("Read 4: %h", dout);
    @(posedge clk);
    $display("Read 5: %h", dout);
    @(posedge clk);
    $display("Read 6: %h", dout);
     @(posedge clk);
    $display("Read 7: %h", dout);
    @(posedge clk);
    $display("Read 8: %h", dout);
    @(posedge clk);
    $display("Read 9: %h", dout);
    rd_en = 0;

    #20;
    $stop;
  end

endmodule