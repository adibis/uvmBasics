`ifndef APB_AGENT__SV
`define APB_AGENT__SV
class apb_agent extends uvm_agent;
    `uvm_component_utils(apb_agent)

    uvm_analysis_port#(APB_Tr) apb_ap;
    uvm_sequencer#(APB_Tr) apb_seqr;
    APB_Driver             apb_drvr;
    APB_Monitor            apb_mon;
    apb_cfg                m_apb_cfg;
    apb_reg_adapter        m_reg_adapter;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    // Create the driver and sequencer if agent is active.
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Ensure that the configuration for the agent is set.
        // This is done from the ENV and usually the env_cfg.agent_cfg is
        // used as agent config object.
        assert(uvm_config_db#(apb_cfg)::get(this, "", "apb_cfg", m_apb_cfg));
        apb_ap = new("apb_ap", this);
        if (m_apb_cfg.is_active == UVM_ACTIVE) begin
            apb_seqr = uvm_sequencer#(APB_Tr)::type_id::create(.name("apb_seqr"), .parent(this));
            apb_drvr = APB_Driver::type_id::create(.name("apb_drvr"), .parent(this));
        end
        apb_mon  = APB_Monitor::type_id::create(.name("apb_mon"), .parent(this));
        m_reg_adapter = apb_reg_adapter::type_id::create("m_reg_adapter");
    endfunction: build_phase

    // Connect the driver and sequencer.
    function void connect_phase( uvm_phase phase );
        super.connect_phase( phase );
        apb_mon.virtual_apb_if = m_apb_cfg.virtual_apb_if;
        if (m_apb_cfg.is_active == UVM_ACTIVE) begin
            apb_drvr.seq_item_port.connect(apb_seqr.seq_item_export);
            apb_drvr.virtual_apb_if = m_apb_cfg.virtual_apb_if;
        end
        apb_mon.apb_ap.connect(apb_ap);
    endfunction: connect_phase
endclass: apb_agent
`endif
