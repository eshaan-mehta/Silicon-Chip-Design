`default_nettype none
`timescale 1ns / 1ps

module tb ();

    // This part dumps the trace to a VCD file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;  // Minimal delay to ensure dump happens
        $finish;  // End the simulation early, as we don't need to run any tests
    end

    // Wire up the inputs and outputs:
    reg clk;
    reg rst_n;
    reg ena;
    reg [6:0] addr;  // Address
    reg we;          // Write enable
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire [7:0] bidirectional_is_output;

    // Clock generation (though we aren't driving any signals, it's good to define it)
    always #5 clk = ~clk;

    // Instantiate the DUT (Device Under Test)
    tt_um_dff_mem_eshaanmehta user_project(
    `ifdef GL_TEST
        .VPWR( 1'b1),
        .VGND( 1'b0),
    `endif
        .ui_in  ({we, addr}),   // Combine write enable and address
        .uo_out (data_out),     // Data output
        .uio_in (data_in),      // Data input (for writing)
        .uio_oe (bidirectional_is_output),  // Not used, bidirectional enable
        .ena    (ena),          // Enable
        .clk    (clk),          // Clock
        .rst_n  (rst_n)         // Reset (active low)
    );

endmodule
