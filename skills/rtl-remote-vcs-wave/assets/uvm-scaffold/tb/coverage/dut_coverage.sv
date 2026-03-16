class dut_coverage extends uvm_component;
  `uvm_component_utils(dut_coverage)
  uvm_analysis_imp #(dut_trans, dut_coverage) cov_imp;
  dut_trans sample_tr;

  covergroup dut_cg;
    option.per_instance = 1;
    cp_in_data: coverpoint sample_tr.in_data[3:0];
    cp_out_data: coverpoint sample_tr.out_data[3:0];
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    cov_imp = new("cov_imp", this);
    dut_cg = new();
  endfunction

  function void write(dut_trans tr);
    sample_tr = tr;
    dut_cg.sample();
  endfunction
endclass
