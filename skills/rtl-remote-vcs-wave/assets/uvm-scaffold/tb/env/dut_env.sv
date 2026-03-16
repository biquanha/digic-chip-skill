class dut_env extends uvm_env;
  dut_agent agt;
  dut_model mdl;
  dut_scoreboard scb;
  dut_coverage cov;
  `uvm_component_utils(dut_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = dut_agent::type_id::create("agt", this);
    mdl = dut_model::type_id::create("mdl", this);
    scb = dut_scoreboard::type_id::create("scb", this);
    cov = dut_coverage::type_id::create("cov", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    agt.mon.ap.connect(mdl.in_imp);
    mdl.out_ap.connect(scb.exp_fifo.analysis_export);
    agt.mon.ap.connect(scb.act_fifo.analysis_export);
    agt.mon.ap.connect(cov.cov_imp);
  endfunction
endclass
