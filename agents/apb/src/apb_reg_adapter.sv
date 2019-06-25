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
        apb_seq_item m_apb_seq_item = apb_seq_item::type_id::create("m_apb_seq_item");
        `uvm_info(get_type_name(), $sformatf("ADDR: %h, KIND: %h", rw.addr, rw.kind), UVM_MEDIUM)
        if (rw.kind == UVM_READ) begin
            m_apb_seq_item.tr_rw = apb_seq_item::TR_READ;
            // TODO: this is probably not needed.
            // rw.data = m_apb_seq_item.tr_rdata;
        end else begin
            m_apb_seq_item.tr_rw = apb_seq_item::TR_WRITE;
            m_apb_seq_item.tr_wdata = rw.data;
        end
        m_apb_seq_item.tr_addr = rw.addr;
        return m_apb_seq_item;
    endfunction : reg2bus

    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        apb_seq_item m_apb_seq_item;
        `uvm_info(get_type_name(), $sformatf("ADDR: %h, KIND: %h", rw.addr, rw.kind), UVM_MEDIUM)
        assert($cast(m_apb_seq_item, bus_item)) else return;
        if (m_apb_seq_item.tr_rw == apb_seq_item::TR_READ) begin
            rw.kind = UVM_READ;
            rw.data = m_apb_seq_item.tr_rdata;
        end else begin
            rw.kind = UVM_WRITE;
        end
        rw.addr = m_apb_seq_item.tr_addr;
        rw.status = UVM_IS_OK;
    endfunction : bus2reg

endclass : apb_reg_adapter
`endif
