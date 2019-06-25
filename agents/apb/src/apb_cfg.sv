`ifndef APB_CFG__SV
`define APB_CFG__SV
class apb_cfg extends uvm_object;
    `uvm_object_utils(apb_cfg)

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    // These decide the address range of the packets.
    logic [15:0] min_m_addr = 16'h0000;
    logic [15:0] max_m_addr = 16'h007f;

    virtual apb_if m_apb_vif;

    function new(string name="<anon>");
        super.new(name);
    endfunction : new
endclass : apb_cfg
`endif
