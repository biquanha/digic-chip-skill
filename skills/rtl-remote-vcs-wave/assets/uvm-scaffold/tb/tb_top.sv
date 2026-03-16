`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "dut_if.sv"
`include "dut_trans.sv"
`include "dut_driver.sv"
`include "dut_monitor.sv"
`include "dut_agent.sv"
`include "dut_model.sv"
`include "dut_scoreboard.sv"
`include "dut_coverage.sv"
`include "smoke_seq.sv"
`include "basic_seq.sv"
`include "reset_seq.sv"
`include "base_test.sv"
`include "smoke_test.sv"
`include "basic_test.sv"
`include "reset_test.sv"
`include "dut_env.sv"

module tb_top;
  logic clk;
  logic rst_n;
  dut_if dut_vif(clk, rst_n);

  module_name dut (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(dut_vif.in_valid),
    .in_data(dut_vif.in_data),
    .in_ready(dut_vif.in_ready),
    .out_valid(dut_vif.out_valid),
    .out_data(dut_vif.out_data)
  );

  initial begin
    uvm_config_db#(virtual dut_if)::set(uvm_root::get(), "*", "vif", dut_vif);
    run_test();
  end

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst_n = 0;
    repeat (5) @(posedge clk);
    rst_n = 1;
  end

  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0, tb_top);
  end
endmodule
