`timescale 1ns/1ps
module module_name (
  input  wire        clk,
  input  wire        rst_n,
  input  wire        in_valid,
  input  wire [31:0] in_data,
  output wire        in_ready,
  output reg         out_valid,
  output reg  [31:0] out_data
);
  assign in_ready = 1'b1;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out_valid <= 1'b0;
      out_data  <= 32'd0;
    end else begin
      out_valid <= in_valid;
      out_data  <= in_data;
    end
  end
endmodule
