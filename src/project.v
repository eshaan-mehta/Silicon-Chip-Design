`default_nettype none

module tt_um_dff_mem_eshaanmehta #(
    parameter RAM_BYTES = 16
) (
    input  wire [7:0] ui_in,    // Dedicated inputs - address
    // Removing uo_out if not used; if you plan to use it later, you can reintroduce it properly
    input  wire [7:0] uio_in,   // IOs: write data
    output reg [7:0] uio_out,   // IOs: read data
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output), not used
    input  wire       ena,      // will go high when the design is enabled
    input  wire       rst_n,    // reset_n - low to reset
    input  wire       clk       // for clock synchronization
);
    
    wire [3:0] addr = ui_in[3:0];
    wire ce_n = ui_in[7];
    wire lr_n = ui_in[6];
    
    // Suppressing unused signal warnings for bits [5:4] of ui_in
    /* verilator lint_off UNUSEDSIGNAL */
    wire unused_bits = ui_in[5:4];
    /* verilator lint_on UNUSEDSIGNAL */

    // Suppressing unused and undriven warnings for uio_oe
    /* verilator lint_off UNDRIVEN */
    assign uio_oe = 8'b0; // Default assignment to avoid undriven warning
    /* verilator lint_on UNDRIVEN */

    // Suppressing unused signal warnings for ena and rst_n
    /* verilator lint_off UNUSEDSIGNAL */
    wire unused_ena = ena;
    wire unused_rst_n = rst_n;
    /* verilator lint_on UNUSEDSIGNAL */

    reg [7:0] RAM[RAM_BYTES - 1:0];

    always @(posedge clk) begin
        // Case 1: write to RAM
        if (!lr_n) begin
            RAM[addr] <= uio_in; 
        end else begin
            // Case 2: read from RAM
            if (!ce_n) begin
                uio_out <= RAM[addr];
            end
        end
    end

endmodule  // tt_um_dff_mem_eshaanmehta
