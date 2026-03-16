class dut_model extends uvm_component;
  uvm_analysis_imp #(dut_trans, dut_model) in_imp;
  uvm_analysis_port #(dut_trans) out_ap;
  `uvm_component_utils(dut_model)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    in_imp = new("in_imp", this);
    out_ap  = new("out_ap", this);
  endfunction

  function void write(dut_trans tr);
    dut_trans exp;
    exp = dut_trans::type_id::create("exp");
    exp.out_data = tr.in_data;
    out_ap.write(exp);
  endfunction
endclass
