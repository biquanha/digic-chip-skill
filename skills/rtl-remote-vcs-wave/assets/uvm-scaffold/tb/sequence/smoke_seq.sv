class smoke_seq extends uvm_sequence #(dut_trans);
  `uvm_object_utils(smoke_seq)
  function new(string name = "smoke_seq"); super.new(name); endfunction
  task body();
    dut_trans tr;
    repeat (8) begin
      tr = dut_trans::type_id::create("tr");
      assert(tr.randomize());
      start_item(tr);
      finish_item(tr);
    end
  endtask
endclass
