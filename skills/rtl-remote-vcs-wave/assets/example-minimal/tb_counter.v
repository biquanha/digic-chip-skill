`timescale 1ns/1ps
module tb_counter;
  reg clk;
  reg rst_n;
  reg en;
  wire [3:0] count;

  counter dut(.clk(clk), .rst_n(rst_n), .en(en), .count(count));

  initial begin
    $fsdbDumpfile("counter.fsdb");
    $fsdbDumpvars(0, tb_counter);
    clk = 0; rst_n = 0; en = 0;
    #20 rst_n = 1;
    #10 en = 1;
    #80 en = 0;
    #20;
    if (count !== 4'd8) $display("[TB][FAIL] count=%0d", count);
    else $display("[TB][PASS] count=%0d", count);
    $finish;
  end

  always #5 clk = ~clk;
endmodule
