`ifndef APB_MONITOR__SV
`define APB_MONITOR__SV
class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)

  uvm_analysis_port#(apb_seq_item) m_apb_ap;
  virtual apb_if m_apb_vif;

  function new(string name = "<anon>", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase( uvm_phase phase);
    super.build_phase(phase);
    m_apb_ap = new(.name("m_apb_ap"), .parent(this));
    // We don't get the VIF in build phase but use the agent connect phase to
    // connect the agent_config.vif to monitor.vif
  endfunction : build_phase

  task run_phase(uvm_phase phase);
      apb_seq_item m_apb_seq_item = apb_seq_item::type_id::create(.name("m_apb_seq_item"));
      apb_seq_item m_clone_item;
    forever begin
      @m_apb_vif.slave_cb;
      @(posedge m_apb_vif.slave_cb.pready);
      `uvm_info(get_type_name(), "Monitoring a new transaction", UVM_DEBUG)
      m_apb_seq_item.tr_addr = m_apb_vif.slave_cb.paddr;
      m_apb_seq_item.tr_wdata = m_apb_vif.slave_cb.pwdata;
      m_apb_seq_item.tr_rdata = m_apb_vif.slave_cb.prdata;
      m_apb_seq_item.tr_error = m_apb_vif.slave_cb.perror;
      m_apb_seq_item.tr_rw   = apb_seq_item::trRw_e'(m_apb_vif.slave_cb.pwrite);
      $cast(m_clone_item, m_apb_seq_item.clone());
      `uvm_info(get_type_name(), "Writing a new transaction", UVM_DEBUG)
      `uvm_info(get_type_name(), $sformatf("ADDR: %h, TYPE: %h, PRDATA: %h, PWDATA: %h",
          m_apb_seq_item.tr_addr, m_apb_seq_item.tr_rw, m_apb_seq_item.tr_rdata, m_apb_seq_item.tr_wdata), UVM_MEDIUM)
      m_apb_ap.write(m_clone_item);
    end
  endtask : run_phase

endclass : apb_monitor
`endif
