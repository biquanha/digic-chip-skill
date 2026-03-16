class dut_agent extends uvm_agent;
  uvm_sequencer #(dut_trans) sqr;
  dut_driver drv;
  dut_monitor mon;
  `uvm_component_utils(dut_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr = uvm_sequencer#(dut_trans)::type_id::create("sqr", this);
    drv = dut_driver::type_id::create("drv", this);
    mon = dut_monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
endclass
