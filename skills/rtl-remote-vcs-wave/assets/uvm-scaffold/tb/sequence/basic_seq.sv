class basic_seq extends uvm_sequence #(dut_trans);
  `uvm_object_utils(basic_seq)
  function new(string name = "basic_seq"); super.new(name); endfunction

  task body();
    dut_trans tr;
    repeat (32) begin
      tr = dut_trans::type_id::create("tr");
      assert(tr.randomize() with { in_data inside {[0:255]}; });
      start_item(tr);
      finish_item(tr);
    end
  endtask
endclass
