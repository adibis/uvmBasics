`ifndef ENV__SV
`define ENV__SV
class env extends uvm_env;
    `uvm_component_utils(env)

    apb_agent m_apb_agent;
    chip_scoreboard m_scoreboard;
    env_cfg m_env_cfg;
    apb_reg_predictor m_apb_reg_predictor;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Make sure that environment configuration object is available.
        // This is set from the UVM_BASE_TEST.
        assert(uvm_config_db#(env_cfg)::get(this, "", "env_cfg", m_env_cfg));
        // Unless the test has disabled any agents, build them one by one.
        if(m_env_cfg.has_apb_agent) begin
            // Only if the agent is not disabled, set the agent configuration
            // for all the sub-components from here.
            uvm_config_db#(apb_cfg)::set(this, "m_apb_agent*", "apb_cfg", m_env_cfg.m_apb_cfg);
            m_apb_agent = apb_agent::type_id::create(.name("m_apb_agent"), .parent(this));
            m_apb_reg_predictor = apb_reg_predictor::type_id::create(.name("m_apb_reg_predictor"), .parent(this));
        end
        if(m_env_cfg.has_scoreboard) begin
            m_scoreboard = chip_scoreboard::type_id::create(.name("m_scoreboard"), .parent(this));
        end
    endfunction: build_phase

    function void connect_phase( uvm_phase phase );
        super.connect_phase(phase);
        m_apb_agent.m_apb_ap.connect(m_scoreboard.m_fifo);
        m_env_cfg.m_apb_reg_block.m_reg_map.set_sequencer(.sequencer(m_apb_agent.m_apb_seqr), .adapter(m_apb_agent.m_reg_adapter));
        m_env_cfg.m_apb_reg_block.m_reg_map.set_auto_predict(.on(0));
        m_apb_reg_predictor.map = m_env_cfg.m_apb_reg_block.m_reg_map;
        m_apb_reg_predictor.adapter = m_apb_agent.m_reg_adapter;
        m_apb_agent.m_apb_ap.connect(m_apb_reg_predictor.bus_in);
    endfunction: connect_phase
endclass: env
`endif
