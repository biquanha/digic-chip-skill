class base_test extends uvm_test;
  dut_env env;
  `uvm_component_utils(base_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = dut_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    smoke_seq seq;
    phase.raise_objection(this);
    seq = smoke_seq::type_id::create("seq");
    seq.start(env.agt.sqr);
    #100ns;
    phase.drop_objection(this);
  endtask
endclass
