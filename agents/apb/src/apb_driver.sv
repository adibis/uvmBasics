`ifndef APB_DRIVER__SV
`define APB_DRIVER__SV
class apb_driver extends uvm_driver#(apb_seq_item);
  `uvm_component_utils(apb_driver)

  virtual apb_if m_apb_vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // In the build phase, the Driver is connected to the virtual interface.
  // The DUT is also connected to the same interface.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // We don't get the VIF in build phase but use the agent connect phase to
    // connect the agent_config.vif to driver.vif
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    apb_seq_item m_req;

    // Keep receiving the next transaction from the sequence until you run out.
    // Drive each transaction on the interface as per the protocol.
    // Wait for some drain time.
    // TODO: Add reset information instead of this.
    m_apb_vif.master_cb.psel    <= 1'b0;
    m_apb_vif.master_cb.preset  <= 1'b0;
    m_apb_vif.master_cb.penable <= 1'b0;
    m_apb_vif.master_cb.paddr   <= 16'b0;
    m_apb_vif.master_cb.pwdata  <= 16'b0;
    m_apb_vif.master_cb.pwrite  <= 1'b0;
    repeat(3)
        @m_apb_vif.master_cb;

    // In the APB_Agent, the seq_item_port of the apb_driver is hooked up to the
    // seq_item_export port on the sequencer (APB_Seq). Since the APB_Seq generates
    // apb_seq_item, the apb_driver accepts them with the get_next_item function.
    forever begin
      m_apb_vif.master_cb.psel    <= 1'b0;
      m_apb_vif.master_cb.pwrite  <= 1'b0;
      m_apb_vif.master_cb.paddr   <= 16'b0;
      m_apb_vif.master_cb.pwdata  <= 16'b0;
      m_apb_vif.master_cb.penable <= 1'b0;
      repeat(6)
          @m_apb_vif.master_cb;
      seq_item_port.get_next_item(m_req);
      `uvm_info(get_type_name(), "Driving a new transaction", UVM_DEBUG)
      @m_apb_vif.master_cb;
      m_apb_vif.master_cb.psel    <= 1'b1;
      m_apb_vif.master_cb.penable <= 1'b0;
      m_apb_vif.master_cb.paddr   <= m_req.tr_addr;
      if (m_req.tr_rw == apb_seq_item::TR_WRITE) begin
        m_apb_vif.master_cb.pwrite <= 1'b1;
        m_apb_vif.master_cb.pwdata <= m_req.tr_wdata;
      end else begin
        m_apb_vif.master_cb.pwrite <= 1'b0;
      end
      @m_apb_vif.master_cb;
      m_apb_vif.master_cb.penable <= 1'b1;
      `uvm_info(get_type_name(), "Waiting for response", UVM_DEBUG)
      @m_apb_vif.master_cb.pready;
      if (m_req.tr_rw == apb_seq_item::TR_READ) begin
        m_req.tr_rdata = m_apb_vif.master_cb.prdata;
      end
      m_req.tr_error = m_apb_vif.master_cb.perror;
      seq_item_port.item_done();
      `uvm_info(get_type_name(), "Finished driving a new transaction", UVM_DEBUG)
    end
  endtask: run_phase
endclass: apb_driver
`endif
