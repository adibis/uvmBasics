class APB_Driver extends uvm_driver#(APB_Tr);
  `uvm_component_utils(APB_Driver)

  virtual APB_If virtual_apb_if;

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
    APB_Tr apb_tr;

    // Keep receiving the next transaction from the sequence until you run out.
    // Drive each transaction on the interface as per the protocol.
    // Wait for some drain time.
    // TODO: Add reset information instead of this.
    virtual_apb_if.master_cb.psel    <= 1'b0;
    virtual_apb_if.master_cb.penable    <= 1'b0;
    virtual_apb_if.master_cb.paddr    <= 16'b0;
    virtual_apb_if.master_cb.pwdata    <= 16'b0;
    virtual_apb_if.master_cb.pwrite    <= 1'b0;
    repeat(3)
        @virtual_apb_if.master_cb;

    // In the APB_Agent, the seq_item_port of the APB_Driver is hooked up to the
    // seq_item_export port on the sequencer (APB_Seq). Since the APB_Seq generates
    // APB_Tr, the APB_Driver accepts them with the get_next_item function.
    forever begin
      virtual_apb_if.master_cb.psel    <= 1'b0;
      virtual_apb_if.master_cb.pwrite    <= 1'b0;
      virtual_apb_if.master_cb.paddr    <= 16'b0;
      virtual_apb_if.master_cb.pwdata    <= 16'b0;
      virtual_apb_if.master_cb.penable <= 1'b0;
      repeat(6)
          @virtual_apb_if.master_cb;
      seq_item_port.get_next_item(apb_tr);
      `uvm_info(get_type_name(), "Driving a new transaction", UVM_DEBUG)
      @virtual_apb_if.master_cb;
      virtual_apb_if.master_cb.psel    <= 1'b1;
      virtual_apb_if.master_cb.penable <= 1'b0;
      virtual_apb_if.master_cb.paddr   <= apb_tr.tr_addr;
      if (apb_tr.tr_rw == APB_Tr::TR_WRITE) begin
        virtual_apb_if.master_cb.pwrite <= 1'b1;
        virtual_apb_if.master_cb.pwdata <= apb_tr.tr_wdata;
      end else begin
        virtual_apb_if.master_cb.pwrite <= 1'b0;
      end
      @virtual_apb_if.master_cb;
      virtual_apb_if.master_cb.penable <= 1'b1;
      `uvm_info(get_type_name(), "Waiting for response", UVM_DEBUG)
      @virtual_apb_if.master_cb.pready;
      if (apb_tr.tr_rw == APB_Tr::TR_READ) begin
        apb_tr.tr_rdata = virtual_apb_if.master_cb.prdata;
      end
      apb_tr.tr_error = virtual_apb_if.master_cb.perror;
      seq_item_port.item_done();
      `uvm_info(get_type_name(), "Finished driving a new transaction", UVM_DEBUG)
    end
  endtask: run_phase
endclass: APB_Driver
