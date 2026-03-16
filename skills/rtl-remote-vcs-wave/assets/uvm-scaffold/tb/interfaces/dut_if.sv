interface dut_if(input logic clk, input logic rst_n);
  logic        in_valid;
  logic [31:0] in_data;
  logic        in_ready;
  logic        out_valid;
  logic [31:0] out_data;
endinterface
