`ifndef APB_REG_ADAPTER__SV
`define APB_REG_ADAPTER__SV
class apb_reg_adapter extends uvm_reg_adapter;
    `uvm_object_utils(apb_reg_adapter)

    function new(string name="apb_reg_adapter");
        super.new(name);
        // TODO: read more on this
        supports_byte_enable = 0;
        provides_responses = 0;
    endfunction : new

    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        APB_Tr m_apb_tr = APB_Tr::type_id::create("m_apb_tr");
        `uvm_info(get_type_name(), $sformatf("ADDR: %h, KIND: %h", rw.addr, rw.kind), UVM_MEDIUM)
        if (rw.kind == UVM_READ) begin
            m_apb_tr.tr_rw = APB_Tr::TR_READ;
            // TODO: this is probably not needed.
            // rw.data = m_apb_tr.tr_rdata;
        end else begin
            m_apb_tr.tr_rw = APB_Tr::TR_WRITE;
            m_apb_tr.tr_wdata = rw.data;
        end
        m_apb_tr.tr_addr = rw.addr;
        return m_apb_tr;
    endfunction : reg2bus

    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        APB_Tr m_apb_tr;
        `uvm_info(get_type_name(), $sformatf("ADDR: %h, KIND: %h", rw.addr, rw.kind), UVM_MEDIUM)
        assert($cast(m_apb_tr, bus_item)) else return;
        if (m_apb_tr.tr_rw == APB_Tr::TR_READ) begin
            rw.kind = UVM_READ;
            rw.data = m_apb_tr.tr_rdata;
        end else begin
            rw.kind = UVM_WRITE;
        end
        rw.addr = m_apb_tr.tr_addr;
        rw.status = UVM_IS_OK;
    endfunction : bus2reg

endclass : apb_reg_adapter
`endif
