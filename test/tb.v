`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #100000;  // Run simulation for 100us
    $finish;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Instantiate the user project module
  tt_um_dff_mem_eshaanmehta user_project(
`ifdef GL_TEST
      .VPWR(1'b1),
      .VGND(1'b0),
`endif
      .ui_in  (ui_in),    // Address and control inputs
      .uo_out (uo_out),   // Read output
      .uio_in (uio_in),   // Write data input
      .uio_out(uio_out),  // Read data output
      .uio_oe (uio_oe),   // Not used, bidirectional enable
      .ena    (ena),      // Enable design
      .clk    (clk),      // Clock
      .rst_n  (rst_n)     // Reset (active low)
  );

  // Clock generation
  always #5 clk = ~clk;  // 100 MHz clock

  // Apply reset and stimulus
  initial begin
    // Initialize all inputs
    clk = 0;
    rst_n = 0;
    ena = 0;
    ui_in = 8'b0;
    uio_in = 8'b0;

    // Apply reset
    #20;
    rst_n = 1;  // Release reset
    ena = 1;    // Enable design

    // Test Case: Write to RAM
    #10;
    ui_in = 8'b01000001; // Address 0x01, write mode (lr_n = 0, ce_n = 1)
    uio_in = 8'hAA;      // Write 0xAA to RAM[0x01]

    #10;
    ui_in = 8'b11000001; // Address 0x01, read mode (lr_n = 1, ce_n = 0)
    #10;
    
    // Test Case: Verify the data
    if (uio_out !== 8'hAA || uo_out !== 8'hAA) begin
      $display("Test failed! Expected 0xAA, but got uio_out=%h, uo_out=%h", uio_out, uo_out);
    end else begin
      $display("Test passed! Read data correctly.");
    end

    #10;
    $finish;
  end

endmodule
