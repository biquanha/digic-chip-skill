class dut_driver extends uvm_driver #(dut_trans);
  virtual dut_if vif;
  `uvm_component_utils(dut_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "dut_driver 未获取到 vif")
  endfunction

  task run_phase(uvm_phase phase);
    dut_trans tr;
    vif.in_valid <= 0;
    vif.in_data  <= '0;
    forever begin
      seq_item_port.get_next_item(tr);
      @(posedge vif.clk);
      vif.in_valid <= 1'b1;
      vif.in_data  <= tr.in_data;
      @(posedge vif.clk);
      vif.in_valid <= 1'b0;
      seq_item_port.item_done();
    end
  endtask
endclass
