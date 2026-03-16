class dut_trans extends uvm_sequence_item;
  rand bit [31:0] in_data;
  bit [31:0] out_data;

  `uvm_object_utils_begin(dut_trans)
    `uvm_field_int(in_data, UVM_ALL_ON)
    `uvm_field_int(out_data, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "dut_trans");
    super.new(name);
  endfunction
endclass
