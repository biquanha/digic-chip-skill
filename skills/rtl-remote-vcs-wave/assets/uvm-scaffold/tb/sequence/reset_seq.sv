class reset_seq extends uvm_sequence #(dut_trans);
  `uvm_object_utils(reset_seq)
  function new(string name = "reset_seq"); super.new(name); endfunction

  task body();
    dut_trans tr;
    repeat (4) begin
      tr = dut_trans::type_id::create("tr");
      assert(tr.randomize());
      start_item(tr);
      finish_item(tr);
    end
  endtask
endclass
