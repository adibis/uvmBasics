class APB_Monitor extends uvm_monitor;
  `uvm_component_utils(APB_Monitor)

  uvm_analysis_port#(APB_Tr) apb_ap;
  virtual APB_If virtual_apb_if;

  function new(string name = "<anon>", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase( uvm_phase phase);
    super.build_phase(phase);
    apb_ap = new(.name("apb_ap"), .parent(this));
    // We don't get the VIF in build phase but use the agent connect phase to
    // connect the agent_config.vif to monitor.vif
  endfunction : build_phase

  task run_phase(uvm_phase phase);
      APB_Tr apb_tr = APB_Tr::type_id::create(.name("apb_tr"));
      APB_Tr clone_tr;
    forever begin
      @virtual_apb_if.slave_cb;
      @(posedge virtual_apb_if.slave_cb.pready);
      `uvm_info(get_type_name(), "Monitoring a new transaction", UVM_DEBUG)
      apb_tr.tr_addr = virtual_apb_if.slave_cb.paddr;
      apb_tr.tr_wdata = virtual_apb_if.slave_cb.pwdata;
      apb_tr.tr_rdata = virtual_apb_if.slave_cb.prdata;
      apb_tr.tr_error = virtual_apb_if.slave_cb.perror;
      apb_tr.tr_rw   = APB_Tr::trRw_e'(virtual_apb_if.slave_cb.pwrite);
      $cast(clone_tr, apb_tr.clone());
      `uvm_info(get_type_name(), "Writing a new transaction", UVM_DEBUG)
      `uvm_info(get_type_name(), $sformatf("ADDR: %h, TYPE: %h, PRDATA: %h, PWDATA: %h",
          apb_tr.tr_addr, apb_tr.tr_rw, apb_tr.tr_rdata, apb_tr.tr_wdata), UVM_MEDIUM)
      apb_ap.write(clone_tr);
    end
  endtask : run_phase

endclass : APB_Monitor
