class basic_test extends base_test;
  `uvm_component_utils(basic_test)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    basic_seq seq;
    phase.raise_objection(this);
    seq = basic_seq::type_id::create("seq");
    seq.start(env.agt.sqr);
    #200ns;
    phase.drop_objection(this);
  endtask
endclass
