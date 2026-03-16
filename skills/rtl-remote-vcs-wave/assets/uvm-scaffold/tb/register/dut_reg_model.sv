class dut_reg_model extends uvm_reg_block;
  `uvm_object_utils(dut_reg_model)
  function new(string name = "dut_reg_model");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    lock_model();
  endfunction
endclass
