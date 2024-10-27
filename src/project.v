`default_nettype none
 
module tt_um_dff_mem_eshaanmehta #(
    parameter RAM_BYTES = 16
) (
    input wire [3:0] mar,        // Adress from RAM - 4-bit for 16-byte RAM
    input wire [7:0] data_in,    // Data input
    output reg [7:0] data_out,   // Data output
    input wire ce_n,             // Active-low Chip Enable signal (RAM drives the bus)
    input wire lr_n,             // Active-low Load RAM signal (RAM loads from MAR)
    input  wire [7:0] ui_in,    // Dedicated inputs - address
    output reg  [7:0] uo_out,   // Dedicated outputs - not used
    input  wire [7:0] uio_in,   // IOs: write data
    output reg [7:0] uio_out,  // IOs: read data
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output), not used
    input wire ena,      // will go high when the design is enabled
    input wire rst_n,     // reset_n - low to reset
    input wire clk        //for clock sychroniztion
);
    localparam addr_bits = 4;
 
  reg [7:0] RAM[RAM_BYTES - 1:0];
 
  always @(posedge clk) begin
      if (!lr_n) begin           // Write to RAM when lr is low (active-low)
          RAM[mar] <= data_in;
      end else begin           // Read from RAM when lr is high (inactive)
          if (!ce_n) begin       // RAM can drive the bus only when ce is low
              data_out <= RAM[mar];
          end
      end
  end
endmodule
