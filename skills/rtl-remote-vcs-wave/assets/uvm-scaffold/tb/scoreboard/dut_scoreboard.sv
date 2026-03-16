class dut_scoreboard extends uvm_component;
  uvm_tlm_analysis_fifo #(dut_trans) exp_fifo;
  uvm_tlm_analysis_fifo #(dut_trans) act_fifo;
  int compare_count;
  int error_count;
  `uvm_component_utils(dut_scoreboard)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    exp_fifo = new("exp_fifo", this);
    act_fifo = new("act_fifo", this);
  endfunction

  task run_phase(uvm_phase phase);
    dut_trans exp, act;
    forever begin
      exp_fifo.get(exp);
      act_fifo.get(act);
      compare_count++;
      if (exp.out_data !== act.out_data) begin
        error_count++;
        `uvm_error("SCB", $sformatf("比较失败 exp=%0h act=%0h", exp.out_data, act.out_data))
      end else begin
        `uvm_info("SCB", $sformatf("比较成功 exp=%0h act=%0h", exp.out_data, act.out_data), UVM_LOW)
      end
    end
  endtask

  function void report_phase(uvm_phase phase);
    `uvm_info("SCB_SUMMARY", $sformatf("compare_count=%0d error_count=%0d", compare_count, error_count), UVM_NONE)
  endfunction
endclass
