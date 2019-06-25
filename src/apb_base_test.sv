`ifndef APB__BASE__TEST__SV
`define APB__BASE__TEST__SV
import uvm_pkg::*;
import apb_pkg::*;
import apb_regs_pkg::*;

class apb_base_test extends uvm_test;
    `uvm_component_utils(apb_base_test)

    env m_env;
    env_cfg m_env_cfg;
    apb_cfg m_apb_cfg;
    apb_reg_block m_apb_reg_block;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_apb_reg_block = apb_reg_block::type_id::create("m_apb_reg_block");
        m_apb_reg_block.build();
        // Create configuration objects of all agents.
        // Get the interfaces for all agents (set from the tb_top).
        // Connect all env_configuration.child_configurations to
        // all agent_configurations.
        // Finally set the env configuration for everything below.
        m_env_cfg = env_cfg::type_id::create(.name("m_env_cfg"), .parent(this));
        m_apb_cfg = apb_cfg::type_id::create(.name("m_apb_cfg"), .parent(this));
        assert(uvm_config_db#(virtual apb_if)::get(this, "", "apb_if", m_apb_cfg.m_apb_vif));
        m_env_cfg.m_apb_cfg = m_apb_cfg;
        m_env_cfg.m_apb_reg_block = m_apb_reg_block;
        uvm_config_db#(env_cfg)::set(this, "*", "env_cfg", m_env_cfg);
        m_env = env::type_id::create(.name("m_env"), .parent(this));
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        `uvm_fatal(get_type_name(), "No run phase defined for uvm_test.");
    endtask : run_phase
endclass: apb_base_test
`endif
