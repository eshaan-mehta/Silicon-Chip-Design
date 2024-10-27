`default_nettype none

module tt_um_dff_mem_eshaanmehta #(
    parameter RAM_BYTES = 16
) (
    input  wire [7:0] ui_in,    // Dedicated inputs - address
    output reg  [7:0] uo_out,   // Dedicated outputs - not used
    input  wire [7:0] uio_in,   // IOs: write data
    output reg [7:0] uio_out,  // IOs: read data
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output), not used
    input  wire       ena,      // will go high when the design is enabled
    input  wire       rst_n,     // reset_n - low to reset
    input  wire       clk        //for clock sychroniztion
);
    
  wire [3:0] addr = ui_in[3:0];
  wire ce_n = ui_in[7];
  wire lr_n = ui_in[6];
    
  // assign uio_oe  = 8'b0;  
  // assign uio_out = 8'b0;

  reg [7:0] RAM[RAM_BYTES - 1:0];

  always @(posedge clk) begin
      // case 1: write to ram
      if (!lr_n) begin
          RAM[addr] <= uio_in; 
      end else begin
      // case 2: read from ram
          if(!ce_n) begin
              uio_out <= RAM[addr];
          end
      end
  end

endmodule  // tt_um_dff_mem
