`ifndef APB_CFG__SV
`define APB_CFG__SV
class apb_cfg extends uvm_object;
    `uvm_object_utils(apb_cfg)

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    logic [15:0] min_m_addr = 16'h0000;
    logic [15:0] max_m_addr = 16'h007f;

    virtual APB_If virtual_apb_if;

    function new(string name="<anon>");
        super.new(name);
    endfunction : new
endclass : apb_cfg
`endif
