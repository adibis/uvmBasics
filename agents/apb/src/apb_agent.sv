`ifndef APB_AGENT__SV
`define APB_AGENT__SV
class apb_agent extends uvm_agent;
    `uvm_component_utils(apb_agent)

    uvm_analysis_port#(apb_seq_item) m_apb_ap;
    uvm_sequencer#(apb_seq_item) m_apb_seqr;
    apb_driver             m_apb_driver;
    apb_monitor            m_apb_monitor;
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
        m_apb_ap = new("m_apb_ap", this);
        if (m_apb_cfg.is_active == UVM_ACTIVE) begin
            m_apb_seqr = uvm_sequencer#(apb_seq_item)::type_id::create(.name("m_apb_seqr"), .parent(this));
            m_apb_driver = apb_driver::type_id::create(.name("m_apb_driver"), .parent(this));
        end
        m_apb_monitor  = apb_monitor::type_id::create(.name("m_apb_monitor"), .parent(this));
        m_reg_adapter = apb_reg_adapter::type_id::create("m_reg_adapter");
    endfunction: build_phase

    // Connect the driver and sequencer.
    function void connect_phase( uvm_phase phase );
        super.connect_phase( phase );
        m_apb_monitor.m_apb_vif = m_apb_cfg.m_apb_vif;
        if (m_apb_cfg.is_active == UVM_ACTIVE) begin
            m_apb_driver.seq_item_port.connect(m_apb_seqr.seq_item_export);
            m_apb_driver.m_apb_vif = m_apb_cfg.m_apb_vif;
        end
        m_apb_monitor.m_apb_ap.connect(m_apb_ap);
    endfunction: connect_phase
endclass: apb_agent
`endif
