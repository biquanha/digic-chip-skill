class dut_monitor extends uvm_monitor;
  virtual dut_if vif;
  uvm_analysis_port #(dut_trans) ap;
  `uvm_component_utils(dut_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "dut_monitor 未获取到 vif")
  endfunction

  task run_phase(uvm_phase phase);
    dut_trans tr;
    forever begin
      @(posedge vif.clk);
      if (vif.out_valid) begin
        tr = dut_trans::type_id::create("tr");
        tr.out_data = vif.out_data;
        ap.write(tr);
      end
    end
  endtask
endclass
