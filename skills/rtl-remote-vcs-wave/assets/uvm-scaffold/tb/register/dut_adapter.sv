class dut_adapter extends uvm_reg_adapter;
  `uvm_object_utils(dut_adapter)
  function new(string name = "dut_adapter");
    super.new(name);
  endfunction

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    dut_trans tr;
    tr = dut_trans::type_id::create("tr");
    tr.in_data = rw.data;
    return tr;
  endfunction

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    dut_trans tr;
    if (!$cast(tr, bus_item)) return;
    rw.data = tr.out_data;
    rw.status = UVM_IS_OK;
  endfunction
endclass
