`ifndef ENV_CFG__SV
`define ENV_CFG__SV
class env_cfg extends uvm_object;
    `uvm_object_utils(env_cfg)

    bit has_scoreboard = 1;
    bit has_apb_agent = 1;

    apb_cfg m_apb_cfg;
    apb_reg_block m_apb_reg_block;

    function new(string name="<anon>");
        super.new(name);
    endfunction : new
endclass : env_cfg
`endif
